# frozen_string_literal: true

require 'json/jwt'

module Explo
extend self

class Error < StandardError; end
class ConfigurationError < Error; end
class TokenGenerationError < Error; end

def generate_embed_token(customer_id:, embed_id:, analytics_role:, expiration: 24.hours.to_i)
permissions = get_permissions_for_role(analytics_role)
claims = {
cst: customer_id.to_s,
dsh: embed_id,
exp: Time.now.to_i + expiration,
iss: env!(:embed_issuer_url)
}.merge(permissions)

jwt = JSON::JWT.new(claims)

jwt.header[:kid] = secret_key_id

encrypted_jwt = jwt.encrypt(env!(:secret_key_value), 'dir', 'A256GCM')

encrypted_jwt.to_s

rescue JSON::JWE::Exception => e
raise TokenGenerationError, "JWT encryption failed: #{e.message}"
rescue StandardError => e
raise TokenGenerationError, "Unexpected failure generating token: #{e.message}"
end

def get_available_embeds
global_embeds = env!('default_embeds')
customer_embeds = ShardSetting["explo_custom_embeds"] || []

(global_embeds + customer_embeds).uniq {|embed| embed['id'] }

end

private

def get_permissions_for_role(role_name)
case role_name
when 'Plus'
{rbc: ['*'], des: false}
when 'Essentials'
{rbc: ['flt', 'srt', 'crt-view'], des: true}
else
raise TokenGenerationError, "Invalid analytics role for user: #{role_name.inspect}"
end
end

def env!(name)
value = LOCAL_SETTINGS.dig('explo', name.to_s)
return value if !value.nil?

raise ConfigurationError, "Explo configuration missing: '#{name}'"

end
end
