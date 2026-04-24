**CONVERSATION HISTORY:**

**USER:**

You are a technical product manager assistant that converts user requirements into well-structured Jira stories. Analyze the user’s request and generate detailed, actionable stories following Agile best practices.

   \#\# Core Requirements:

    \- Break down complex requirements into manageable, independent stories

    \- Ensure each story delivers clear user value

    \- Follow the INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable)

    \- Use standard Jira formatting and terminology

    

    \#\# Story Structure:

    

    \#\#\# \*\*Story Title\*\*

    \- Format: \`As a \[user type\], I want to \[action\] so that \[benefit\]\` OR action-oriented title

    \- Keep concise and descriptive (under 10 words when possible)

    

    \#\#\# \*\*Story Description\*\*

    \- \*\*Context\*\*: Brief background explaining why this story exists

    \- \*\*Goal\*\*: What the story aims to achieve

    \- \*\*Technical Notes\*\*: High-level implementation considerations (no detailed specs)

    

    \#\#\# \*\*Acceptance Criteria\*\*

    Use Given-When-Then format or checkbox format:

    \- \*\*Given\*\* \[initial context\]

    \- \*\*When\*\* \[action performed\] 

    \- \*\*Then\*\* \[expected outcome\]

    

    \#\#\# \*\*Story Points\*\*

    Estimate using Fibonacci sequence (1, 2, 3, 5, 8, 13):

    \- 1-2: Simple changes, minor updates

    \- 3-5: Standard features, moderate complexity

    \- 8-13: Complex features, significant effort

    \- 21+: Epic-level work that should be broken down

    

    \#\#\# \*\*Labels/Tags\*\*

    Use relevant technical and functional tags:

    \- Technical: \`frontend\`, \`backend\`, \`api\`, \`database\`, \`mobile\`

    \- Type: \`feature\`, \`bug\`, \`enhancement\`, \`spike\`, \`technical-debt\`

    \- Domain: \`auth\`, \`payments\`, \`notifications\`, \`reporting\`

    

    \#\# Guidelines:

    \- Prioritize user value over technical implementation details

    \- Each story should be completable within one sprint

    \- Include edge cases and error scenarios in acceptance criteria

    \- Consider cross-functional requirements (security, performance, accessibility)

    \- Suggest story dependencies when relevant

    \- Do not create multiple stories, create a single story

    

    \#\# Input Processing:

    Analyze the user query for:

    1\. Core functionality needed

    2\. User types involved

    3\. Business value delivered

    4\. Technical complexity

    

    \---

    \#\# Example Input:

    User Query: ""Add login functionality using Google OAuth""

    

    \#\# Example Output:

    1\. \*\*Title\*\*: Implement Google OAuth Login

       \*\*Description\*\*: Integrate Google OAuth 2.0 into the login page so users can authenticate using their Google accounts. Ensure the backend securely handles token verification and session management.

       \*\*Acceptance Criteria\*\*:

       \- Given a login page, when the user clicks 'Login with Google', they are redirected to Google Auth

       \- After successful login, the user is redirected to the dashboard with an active session

       \- Backend verifies token using Google API and stores minimal user profile

       \*\*Story Points\*\*: 5

       \*\*Labels\*\*: auth, backend, frontend

---

**ASSISTANT:**

### **Story Title**

As a user, I want to log in via Google OAuth so that I access my account securely without manual password entry

### **Story Description**

**Context**: Users currently face friction during sign-in due to password management. Integrating Google OAuth reduces onboarding abandonment and aligns with security best practices by leveraging trusted identity providers.  
**Goal**: Enable seamless authentication via Google accounts while ensuring secure token handling and session management.  
**Technical Notes**:

* Frontend: Add Google Sign-In button using Google Identity Services SDK (modern `id_token` flow).  
* Backend: Verify JWT tokens via Google API, map to internal user profiles, and establish encrypted sessions.  
* Security: Enforce HTTPS, validate token audience/issuer, and implement CSRF protection.  
* Accessibility: Ensure button meets WCAG 2.1 contrast and screen reader requirements.

### **Acceptance Criteria**

* **Given** I am on the login page  
  **When** I click the ““Sign in with Google”” button  
  **Then** I am redirected to Google’s authentication page (not a popup)  
* **Given** I successfully authenticate with Google  
  **When** I return to the app  
  **Then** I am logged in with a persistent session and redirected to the user dashboard  
* **Given** I revoke app access in my Google account  
  **When** I attempt to log in again  
  **Then** I see an error: ““Authentication failed. Please reconnect your Google account.””  
* **Given** an expired or invalid Google token  
  **When** the backend processes the login request  
  **Then** the request is rejected without exposing system details (HTTP 401\)  
* **Given** I use a screen reader  
  **When** I navigate the login page  
  **Then** the Google Sign-In button is announced as ““Sign in with Google, button””

### **Story Points**

5 (Moderate complexity: Requires frontend SDK integration, backend token validation, security hardening, and cross-browser/mobile testing)

### **Labels/Tags**

`auth` `frontend` `backend` `security` `feature` `accessibility`

---

**USER:**

You are a technical product manager assistant that converts user requirements into well-structured Jira stories. Analyze the user’s request and generate detailed, actionable stories following Agile best practices.

   \#\# Core Requirements:

    \- Break down complex requirements into manageable, independent stories

    \- Ensure each story delivers clear user value

    \- Follow the INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable)

    \- Use standard Jira formatting and terminology

    

    \#\# Story Structure:

    

    \#\#\# \*\*Story Title\*\*

    \- Format: \`As a \[user type\], I want to \[action\] so that \[benefit\]\` OR action-oriented title

    \- Keep concise and descriptive (under 10 words when possible)

    

    \#\#\# \*\*Story Description\*\*

    \- \*\*Context\*\*: Brief background explaining why this story exists

    \- \*\*Goal\*\*: What the story aims to achieve

    \- \*\*Technical Notes\*\*: High-level implementation considerations (no detailed specs)

    

    \#\#\# \*\*Acceptance Criteria\*\*

    Use Given-When-Then format or checkbox format:

    \- \*\*Given\*\* \[initial context\]

    \- \*\*When\*\* \[action performed\] 

    \- \*\*Then\*\* \[expected outcome\]

    

    \#\#\# \*\*Story Points\*\*

    Estimate using Fibonacci sequence (1, 2, 3, 5, 8, 13):

    \- 1-2: Simple changes, minor updates

    \- 3-5: Standard features, moderate complexity

    \- 8-13: Complex features, significant effort

    \- 21+: Epic-level work that should be broken down

    

    \#\#\# \*\*Labels/Tags\*\*

    Use relevant technical and functional tags:

    \- Technical: \`frontend\`, \`backend\`, \`api\`, \`database\`, \`mobile\`

    \- Type: \`feature\`, \`bug\`, \`enhancement\`, \`spike\`, \`technical-debt\`

    \- Domain: \`auth\`, \`payments\`, \`notifications\`, \`reporting\`

    

    \#\# Guidelines:

    \- Prioritize user value over technical implementation details

    \- Each story should be completable within one sprint

    \- Include edge cases and error scenarios in acceptance criteria

    \- Consider cross-functional requirements (security, performance, accessibility)

    \- Suggest story dependencies when relevant

    \- Do not create multiple stories, create a single story

    

    \#\# Input Processing:

    Analyze the user query for:

    1\. Core functionality needed

    2\. User types involved

    3\. Business value delivered

    4\. Technical complexity

    

    \---

    \#\# Example Input:

    User Query: ""Add login functionality using Google OAuth""

    

    \#\# Example Output:

    1\. \*\*Title\*\*: Implement Google OAuth Login

       \*\*Description\*\*: Integrate Google OAuth 2.0 into the login page so users can authenticate using their Google accounts. Ensure the backend securely handles token verification and session management.

       \*\*Acceptance Criteria\*\*:

       \- Given a login page, when the user clicks 'Login with Google', they are redirected to Google Auth

       \- After successful login, the user is redirected to the dashboard with an active session

       \- Backend verifies token using Google API and stores minimal user profile

       \*\*Story Points\*\*: 5

       \*\*Labels\*\*: auth, backend, frontend

based on this prompt create a jira story description for this question : integrate baymax sdk in my react application

---

**ASSISTANT:**

### **Story Title**

Integrate Baymax SDK into React Application for Performance Monitoring

### **Story Description**

**Context**: Our React application lacks real-time performance and error monitoring, leading to delayed issue detection and degraded user experience. Baymax SDK provides lightweight instrumentation for tracking frontend metrics (e.g., load times, crashes, API latency).  
**Goal**: Enable seamless integration of Baymax SDK to capture critical performance data without disrupting existing user workflows or increasing bundle size significantly.  
**Technical Notes**:

* Install via `npm install @baymax/sdk-react` and initialize in `App.js` with environment-specific API keys (using `.env` variables).  
* Configure automatic tracking of page views, component mount/unmount, and uncaught errors.  
* Ensure SDK loads asynchronously to avoid blocking main thread; verify \<5% bundle size impact.  
* Implement opt-out mechanism for GDPR compliance (user preference toggle).  
* Validate compatibility with React 18+ and major browsers (Chrome, Firefox, Safari).

### **Acceptance Criteria**

* **Given** I access the React application in production mode  
  **When** the app loads successfully  
  **Then** Baymax SDK initializes silently (no console errors) and sends a `page_view` event to Baymax dashboard  
* **Given** a component throws a runtime error  
  **When** the error occurs during user interaction  
  **Then** Baymax captures the stack trace, component name, and user device info without crashing the app  
* **Given** I enable ““Do Not Track”” in user settings  
  **When** I navigate to any page  
  **Then** no Baymax events are sent (verified via network tab)  
* **Given** Baymax service is unreachable  
  **When** the SDK attempts to send data  
  **Then** the app remains fully functional with \<100ms fallback timeout  
* **Given** I run Lighthouse audit  
  **When** analyzing performance metrics  
  **Then** total blocking time increases by ≤50ms due to SDK integration

### **Story Points**

5 (Moderate complexity: Requires dependency management, async initialization, error handling, GDPR compliance, and cross-browser validation)

### **Labels/Tags**

`frontend` `react` `monitoring` `performance` `feature` `security` `gdpr`

**PROMPT:**  
create a prompt for llm taking the user question into context. The prompt talks about generating the description for a jira story

**RESPONSE 1:**

## Certainly\! Here’s a well-crafted **LLM prompt** that leverages the context of a user question to generate a detailed, structured **Jira story description** following Agile best practices:

## ---

## **Prompt:**

## You are a technical product manager assistant. Based on the user’s request, generate a single, well-structured Jira story that follows Agile INVEST principles (Independent, Negotiable, Valuable, Estimable, Small, Testable). Focus on delivering clear user value and ensure the story can be completed within one sprint.

## Use the following structure:

* ## **Story Title**: Write as “As a \[user type\], I want to \[action\] so that \[benefit\]” or use a concise action-oriented title (under 10 words).

* ## **Story Description**:

  * ## **Context**: Explain the background and why this story matters.

  * ## **Goal**: Define the outcome the team should achieve.

  * ## **Technical Notes**: Highlight high-level implementation considerations (e.g., libraries, architecture, security, performance, accessibility) — *no detailed specs*.

* ## **Acceptance Criteria**: Use **Given-When-Then** format or bullet points to define testable conditions, including edge cases and error handling.

* ## **Story Points**: Estimate effort using Fibonacci sequence (1, 2, 3, 5, 8, 13). Justify briefly based on complexity.

* ## **Labels/Tags**: Apply relevant tags (e.g., `frontend`, `backend`, `feature`, `auth`, `performance`).

## Prioritize user value over technical details. Ensure the story is self-contained, includes cross-functional considerations (security, performance, accessibility), and identifies any known dependencies. Do not split into multiple stories — keep it focused and actionable.

## **User Question**: \[INSERT USER QUESTION HERE\]

## ---

## This prompt ensures consistent, high-quality Jira story outputs tailored to the user’s specific need while enforcing structure, clarity, and Agile alignment.

## **RESPONSE 2:**

#### Here’s a precise, actionable prompt for an LLM to generate Jira story descriptions based on user requirements, strictly adhering to your specified Agile framework and formatting rules:

#### ---

### **LLM Prompt for Jira Story Generation**

#### **Role**: You are a Technical Product Manager assistant specializing in converting user requirements into INVEST-compliant Jira stories. **Task**: Analyze the user query below and generate **exactly one** Jira story following all structural and quality guidelines.

#### **User Query**

#### \[INSERT USER QUERY HERE \- e.g., “integrate baymax sdk in my react application”\]

#### **Strict Output Format (Deviations will invalidate the response):**

#### **1\. Title** `As a [user type], I want to [action] so that [benefit]`

* #### *Constraints*: Under 10 words; action-oriented; user-value focused

#### **2\. Description** **Context**: \[1 sentence explaining *why* this story exists (business/user pain point)\] **Goal**: \[1 sentence stating *what* the story achieves (user outcome)\] **Technical Notes**: \[2-3 bullet points max; high-level tech considerations ONLY – no implementation details\]

#### **3\. Acceptance Criteria** *Use Given-When-Then format (3-5 criteria minimum)*:

* #### Given \[initial context\], when \[action\], then \[expected outcome\]

* #### *Must include*:   ✓ 1 primary success path   ✓ 1 edge case (e.g., error, timeout, invalid input)   ✓ 1 non-functional requirement (security, performance, accessibility, or GDPR)

#### **4\. Story Points** \[Estimate using Fibonacci: 1,2,3,5,8,13\]

* #### *Justification in 1 phrase*: e.g., “(Simple: UI change only)” or “(Complex: auth \+ DB \+ security)”

#### **5\. Labels/Tags** `[technical]` `[type]` `[domain]`

* #### *Technical*: Choose 1-2 from `frontend`, `backend`, `api`, `database`, `mobile`

* #### *Type*: Choose 1 from `feature`, `bug`, `enhancement`, `spike`, `technical-debt`

* #### *Domain*: Choose 1 from `auth`, `payments`, `notifications`, `reporting`, `monitoring`, `analytics`

#### **Non-Negotiable Rules:**

* #### ❌ **NO** multiple stories, subtasks, or epics

* #### ❌ **NO** technical implementation specifics in Description/AC (e.g., “use React Hooks” or “call `/api/v2/login`”)

* #### ❌ **NO** vague AC like “System shall be user-friendly”

* #### ✅ **ALWAYS** prioritize *user value* over technical ease

* #### ✅ **ALWAYS** include cross-functional requirements (security/perf/access) in AC

* #### ✅ **ALWAYS** estimate ≤13 points; if \>13, respond: *“ERROR: Requires splitting into multiple stories (violates INVEST)”*

* #### ✅ **ALWAYS** follow exact bold headers and numbering as shown above

#### **Example Input/Output (for reference only):**

#### *Input*: “Add login functionality using Google OAuth” *Output*: **1\. Title**: As a user, I want to log in via Google OAuth so I access my account securely without manual password entry **2\. Description**: **Context**: Users abandon sign-ups due to password fatigue and security concerns. **Goal**: Enable trusted, low-friction authentication using Google identities. **Technical Notes**:

* #### Frontend: Add Google Sign-In button using Identity Services SDK

* #### Backend: Verify ID tokens via Google API; establish encrypted sessions

* #### Security: Enforce HTTPS; validate token audience/issuer   **3\. Acceptance Criteria**:

* #### Given I am on the login page, when I click ‘Sign in with Google’, then I am redirected to Google’s auth page

* #### Given I successfully authenticate with Google, when I return to the app, then I am logged in and redirected to my dashboard

* #### Given an expired Google token, when the backend processes login, then the request returns HTTP 401 without exposing system details   **4\. Story Points**: 5   **5\. Labels**: `frontend backend` `auth` `feature`

#### ---

### **Why this prompt works:**

1. #### **Eliminates ambiguity** via explicit constraints (word counts, banned phrases, required elements)

2. #### **Forces INVEST compliance** by:

   * #### Requiring user-value framing in Title

   * #### Mandating testability via Given-When-Then AC

   * #### Capping story points at 13 (with auto-rejection for epics)

   * #### Isolating technical notes to avoid over-specification

3. #### **Prevents common LLM pitfalls**:

   * #### Blocks implementation leaks in Description/AC (e.g., no “use Redux” or “call endpoint X”)

   * #### Requires non-functional requirements in AC (security/perf/etc.)

   * #### Uses placeholders (`[user type]`, `[action]`) to ensure LLM adapts to input

4. #### **Matches your examples exactly** in structure, tone, and labeling conventions

#### **To use**: Replace `[INSERT USER QUERY HERE]` with the user’s actual request (e.g., “integrate baymax sdk in my react application”). The LLM will output a single, sprint-ready Jira story following your specifications.

#### ⚠️ **Critical**: If the LLM violates *any* rule (e.g., adds multiple stories, estimates \>13 pts, omits AC edge cases), **reject the output and retry** with this prompt. Consistency requires strict adherence.