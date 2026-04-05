Failed spec ran at:

1. Explo.generate\_embed\_token with other unknown errors raises TokenGenerationError for unexpected failure
   Failure/Error: expect { subject }.to raise\_error(Explo::TokenGenerationError, /Unexpected failure/)
   expected Explo::TokenGenerationError with message matching /Unexpected failure/, got \#\<Explo::TokenGenerationError: JWT encryption failed: Boom\> with backtrace:
   \# ./lib/explo.rb:26:in `rescue in generate_embed_token' # ./lib/explo.rb:13:in` generate\_embed\_token'
   \# ./spec/lib/explo\_spec.rb:16:in `block (3 levels) in <top (required)>' # ./spec/lib/explo_spec.rb:82:in` block (5 levels) in \<top (required)\>'
   \# ./spec/lib/explo\_spec.rb:82:in `block (4 levels) in <top (required)>' # /Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in` block (2 levels) in \<top (required)\>'
   **./spec/lib/explo\_spec.rb:82:in \`block (4 levels) in \<top (required)\>'**
   **/Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in \`block (2 levels) in \<top (required)\>'**

/Users/jrni/bookingbug/lib/explo.rb:25: warning: toplevel constant Exception referenced by JSON::JWE::Exception | ETA: 00:00:07
Failed spec ran at:

2. Explo.generate\_embed\_token when secret key is missing raises ConfigurationError
   Failure/Error:
   expect {
   described\_class.generate\_embed\_token(
   customer\_id: customer\_id,
   embed\_id: embed\_id,
   analytics\_role: analytics\_role
   )
   }.to raise\_error(Explo::ConfigurationError, /secret\_key\_value/)
   expected Explo::ConfigurationError with message matching /secret\_key\_value/, got \#\<Explo::TokenGenerationError: JWT encryption failed: Explo configuration missing: 'embed\_issuer\_url'\> with backtrace:
   \# ./lib/explo.rb:26:in `rescue in generate_embed_token' # ./lib/explo.rb:13:in` generate\_embed\_token'
   \# ./spec/lib/explo\_spec.rb:65:in `block (5 levels) in <top (required)>' # ./spec/lib/explo_spec.rb:64:in` block (4 levels) in \<top (required)\>'
   \# /Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in \`block (2 levels) in \<top (required)\>'
   **./spec/lib/explo\_spec.rb:64:in \`block (4 levels) in \<top (required)\>'**
   **/Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in \`block (2 levels) in \<top (required)\>'**

/Users/jrni/bookingbug/lib/explo.rb:25: warning: toplevel constant Exception referenced by JSON::JWE::Exception | ETA: 00:00:03
Failed spec ran at:

3. Explo.generate\_embed\_token with valid Plus role behaves like an encrypted JWT string returns an encrypted JWT string with 5 base64url segments
   Failure/Error: raise TokenGenerationError, "JWT encryption failed: \#{e.message}"
   Explo::TokenGenerationError:
   JWT encryption failed: undefined local variable or method \`secret\_key\_id' for Explo:Module
   Shared Example Group: "an encrypted JWT string" called from ./spec/lib/explo\_spec.rb:27
   **./lib/explo.rb:26:in \`rescue in generate\_embed\_token'**
   **./lib/explo.rb:13:in \`generate\_embed\_token'**
   **./spec/lib/explo\_spec.rb:16:in \`block (3 levels) in \<top (required)\>'**
   **./spec/lib/explo\_spec.rb:6:in \`block (3 levels) in \<top (required)\>'**
   **/Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in \`block (2 levels) in \<top (required)\>'**
   **\------------------**
   **— Caused by: —**
   **NameError:**
   **undefined local variable or method \`secret\_key\_id' for Explo:Module**
   **./lib/explo.rb:22:in \`generate\_embed\_token'**

Failed spec ran at: 30 \==============\> | ETA: 00:00:02

4. Explo.generate\_embed\_token when encryption fails raises TokenGenerationError with encryption message
   Failure/Error: allow(JSON::JWE).to receive(:encrypt).and\_raise(JSON::JWE::EncryptionFailed.new("bad key"))
   NameError:
   uninitialized constant JSON::JWE::EncryptionFailed
   **./spec/lib/explo\_spec.rb:48:in \`block (4 levels) in \<top (required)\>'**
   **/Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in \`block (2 levels) in \<top (required)\>'**

/Users/jrni/bookingbug/lib/explo.rb:25: warning: toplevel constant Exception referenced by JSON::JWE::Exception | ETA: 00:00:01
Failed spec ran at:

5. Explo.generate\_embed\_token with valid Essentials role behaves like an encrypted JWT string returns an encrypted JWT string with 5 base64url segments
   Failure/Error: raise TokenGenerationError, "JWT encryption failed: \#{e.message}"
   Explo::TokenGenerationError:
   JWT encryption failed: undefined local variable or method \`secret\_key\_id' for Explo:Module
   Shared Example Group: "an encrypted JWT string" called from ./spec/lib/explo\_spec.rb:33
   **./lib/explo.rb:26:in \`rescue in generate\_embed\_token'**
   **./lib/explo.rb:13:in \`generate\_embed\_token'**
   **./spec/lib/explo\_spec.rb:16:in \`block (3 levels) in \<top (required)\>'**
   **./spec/lib/explo\_spec.rb:6:in \`block (3 levels) in \<top (required)\>'**
   **/Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in \`block (2 levels) in \<top (required)\>'**
   **\------------------**
   **— Caused by: —**
   **NameError:**
   **undefined local variable or method \`secret\_key\_id' for Explo:Module**
   **./lib/explo.rb:22:in \`generate\_embed\_token'**

/Users/jrni/bookingbug/lib/explo.rb:25: warning: toplevel constant Exception referenced by JSON::JWE::Exception | ETA: 00:00:01
Failed spec ran at: \=========================== 80 \========================================\> | ETA: 00:00:00

6. Explo\#get\_available\_embeds when ShardSetting lookup raises an error rescues the error and returns only the global embeds
   Failure/Error: customer\_embeds \= ShardSetting\["explo\_custom\_embeds"\] || \[\]
   StandardError:
   database timeout
   **./lib/explo.rb:33:in \`get\_available\_embeds'**
   **./spec/lib/explo\_spec.rb:118:in \`block (4 levels) in \<top (required)\>'**
   **/Users/jrni/.rvm/gems/ruby-2.3.3@jrni/gems/webmock-3.18.1/lib/webmock/rspec.rb:37:in \`block (2 levels) in \<top (required)\>'**

10/10 |================================================= 100 \==================================================\>| Time: 00:00:00

above errors are coming for below rspecs:

```ruby
# frozen_string_literal: true

describe Explo do
shared_examples 'an encrypted JWT string' do
it 'returns an encrypted JWT string with 5 base64url segments' do
expect(subject).to match(/\\A(?:\[A-Za-z0-9\_-\]+.){4}\[A-Za-z0-9\_-\]+\\z/)
end
end

describe '.generate\_embed\_token' do
let(:customer\_id) { 'customer\_123' }
let(:embed\_id) { 'embed\_abc' }
let(:expiration) { 1.hour.to\_i }

subject do

  described\_class.generate\_embed\_token(

    customer\_id: customer\_id,

    embed\_id: embed\_id,

    analytics\_role: analytics\_role,

    expiration: expiration

  )

end

context 'with valid Plus role' do

  let(:analytics\_role) { 'Plus' }

  it\_behaves\_like 'an encrypted JWT string'

end

context 'with valid Essentials role' do

  let(:analytics\_role) { 'Essentials' }

  it\_behaves\_like 'an encrypted JWT string'

end

context 'with invalid role' do

  let(:analytics\_role) { 'Basic' }

  it 'raises TokenGenerationError' do

    expect { subject }.to raise\_error(Explo::TokenGenerationError, /Invalid analytics role/)

  end

end

context 'when encryption fails' do

  let(:analytics\_role) { 'Plus' }

  before do

    allow(JSON::JWE).to receive(:encrypt).and\_raise(JSON::JWE::EncryptionFailed.new("bad key"))

  end

  it 'raises TokenGenerationError with encryption message' do

    expect { subject }.to raise\_error(Explo::TokenGenerationError, /JWT encryption failed/)

  end

end

context 'when secret key is missing' do

  let(:analytics\_role) { 'Plus' }

  before do

    stub\_const("LOCAL\_SETTINGS", { 'explo' \=\> { 'secret\_key\_id' \=\> 'abc' } })

  end

  it 'raises ConfigurationError' do

    expect {

      described\_class.generate\_embed\_token(

        customer\_id: customer\_id,

        embed\_id: embed\_id,

        analytics\_role: analytics\_role

      )

    }.to raise\_error(Explo::ConfigurationError, /secret\_key\_value/)

  end

end

context 'with other unknown errors' do

  let(:analytics\_role) { 'Plus' }

  before do

    allow(described\_class).to receive(:get\_permissions\_for\_role).and\_raise("Boom")

  end

  it 'raises TokenGenerationError for unexpected failure' do

    expect { subject }.to raise\_error(Explo::TokenGenerationError, /Unexpected failure/)

  end

end

end

describe '\#get\_available\_embeds' do
context 'when customer has no specific embeds' do
it 'returns only the global default embeds' do
allow(ShardSetting).to receive(:\[\]).with("explo\_custom\_embeds").and\_return(nil)
embeds \= described\_class.get\_available\_embeds
expect(embeds.map {|e| e\['id'\] }).to eq(\['global\_1', 'global\_2'\])
end
end

context 'when customer has specific embeds' do

  let(:customer\_embeds) { \[{'id' \=\> 'customer\_1', 'name' \=\> 'Customer Dashboard'}\] }

  it 'returns a combination of global and customer embeds' do

    allow(ShardSetting).to receive(:\[\]).with("explo\_custom\_embeds").and\_return(customer\_embeds)

    embeds \= described\_class.get\_available\_embeds

    expect(embeds.map {|e| e\['id'\] }).to contain\_exactly('global\_1', 'global\_2', 'customer\_1')

  end

end

context 'when a customer embed has the same ID as a global embed' do

  let(:customer\_embeds) { \[{'id' \=\> 'global\_1', 'name' \=\> 'Custom Version of Global 1'}\] }

  it 'returns a unique list, preferring the first one found (global)' do

    allow(ShardSetting).to receive(:\[\]).with("explo\_custom\_embeds").and\_return(customer\_embeds)

    embeds \= described\_class.get\_available\_embeds

    expect(embeds.map {|e| e\['id'\] }).to contain\_exactly('global\_1', 'global\_2')

    expect(embeds.find {|e| e\['id'\] \== 'global\_1' }\['name'\]).to eq('Global Dashboard 1')

  end

end

context 'when ShardSetting lookup raises an error' do

  it 'rescues the error and returns only the global embeds' do

    allow(ShardSetting).to receive(:\[\]).with("explo\_custom\_embeds").and\_raise(StandardError, "database timeout")

    embeds \= described\_class.get\_available\_embeds

    expect(embeds.map {|e| e\['id'\] }).to eq(\['global\_1', 'global\_2'\])

  end

end

end
end
```

For this code:

```ruby
# frozen_string_literal: true

require 'json/jwt'

module Explo
extend self

class Error \< StandardError; end
class ConfigurationError \< Error; end
class TokenGenerationError \< Error; end

def generate\_embed\_token(customer\_id:, embed\_id:, analytics\_role:, expiration: 24.hours.to\_i)
permissions \= get\_permissions\_for\_role(analytics\_role)
claims \= {
cst: customer\_id.to\_s,
dsh: embed\_id,
exp: Time.now.to\_i \+ expiration,
iss: env\!(:embed\_issuer\_url)
}.merge(permissions)

jwt \= JSON::JWT.new(claims)

jwt.header\[:kid\] \= secret\_key\_id

encrypted\_jwt \= jwt.encrypt(env\!(:secret\_key\_value), 'dir', 'A256GCM')

encrypted\_jwt.to\_s

rescue JSON::JWE::Exception \=\> e
raise TokenGenerationError, "JWT encryption failed: \#{e.message}"
rescue StandardError \=\> e
raise TokenGenerationError, "Unexpected failure generating token: \#{e.message}"
end

def get\_available\_embeds
global\_embeds \= env\!('default\_embeds')
customer\_embeds \= ShardSetting\["explo\_custom\_embeds"\] || \[\]

(global\_embeds \+ customer\_embeds).uniq {|embed| embed\['id'\] }

end

private

def get\_permissions\_for\_role(role\_name)
case role\_name
when 'Plus'
{rbc: \['\*'\], des: false}
when 'Essentials'
{rbc: \['flt', 'srt', 'crt-view'\], des: true}
else
raise TokenGenerationError, "Invalid analytics role for user: \#{role\_name.inspect}"
end
end

def env\!(name)
value \= LOCAL\_SETTINGS.dig('explo', name.to\_s)
return value if \!value.nil?

raise ConfigurationError, "Explo configuration missing: '\#{name}'"

end
end
```

Can you give me complete rspecs fixed for this with exhaustive and all cases
