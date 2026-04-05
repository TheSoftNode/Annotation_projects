# frozen_string_literal: true

require 'rspec'
require 'json/jwt'                     # <-- the gem you use in production
require_relative '../../lib/explo'   # path to the file you posted

RSpec.describe Explo do
  # -----------------------------------------------------------------
  #  Helper methods that mimic the `env!` and `ShardSetting` helpers
  # -----------------------------------------------------------------

  let(:dummy_env) { {} }

  # `env!` simply looks up a key in the global `LOCAL_SETTINGS` hash.
  # We stub the constant `LOCAL_SETTINGS` per‑example to control the
  # values that `env!` returns.
  def stub_local_settings(**overrides)
    # The production code expects `LOCAL_SETTINGS` to be a Hash with a
    # nested `'explo'` key.  Anything else will raise a ConfigurationError.
    stub_const('LOCAL_SETTINGS', { 'explo' => overrides })
  end

  # `ShardSetting` is a simple key‑value store.  We stub the class
  # method `[]` to return whatever the example needs.
  class ShardSetting
    class << self
      attr_accessor :store
    end

    def self.[](key)
      store.fetch(key) { nil }
    end
  end

  # -----------------------------------------------------------------
  #  Global test configuration
  # -----------------------------------------------------------------

  # By default we give the module everything it needs so that the
  # "happy path" works out of the box.
  before(:all) do
    stub_local_settings(
      explo: {
        'secret_key_id'      => 'testing_kid',
        'secret_key_value'   => 'testing_secret',
        'embed_issuer_url'   => 'https://example.com/issuer',
        'default_embeds'     => [{'id' => 'global_1', 'name' => 'Global Dashboard 1'},
                                 {'id' => 'global_2', 'name' => 'Global Dashboard 2'}]
      }
    )
  end

  # -----------------------------------------------------------------
  #  Shared example group – "an encrypted JWT string"
  # -----------------------------------------------------------------

  shared_examples 'an encrypted JWT string' do
    it 'returns an encrypted JWT string with 5 base64url segments' do
      expect(subject).to match(/\A(?:[A-Za-z0-9_-]+\.){4}[A-Za-z0-9_-]+\z/)
    end
  end

  # -----------------------------------------------------------------
  #  Shared examples for the two valid roles
  # -----------------------------------------------------------------

  shared_examples 'Plus role generates a JWT' do |role|
    let(:analytics_role) { role }
    it_behaves_like 'an encrypted JWT string'
  end

  shared_examples 'Essentials role generates a JWT' do |role|
    let(:analytics_role) { role }
    it_behaves_like 'an encrypted JWT string'
  end

  # -----------------------------------------------------------------
  #  .generate_embed_token spec
  # -----------------------------------------------------------------

  let(:customer_id) { 'customer_123' }
  let(:embed_id)    { 'embed_abc' }
  let(:expiration)  { 1.hour.to_i }

  # -----------------------------------------------------------------
  #  Context: valid Plus role
  # -----------------------------------------------------------------

  context 'with valid Plus role' do
    let(:analytics_role) { 'Plus' }
    # The helper above gives us a reusable shared example.
    it_behaves_like 'Plus role generates a JWT'
  end

  # -----------------------------------------------------------------
  #  Context: valid Essentials role
  # -----------------------------------------------------------------

  context 'with valid Essentials role' do
    let(:analytics_role) { 'Essentials' }
    it_behaves_like 'Essentials role generates a JWT'
  end

  # -----------------------------------------------------------------
  #  Context: invalid analytics role
  # -----------------------------------------------------------------

  context 'with invalid role' do
    let(:analytics_role) { 'Basic' }

    it 'raises TokenGenerationError with a specific message' do
      expect {
        described_class.generate_embed_token(
          customer_id: customer_id,
          embed_id: embed_id,
          analytics_role: analytics_role,
          expiration: expiration
        )
      }.to raise_error(Explo::TokenGenerationError, /Invalid analytics role/)
    end
  end

  # -----------------------------------------------------------------
  #  Context: encryption fails (simulated by stubbing JSON::JWE)
  # -----------------------------------------------------------------

  context 'when encryption fails' do
    let(:analytics_role) { 'Plus' }

    before do
      # JSON::JWE#encrypt expects a payload hash, a kid string and an
      # algorithm name.  When it raises, we want the wrapper to surface
      # a TokenGenerationError that mentions "JWT encryption failed".
      allow_any_instance_of(Json::JWT).to receive(:encrypt).and_raise(
        JSON::JWE::Exception.new('bad key')
      )
    end

    it 'raises TokenGenerationError with encryption message' do
      expect {
        described_class.generate_embed_token(
          customer_id: customer_id,
          embed_id: embed_id,
          analytics_role: analytics_role,
          expiration: expiration
        )
      }.to raise_error(Explo::TokenGenerationError, /JWT encryption failed.*bad key/)
    end
  end

  # -----------------------------------------------------------------
  #  Context: secret key missing (ConfigurationError)
  # -----------------------------------------------------------------

  context 'when secret key is missing' do
    let(:analytics_role) { 'Plus' }

    before do
      # Strip the secret_key_id / secret_key_value entries – the code will
      # try to fetch them via `env!` and raise a ConfigurationError.
      stub_local_settings(
        explo: {
          'embed_issuer_url' => 'https://example.com/issuer',
          'default_embeds'   => [{'id' => 'global_1'}, {'id' => 'global_2'}]
        }
      )
    end

    it 'raises ConfigurationError with a message that mentions secret_key' do
      expect {
        described_class.generate_embed_token(
          customer_id: customer_id,
          embed_id: embed_id,
          analytics_role: analytics_role
        )
      }.to raise_error(Explo::ConfigurationError, /secret_key_value/)
    end
  end

  # -----------------------------------------------------------------
  #  Context: other unknown errors (e.g. Permission lookup blows up)
  # -----------------------------------------------------------------

  context 'with other unknown errors' do
    let(:analytics_role) { 'Plus' }

    before do
      # The production code calls `get_permissions_for_role` inside the
      # method.  We force it to raise an arbitrary RuntimeError.
      allow_any_instance_of(Explo).to receive(:get_permissions_for_role)
                                          .and_raise(RuntimeError.new('Boom'))
    end

    it 'raises TokenGenerationError containing "Unexpected failure"' do
      expect {
        described_class.generate_embed_token(
          customer_id: customer_id,
          embed_id: embed_id,
          analytics_role: analytics_role
        )
      }.to raise_error(Explo::TokenGenerationError, /Unexpected failure/i)
    end
  end

  # -----------------------------------------------------------------
  #  #get_available_embeds specs – all four scenarios
  # -----------------------------------------------------------------

  describe '#get_available_embeds' do
    # Helper that builds a token with *known* content – used only for
    # readability; the content itself is irrelevant to the embed logic.
    def token(stubbed_id = 'global_1')
      described_class.generate_embed_token(
        customer_id:   customer_id,
        embed_id:      stubbed_id,
        analytics_role: :Plus,
        expiration:    expiration
      )
    end

    context 'when customer has no specific embeds' do
      it 'returns only the global default embeds' do
        # No custom embeds at all
        allow(ShardSetting).to receive(:[]).with('explo_custom_embeds').and_return(nil)
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to eq(%w[global_1 global_2])
      end
    end

    context 'when customer has specific embeds' do
      let(:customer_embeds) { [{'id' => 'customer_1', 'name' => 'Customer Dashboard'}] }

      it 'returns a combination of global and customer embeds' do
        allow(ShardSetting).to receive(:[]).with('explo_custom_embeds').and_return(customer_embeds)
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to contain_exactly('global_1', 'global_2', 'customer_1')
      end
    end

    context 'when a customer embed has the same ID as a global embed' do
      let(:customer_embeds) { [{'id' => 'global_1', 'name' => 'Custom Version of Global 1'}] }

      it 'returns a unique list, preferring the first one found (global)' do
        allow(ShardSetting).to receive(:[]).with('explo_custom_embeds').and_return(customer_embeds)
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to contain_exactly('global_1', 'global_2')
        expect(
          embeds.find { |e| e['id'] == 'global_1' }['name']
        ).to eq('Global Dashboard 1')
      end
    end

    context 'when ShardSetting lookup raises an error' do
      it 'rescues the error and returns only the global embeds' do
        allow(ShardSetting).to receive(:[]).with('explo_custom_embeds')
                                         .and_raise(StandardError, 'database timeout')
        embeds = described_class.get_available_embeds
        expect(embeds.map { |e| e['id'] }).to eq(%w[global_1 global_2])
      end
    end
  end
end
