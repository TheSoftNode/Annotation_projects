# Test Results Summary

## PROMPT Original Code Errors (7 failures out of 10 tests)

### Error 1: Missing `secret_key_id` method
**Cause:** `undefined local variable or method 'secret_key_id' for Explo:Module`
**Location:** `./lib/explo.rb:23 in generate_embed_token`
**Code:** `jwt.header[:kid] = secret_key_id`
**Affected Tests:** Tests 1, 2, 3, 5, 6

### Error 2: Missing `JSON::JWE::Exception` constant
**Cause:** `uninitialized constant JSON::JWE::Exception`
**Location:** `./lib/explo.rb:29 in rescue clause`
**Code:** `rescue JSON::JWE::Exception => e`
**Affected Tests:** Tests 1, 2, 3, 5, 6

### Error 3: Wrong constant `JSON::JWE::EncryptionFailed`
**Cause:** `uninitialized constant JSON::JWE::EncryptionFailed`
**Location:** `./spec/lib/explo_spec_runnable.rb:87`
**Code:** `JSON::JWE::EncryptionFailed.new("bad key")`
**Suggestion:** Did you mean? `JSON::JWE::DecryptionFailed`
**Affected Tests:** Test 4

### Error 4: Missing rescue in `get_available_embeds`
**Cause:** `StandardError: database timeout` not rescued
**Location:** `./lib/explo.rb:37 in get_available_embeds`
**Code:** `customer_embeds = ShardSetting["explo_custom_embeds"] || []`
**Affected Tests:** Test 7

## Passing Tests (3 out of 10)

1. ✅ `Explo#get_available_embeds when customer has no specific embeds`
2. ✅ `Explo#get_available_embeds when customer has specific embeds`
3. ✅ `Explo#get_available_embeds when a customer embed has the same ID as a global embed`

## Summary

**Total Tests:** 10
**Passed:** 3
**Failed:** 7
**Success Rate:** 30%

## Key Issues to Fix

1. Add `secret_key_id` private method
2. Require `json/jwe` library properly
3. Use correct exception class (`JSON::JWE::DecryptionFailed` or handle differently)
4. Add rescue block in `get_available_embeds` method
