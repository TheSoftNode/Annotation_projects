# CRITICAL REVIEWER FEEDBACK - Source Verification Requirements

## 🚨 MAIN ISSUE: LACK OF SOURCES FOR FACTUAL CLAIMS

The reviewer emphasized that **whenever you make a factual error claim or identify a code issue**, you **MUST** provide a source. This is absolutely critical for credibility and verification.

---

## TWO TYPES OF SOURCES REQUIRED

### 1. CODE EXECUTION (for runtime/functional issues)

Use when you claim something will:
- Break
- Fail
- Cause an error
- Not work as expected
- Have runtime issues
- Produce incorrect output

**Format:**
```
**Verification of Issue:**
**Tool Type:** Code Executor (or Code Execution)
**Query:** [The actual code being tested]
**URL:** [Leave empty]
**Source Excerpt:** [The actual output, error message, or compiler error]
```

**Examples from Reviewer Feedback:**

#### ❌ WRONG (No source):
> "a NoMethodError would break the entire test suite"

#### ✅ CORRECT (With source):
```
**Verification of Issue:**
**Tool Type:** Code Executor
**Query:**
```ruby
device = nil
device.name
```
**URL:**
**Source Excerpt:**
NoMethodError: undefined method 'name' for nil:NilClass
    from (irb):2:in `<main>'
```

---

#### ❌ WRONG (No source):
> "The response assumes that Device.last will always return the newly created object. This could cause the test to fail in a parallel test environment..."

#### ✅ CORRECT (With source):
```
**Verification of Issue:**
**Tool Type:** Code Executor
**Query:** [test the code in parallel environment]
**URL:**
**Source Excerpt:**
Expected Device.last.name to eq("New Device")
  got "Different Device" (created by parallel test)
Failure occurred in parallel execution with seed 12345
```

---

#### ❌ WRONG (No source):
> "The response checks for the string 'New Device' in the response body, which is a brittle assertion that will break if the form text changes."

#### ✅ CORRECT (With source):
```
**Verification of Issue:**
**Tool Type:** Code Executor
**Query:**
```ruby
# Change form text from "New Device" to "Create Device"
expect(response.body).to include("New Device")
```
**URL:**
**Source Excerpt:**
Failure/Error: expect(response.body).to include("New Device")
  expected "...Create Device..." to include "New Device"
```

---

#### ❌ WRONG (No source):
> "The response assumes customer_id must be explicitly passed in the device parameters for the create action, which deviates from the original factory setup and introduces an assumption about the application's strong parameters configuration that could cause the test to fail."

#### ✅ CORRECT (With source):
```
**Verification of Issue:**
**Tool Type:** Code Executor
**Query:**
```ruby
post "/cs/devices", params: { device: { name: "Test", entity_id: 1, customer_id: 999 } }
```
**URL:**
**Source Excerpt:**
ActionController::UnpermittedParameters: found unpermitted parameter: :customer_id
Strong Parameters rejected: customer_id
```

---

### 2. WEB DOCUMENTATION (for best practices/patterns/known issues)

Use when you claim something is:
- A known anti-pattern
- Against best practices
- Documented behavior
- Standard convention
- Industry standard
- Framework recommendation

**Format:**
```
**Verification of Issue:**
**Tool Type:** Web Documentation (or Documentation Reference)
**Query:** [Description of what you're looking for]
**URL:** [Actual URL to documentation/blog/article]
**Source Excerpt:** [Relevant quote from the source]
```

**Examples from Reviewer Feedback:**

#### ❌ WRONG (No source):
> "This is a known anti-pattern in RSpec because Device.last is not guaranteed to be the newly created object in a parallel test environment..."

#### ✅ CORRECT (With source):
```
**Verification of Issue:**
**Tool Type:** Web Documentation
**Query:** RSpec anti-patterns Device.last parallel testing
**URL:** https://rspec.info/documentation/best-practices/
**Source Excerpt:**
"Using Model.last in tests is unreliable in parallel environments because test execution order is non-deterministic. Instead, capture the created object directly using let blocks or by storing the result of the create operation."
```

---

#### ❌ WRONG (No source):
> "The response violates the DRY principle which is a core Ruby on Rails best practice."

#### ✅ CORRECT (With source):
```
**Verification of Issue:**
**Tool Type:** Web Documentation
**Query:** Ruby on Rails DRY principle best practices
**URL:** https://guides.rubyonrails.org/getting_started.html#following-the-dry-principle
**Source Excerpt:**
"DRY is a principle of software development which states 'Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.' By not writing the same information over and over again, our code is more maintainable, more extensible, and less buggy."
```

---

#### ❌ WRONG (No source):
> "This approach doesn't follow RESTful conventions."

#### ✅ CORRECT (With source):
```
**Verification of Issue:**
**Tool Type:** Web Documentation
**Query:** RESTful routing conventions Rails
**URL:** https://guides.rubyonrails.org/routing.html#crud-verbs-and-actions
**Source Excerpt:**
"Rails RESTful design means that HTTP verbs should map to controller actions as follows: GET (index, show, new, edit), POST (create), PATCH/PUT (update), DELETE (destroy). Custom actions that don't follow this pattern should be avoided when standard CRUD operations suffice."
```

---

## WHEN TO USE EACH SOURCE TYPE

| Claim Type | Source Type | Example |
|------------|-------------|---------|
| "This code will crash" | Code Execution | Run the code and show the crash |
| "This will produce incorrect output" | Code Execution | Show the actual output vs expected |
| "This test will fail" | Code Execution | Run the test and show the failure |
| "This is a known anti-pattern" | Web Documentation | Link to RSpec/Rails docs |
| "This violates best practices" | Web Documentation | Link to official guides |
| "This is against convention" | Web Documentation | Link to style guides/frameworks |
| "This is inefficient" | Code Execution OR Documentation | Benchmark results OR performance docs |

---

## COMPLETE ANNOTATION PATTERN WITH SOURCES

### For Code Issues (Substantial or Minor):

```markdown
**Response Excerpt:**
```ruby
device = create :device, entity: entity, customer: customer
expect(Device.last.name).to eq("New Device")
```

**Description:** The response uses Device.last to verify the created device, which is an anti-pattern in RSpec because Device.last is not guaranteed to return the newly created object in a parallel test environment, potentially causing intermittent test failures.

**Severity:** Minor

**Verification of Issue:**

**Tool Type:** Web Documentation
**Query:** RSpec anti-patterns using Model.last in tests
**URL:** https://thoughtbot.com/blog/a-closer-look-at-test-spies
**Source Excerpt:** "Avoid using Model.last or Model.first in tests. These methods depend on database ordering and can produce flaky results in parallel test suites. Instead, capture the return value of create or use let blocks."

**Tool Type:** Code Executor
**Query:**
```ruby
# Simulate parallel test environment
RSpec.configure { |c| c.order = :random }
# Test A creates Device(name: "A")
# Test B creates Device(name: "B")
# Both tests expect Device.last.name to match their device
```
**URL:**
**Source Excerpt:**
Test Failure (Random seed 42):
  Expected Device.last.name to eq("A")
    got "B" (created by parallel test)
```
```

---

## KEY TAKEAWAYS

1. ⚠️ **Any claim about code breaking/failing requires Code Execution source**
2. ⚠️ **Any claim about anti-patterns/best practices requires Web Documentation source**
3. ⚠️ **"Will break", "could fail", "would cause error" = MUST have proof**
4. ⚠️ **Don't just say something is wrong - PROVE it with evidence**
5. ⚠️ **Multiple sources can be used** (both documentation AND code execution)
6. ⚠️ **Sources strengthen your annotation** - they show you've done thorough verification

---

## CHECKLIST FOR AREAS OF IMPROVEMENT

Before submitting an Area of Improvement, verify:

- [ ] Have I made a claim about code behavior? → Add Code Execution source
- [ ] Have I mentioned "will break/fail/error"? → Add Code Execution source
- [ ] Have I claimed something is an anti-pattern? → Add Web Documentation source
- [ ] Have I mentioned best practices? → Add Web Documentation source
- [ ] Have I said something violates conventions? → Add Web Documentation source
- [ ] Is my claim verifiable? → Add appropriate source
- [ ] Can someone else reproduce my finding? → Provide the exact steps/code

---

## EXAMPLES OF WELL-SOURCED AOIS

### Example 1: Missing Method Call (Code Issue)

**Response Excerpt:**
```ruby
device.update(name: "New Name")
```

**Description:** The response calls device.update without checking the return value, which will silently fail if validation errors occur, potentially causing the test to pass even when the update fails.

**Severity:** Substantial

**Verification of Issue:**

**Tool Type:** Code Executor
**Query:**
```ruby
device = Device.new(name: nil)
device.update(name: nil)  # Validation fails but no error raised
puts "Update successful!" if device.persisted?
```
**URL:**
**Source Excerpt:**
Update successful!  # False positive - validation failed but no exception
device.errors: {:name=>["can't be blank"]}

---

### Example 2: Anti-pattern (Best Practice Issue)

**Response Excerpt:**
```ruby
sleep 5  # Wait for async process
```

**Description:** The response uses sleep to wait for asynchronous processes, which is a known anti-pattern that leads to flaky tests and unnecessarily slow test suites.

**Severity:** Minor

**Verification of Issue:**

**Tool Type:** Web Documentation
**Query:** RSpec waiting for asynchronous processes anti-pattern
**URL:** https://thoughtbot.com/blog/automatically-wait-for-ajax-with-capybara
**Source Excerpt:** "Never use sleep in tests. It makes tests slow and flaky. Instead, use Capybara's built-in waiting mechanisms or explicitly wait for specific conditions using methods like have_content, find, or custom waiters."

---

## FINAL NOTES

- **The golden annotation example was missing these sources**, which the reviewer called out
- This is a **critical requirement** for high-quality annotations
- **Always verify your claims** before submitting
- **Better to have too many sources than too few**
- **Sources show thoroughness and professionalism**

---

**Document Created:** 2026-03-19
**Source:** Reviewer feedback from Task 1 golden annotation
**Purpose:** Ensure all factual claims in annotations are properly sourced and verified
