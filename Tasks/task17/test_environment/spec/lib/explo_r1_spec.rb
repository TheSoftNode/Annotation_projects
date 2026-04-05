# frozen_string_literal: true

require_relative '../../lib/explo_r1'

# Mock ShardSetting class
class ShardSetting
  def self.[](key)
    nil
  end
end

# R1's spec starts here (VERBATIM from R1_explo_spec_VERBATIM.rb)
require 'json/jwe' # <-- Add this to ensure JSON::JWE::EncryptionFailed is defined

describe Explo do
  shared_examples 'an encrypted JWT string' do
    it 'returns an encrypted JWT string with 5 base64url segments' do
      expect(subject).to match(/\A(?:[A-Za-z0-9_-]+\.){4}[A-Za-z0-9_-]+\z/)
    end
  end

  describe '.generate_embed_token' do
    let(:customer_id) { 'customer_123' }
    let(:embed_id) { 'embed_abc' }
    let(:expiration) { 1.hour.to_i }
    let(:analytics_role) { 'Plus' }

    subject do
      described_class.generate_embed_token(
        customer_id: customer_id,
        embed_id: embed_id,
        analytics_role: analytics_role,
        expiration: expiration
      )
    end

    before do
      # Ensure LOCAL_SETTINGS is defined with minimal required values
      stub_const("LOCAL_SETTINGS", {
        'explo' => {
          'embed_issuer_url' => 'https://explo.example.com',
          'secret_key_value' => 'supersecretkey123',
          'secret_key_id' => 'key-123', # <-- This was missing!
          'default_embeds' => [{'id' => 'global_1', 'name' => 'Global Dashboard 1'}, {'id' => 'global_2', 'name' => 'Global Dashboard 2'}]
        }
      })
    end

    context 'with valid Plus role' do
      let(:analytics_role) { 'Plus' }
      it_behaves_like 'an encrypted JWT string'
    end

    context 'with valid Essentials role' do
      let(:analytics_role) { 'Essentials' }
      it_behaves_like 'an encrypted JWT string'
    end

    context 'with invalid role' do
      let(:analytics_role) { 'Basic' }

      it 'raises TokenGenerationError' do
        expect { subject }.to raise_error(Explo::TokenGenerationError, /Invalid analytics role/)
      end
    end

    context 'when encryption fails' do
      let(:analytics_role) { 'Plus' }

      before do
        # Mock JWE.encrypt to raise EncryptionFailed
        allow(JSON::JWE).to receive(:encrypt).and_raise(JSON::JWE::EncryptionFailed.new("bad key"))
      end

      it 'raises TokenGenerationError with encryption message' do
        expect { subject }.to raise_error(Explo::TokenGenerationError, /JWT encryption failed: bad key/)
      end
    end

    context 'when secret_key_id is missing from LOCAL_SETTINGS' do
      let(:analytics_role) { 'Plus' }

      before do
        # Override LOCAL_SETTINGS to omit secret_key_id
        stub_const("LOCAL_SETTINGS", {
          'explo' => {
            'embed_issuer_url' => 'https://explo.example.com',
            'secret_key_value' => 'supersecretkey123'
            # secret_key_id is intentionally missing
          }
        })
      end

      it 'raises TokenGenerationError with clear message' do
        expect { subject }.to raise_error(Explo::TokenGenerationError, /undefined local variable or method `secret_key_id'/)
      end
    end

    context 'when secret_key_value is missing' do
      let(:analytics_role) { 'Plus' }

      before do
        # Override LOCAL_SETTINGS to omit secret_key_value
        stub_const("LOCAL_SETTINGS", {
          'explo' => {
            'embed_issuer_url' => 'https://explo.example.com',
            'secret_key_id' => 'key-123'
            # secret_key_value is intentionally missing
          }
        })
      end

      it 'raises ConfigurationError with appropriate message' do
        expect {
          described_class.generate_embed_token(
            customer_id: customer_id,
            embed_id: embed_id,
            analytics_role: analytics_role
          )
        }.to raise_error(Explo::ConfigurationError, /Explo configuration missing: 'secret_key_value'/)
      end
    end

    context 'when embed_issuer_url is missing' do
      let(:analytics_role) { 'Plus' }

      before do
        stub_const("LOCAL_SETTINGS", {
          'explo' => {
            'secret_key_value' => 'supersecretkey123',
            'secret_key_id' => 'key-123'
            # embed_issuer_url is missing
          }
        })
      end

      it 'raises ConfigurationError with appropriate message' do
        expect {
          described_class.generate_embed_token(
            customer_id: customer_id,
            embed_id: embed_id,
            analytics_role: analytics_role
          )
        }.to raise_error(Explo::ConfigurationError, /Explo configuration missing: 'embed_issuer_url'/)
      end
    end

    context 'with other unknown errors' do
      let(:analytics_role) { 'Plus' }

      before do
        # Simulate an unexpected error in get_permissions_for_role
        allow(described_class).to receive(:get_permissions_for_role).and_raise("Boom")
      end

      it 'raises TokenGenerationError for unexpected failure' do
        expect { subject }.to raise_error(Explo::TokenGenerationError, /Unexpected failure generating token: Boom/)
      end
    end
  end

  describe '#get_available_embeds' do
    before do
      # Ensure default_embeds is always defined
      stub_const("LOCAL_SETTINGS", {
        'explo' => {
          'default_embeds' => [
            {'id' => 'global_1', 'name' => 'Global Dashboard 1'},
            {'id' => 'global_2', 'name' => 'Global Dashboard 2'}
          ]
        }
      })
    end

    context 'when customer has no specific embeds' do
      it 'returns only the global default embeds' do
        allow(ShardSetting).to receive(:[]).with("explo_custom_embeds").and_return(nil)
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to eq(['global_1', 'global_2'])
      end
    end

    context 'when customer has specific embeds' do
      let(:customer_embeds) { [{'id' => 'customer_1', 'name' => 'Customer Dashboard'}] }

      it 'returns a combination of global and customer embeds' do
        allow(ShardSetting).to receive(:[]).with("explo_custom_embeds").and_return(customer_embeds)
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to contain_exactly('global_1', 'global_2', 'customer_1')
      end
    end

    context 'when a customer embed has the same ID as a global embed' do
      let(:customer_embeds) { [{'id' => 'global_1', 'name' => 'Custom Version of Global 1'}] }

      it 'returns a unique list, preferring the first one found (global)' do
        allow(ShardSetting).to receive(:[]).with("explo_custom_embeds").and_return(customer_embeds)
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to contain_exactly('global_1', 'global_2')
        expect(embeds.find { |e| e['id'] == 'global_1' }['name']).to eq('Global Dashboard 1')
      end
    end

    context 'when ShardSetting lookup raises an error' do
      it 'rescues the error and returns only the global embeds' do
        allow(ShardSetting).to receive(:[]).with("explo_custom_embeds").and_raise(StandardError, "database timeout")
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to eq(['global_1', 'global_2'])
      end
    end

    context 'when ShardSetting lookup raises a different error (e.g., TypeError)' do
      it 'still rescues and returns global embeds' do
        allow(ShardSetting).to receive(:[]).with("explo_custom_embeds").and_raise(TypeError, "invalid type")
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to eq(['global_1', 'global_2'])
      end
    end
  end
end
