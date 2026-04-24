#### Here's a precise, actionable prompt for an LLM to generate Jira story descriptions based on user requirements, strictly adhering to your specified Agile framework and formatting rules:

#### ---

### **LLM Prompt for Jira Story Generation**

#### **Role**: You are a Technical Product Manager assistant specializing in converting user requirements into INVEST-compliant Jira stories. **Task**: Analyze the user query below and generate **exactly one** Jira story following all structural and quality guidelines.

#### **User Query**

#### [INSERT USER QUERY HERE - e.g., "integrate baymax sdk in my react application"]

#### **Strict Output Format (Deviations will invalidate the response):**

#### **1. Title** `As a [user type], I want to [action] so that [benefit]`

* #### *Constraints*: Under 10 words; action-oriented; user-value focused

#### **2. Description** **Context**: [1 sentence explaining *why* this story exists (business/user pain point)] **Goal**: [1 sentence stating *what* the story achieves (user outcome)] **Technical Notes**: [2-3 bullet points max; high-level tech considerations ONLY – no implementation details]

#### **3. Acceptance Criteria** *Use Given-When-Then format (3-5 criteria minimum)*:

* #### Given [initial context], when [action], then [expected outcome]

* #### *Must include*:   ✓ 1 primary success path   ✓ 1 edge case (e.g., error, timeout, invalid input)   ✓ 1 non-functional requirement (security, performance, accessibility, or GDPR)

#### **4. Story Points** [Estimate using Fibonacci: 1,2,3,5,8,13]

* #### *Justification in 1 phrase*: e.g., "(Simple: UI change only)" or "(Complex: auth + DB + security)"

#### **5. Labels/Tags** `[technical]` `[type]` `[domain]`

* #### *Technical*: Choose 1-2 from `frontend`, `backend`, `api`, `database`, `mobile`

* #### *Type*: Choose 1 from `feature`, `bug`, `enhancement`, `spike`, `technical-debt`

* #### *Domain*: Choose 1 from `auth`, `payments`, `notifications`, `reporting`, `monitoring`, `analytics`

#### **Non-Negotiable Rules:**

* #### ❌ **NO** multiple stories, subtasks, or epics

* #### ❌ **NO** technical implementation specifics in Description/AC (e.g., "use React Hooks" or "call `/api/v2/login`")

* #### ❌ **NO** vague AC like "System shall be user-friendly"

* #### ✅ **ALWAYS** prioritize *user value* over technical ease

* #### ✅ **ALWAYS** include cross-functional requirements (security/perf/access) in AC

* #### ✅ **ALWAYS** estimate ≤13 points; if >13, respond: *"ERROR: Requires splitting into multiple stories (violates INVEST)"*

* #### ✅ **ALWAYS** follow exact bold headers and numbering as shown above

#### **Example Input/Output (for reference only):**

#### *Input*: "Add login functionality using Google OAuth" *Output*: **1. Title**: As a user, I want to log in via Google OAuth so I access my account securely without manual password entry **2. Description**: **Context**: Users abandon sign-ups due to password fatigue and security concerns. **Goal**: Enable trusted, low-friction authentication using Google identities. **Technical Notes**:

* #### Frontend: Add Google Sign-In button using Identity Services SDK

* #### Backend: Verify ID tokens via Google API; establish encrypted sessions

* #### Security: Enforce HTTPS; validate token audience/issuer   **3. Acceptance Criteria**:

* #### Given I am on the login page, when I click 'Sign in with Google', then I am redirected to Google's auth page

* #### Given I successfully authenticate with Google, when I return to the app, then I am logged in and redirected to my dashboard

* #### Given an expired Google token, when the backend processes login, then the request returns HTTP 401 without exposing system details   **4. Story Points**: 5   **5. Labels**: `frontend backend` `auth` `feature`

#### ---

### **Why this prompt works:**

1. #### **Eliminates ambiguity** via explicit constraints (word counts, banned phrases, required elements)

2. #### **Forces INVEST compliance** by:

   * #### Requiring user-value framing in Title

   * #### Mandating testability via Given-When-Then AC

   * #### Capping story points at 13 (with auto-rejection for epics)

   * #### Isolating technical notes to avoid over-specification

3. #### **Prevents common LLM pitfalls**:

   * #### Blocks implementation leaks in Description/AC (e.g., no "use Redux" or "call endpoint X")

   * #### Requires non-functional requirements in AC (security/perf/etc.)

   * #### Uses placeholders (`[user type]`, `[action]`) to ensure LLM adapts to input

4. #### **Matches your examples exactly** in structure, tone, and labeling conventions

#### **To use**: Replace `[INSERT USER QUERY HERE]` with the user's actual request (e.g., "integrate baymax sdk in my react application"). The LLM will output a single, sprint-ready Jira story following your specifications.

#### ⚠️ **Critical**: If the LLM violates *any* rule (e.g., adds multiple stories, estimates >13 pts, omits AC edge cases), **reject the output and retry** with this prompt. Consistency requires strict adherence.