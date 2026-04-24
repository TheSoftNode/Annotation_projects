Below I’m only listing the parts of **RESPONSE 2** that contain a real-world factual claim or a checkable comparative claim. Everything else in that response is just prompt instructions, constraints, or opinion.

## **1\) Factual / checkable claims from RESPONSE 2**

### **1\. Claim: `"INVEST-compliant Jira stories"`**

What is being claimed, exactly:

* That **INVEST** is a recognized framework used to evaluate user stories.  
* That “INVEST” has a standard meaning in Agile/user-story practice.

How to verify manually:

* Check Bill Wake’s original INVEST article.  
* Confirm the acronym and its intended use for stories. ([XP123](https://xp123.com/invest-in-good-stories-and-smart-tasks/?utm_source=chatgpt.com))

Verification status:

* **Supported.**  
* Bill Wake’s article explicitly defines INVEST as a mnemonic for good stories: Independent, Negotiable, Valuable, Estimable, Small, Testable. ([XP123](https://xp123.com/invest-in-good-stories-and-smart-tasks/?utm_source=chatgpt.com))

---

### **2\. Claim: `"Use Given-When-Then format"`**

What is being claimed, exactly:

* That **Given-When-Then** is a recognized format for acceptance tests / acceptance criteria for user stories.

How to verify manually:

* Check Agile Alliance’s glossary entry for Given-When-Then.  
* Check Atlassian’s acceptance-criteria guidance. ([Agile Alliance](https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com))

Verification status:

* **Supported, with nuance.**  
* Agile Alliance defines Given-When-Then as a template intended to guide the writing of acceptance tests for a user story. ([Agile Alliance](https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com))  
* Atlassian describes acceptance criteria as predefined, testable conditions, and Atlassian community guidance says they are often written as Given-When-Then or a short checklist. ([Atlassian](https://www.atlassian.com/work-management/project-management/acceptance-criteria?utm_source=chatgpt.com))  
* The response wording makes it sound mandatory, but the sources support it as a **common/recommended format**, not a universal Jira platform requirement. ([Agile Alliance](https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com))

---

### **3\. Claim: `"Estimate using Fibonacci: 1,2,3,5,8,13"`**

What is being claimed, exactly:

* That story points are commonly estimated using Fibonacci numbers.  
* That the sequence listed is used for Agile estimation.

How to verify manually:

* Check Atlassian’s story-point guidance. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))

Verification status:

* **Supported as a common Agile practice, not a universal requirement.**  
* Atlassian says Fibonacci story points are a way to estimate the relative effort or complexity of work items in Agile using Fibonacci numbers. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))  
* Atlassian also says story points are a relative estimation method for effort, complexity, and risk. ([Atlassian](https://www.atlassian.com/agile/project-management/estimation?utm_source=chatgpt.com))  
* So this is a valid common practice, but not the only valid estimation scale. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))

---

### **4\. Claim: `"Capping story points at 13 (with auto-rejection for epics)"`**

What is being claimed, exactly:

* That stories above 13 points should automatically be treated as epics or rejected.

How to verify manually:

* Check whether Agile/Jira sources define **13 as a hard ceiling** for stories.  
* Check whether “auto-rejection” is a standard rule.

Verification status:

* **Not supported as a universal factual rule.**  
* Atlassian supports using story points and relative estimation, but does **not** establish a universal rule that anything above 13 must be rejected. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))  
* Agile sources discuss epics as larger bodies of work, but I did not find a primary source establishing **“\>13 must be rejected”** as a standard rule. ([Agile Alliance](https://agilealliance.org/epic-confusion/?utm_source=chatgpt.com))

What disputes it:

* The lack of an authoritative Jira/Agile rule making 13 a mandatory cutoff disputes the wording as a fact.  
* This appears to be a **prompt policy choice**, not a universally true Agile rule. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))

---

### **5\. Claim: `"Mandating testability via Given-When-Then AC"`**

What is being claimed, exactly:

* That Given-When-Then supports testability of acceptance criteria.

How to verify manually:

* Check Agile Alliance’s definition of Given-When-Then.  
* Check Atlassian’s definition of acceptance criteria. ([Agile Alliance](https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com))

Verification status:

* **Supported.**  
* Agile Alliance says Given-When-Then is used to guide acceptance tests for a user story. ([Agile Alliance](https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com))  
* Atlassian says acceptance criteria are predefined requirements and conditions that must be met to be complete and accepted, which aligns with testability. ([Atlassian](https://www.atlassian.com/work-management/project-management/acceptance-criteria?utm_source=chatgpt.com))

---

### **6\. Claim: `"Requires non-functional requirements in AC (security/perf/etc.)"`**

What is being claimed, exactly:

* That non-functional requirements like security, performance, accessibility, or GDPR belong in acceptance criteria.

How to verify manually:

* Check whether authoritative Agile/Jira guidance says they can or should be included in AC.

Verification status:

* **Partially supported as best practice, not as a universal rule.**  
* Atlassian says acceptance criteria define the conditions a work item must meet to be accepted. That can include functional and non-functional conditions if those are required for acceptance. ([Atlassian](https://www.atlassian.com/work-management/project-management/acceptance-criteria?utm_source=chatgpt.com))  
* I did **not** find a primary source saying acceptance criteria must always include a non-functional requirement in every story.  
* So this is better treated as a **strong prompt preference/best practice**, not a factually universal rule. ([Atlassian](https://www.atlassian.com/work-management/project-management/acceptance-criteria?utm_source=chatgpt.com))

---

### **7\. Claim: `"Matches your examples exactly in structure, tone, and labeling conventions"`**

What is being claimed, exactly:

* That RESPONSE 2 matches the user’s example/output exactly in:  
  * structure,  
  * tone,  
  * labeling conventions.

How to verify manually:

* Compare RESPONSE 2 directly against the example in the conversation.

Verification status:

* **Not accurate as written.**  
* It does **not** match the example **exactly**.  
* Differences include:  
  * RESPONSE 2 uses numbered headers like `1. Title`, `2. Description`, etc.  
  * The example uses `**Title**`, `**Description**`, `**Acceptance Criteria**`, `**Story Points**`, `**Labels**`.  
  * RESPONSE 2 adds stricter rules not present in the example, such as “3-5 criteria minimum,” “under 10 words,” and “ERROR: Requires splitting into multiple stories.”  
  * RESPONSE 2 expands the allowed domain labels to include `monitoring`, `analytics`, which were not in the original domain list shown by the user.

Because this is a direct comparison to text already in the conversation, no external source is needed for the dispute.

---

### **8\. Claim: `"Eliminates ambiguity"`**

### **9\. Claim: `"Forces INVEST compliance"`**

### **10\. Claim: `"Prevents common LLM pitfalls"`**

### **11\. Claim: `"The LLM will output a single, sprint-ready Jira story following your specifications."`**

### **12\. Claim: `"Consistency requires strict adherence."`**

What is being claimed, exactly:

* These are performance/quality claims about what the prompt will cause an LLM to do.

Verification status:

* **Not factual claims in the strict sense.**  
* These are **evaluative or predictive claims**, not fixed facts.  
* They cannot be verified from an authoritative standard the way INVEST or Fibonacci estimation can.  
* They can only be **tested empirically** by running the prompt against one or more models.

No primary source really applies here because these are not standards-based facts.

---

## **2\) Things in RESPONSE 2 that are not factual claims**

These are prompt instructions or constraints, not facts:

* `"generate exactly one Jira story"`  
* `"Deviations will invalidate the response"`  
* `"Under 10 words"`  
* `"2-3 bullet points max"`  
* `"3-5 criteria minimum"`  
* `"NO multiple stories, subtasks, or epics"`  
* `"NO technical implementation specifics"`  
* `"ALWAYS prioritize user value"`  
* `"ALWAYS follow exact bold headers and numbering as shown above"`

These are not true/false claims about the world. They are author-imposed rules for the prompt.

---

## **3\) Code applicability**

There is **no executable code** in RESPONSE 2\.

What RESPONSE 2 contains:

* plain text,  
* markdown formatting,  
* placeholders,  
* prompt instructions,  
* example text.

What it does **not** contain:

* shell commands to run,  
* JavaScript/TypeScript,  
* Python,  
* JSON to execute,  
* API requests,  
* config files.

So for your requested **code testing** section, the correct answer is:

### **No code testing is applicable for RESPONSE 2\.**

---

## **4\) Best environment for testing RESPONSE 2**

Use your **Mac**.

Why:

* This is a prompt-quality and factual-claim audit task.  
* You do not need GitHub Codespaces.  
* You do not need terminal commands.  
* You do not need to install any dependencies.

### **Dependencies needed first**

None.

Optional only:

* access to an LLM chat interface if you want to test the prompt’s behavior.

---

## **5\) Step-by-step manual testing plan for RESPONSE 2**

Since there is no code, the only thing you can test is whether the prompt behaves the way RESPONSE 2 claims it will.

### **Test A: Check whether it produces exactly one Jira story**

1. On your Mac, open the LLM you want to test.  
2. Paste the prompt from RESPONSE 2 **verbatim**.  
3. Replace:  
   * `[INSERT USER QUERY HERE]`  
     with a real query, for example:  
   * `integrate baymax sdk in my react application`  
4. Submit it.

Expected result:

* One Jira story only.  
* No subtasks, no multiple stories, no epic breakdown.

What to record:

* Did it output exactly one story?  
* Did it violate any formatting rule?

---

### **Test B: Check the “exact format” behavior**

1. Run the prompt once.  
2. Check whether the output includes:  
   * `1. Title`  
   * `2. Description`  
   * `3. Acceptance Criteria`  
   * `4. Story Points`  
   * `5. Labels/Tags`

Expected result:

* The output should follow that numbered structure if the model obeys the prompt.

What to record:

* Missing sections  
* Extra sections  
* Wrong header wording  
* Whether the model used exact bold headers/numbering

---

### **Test C: Check the Given-When-Then claim**

1. Run the same prompt.  
2. Inspect the acceptance criteria.

Expected result:

* Acceptance criteria should be in Given-When-Then form.  
* There should be at least:  
  * 1 success path,  
  * 1 edge case,  
  * 1 non-functional requirement.

What to record:

* Did it actually use Given-When-Then?  
* Did it include edge/error cases?  
* Did it include security/performance/accessibility/GDPR?

---

### **Test D: Check the Fibonacci claim**

1. Run the prompt with several different inputs:  
   * a very small change,  
   * a medium feature,  
   * a more complex feature.  
2. Record the returned story points.

Expected result:

* The story point value should usually be one of:  
  * `1, 2, 3, 5, 8, 13`

What to record:

* Whether the model ever uses values outside that set  
* Whether the estimate seems tied to complexity

---

### **Test E: Check the “\>13 should error” claim**

1. Paste the prompt exactly as written.  
2. Use a deliberately large query, for example a huge multi-system requirement.  
3. Submit it.

Expected result:

* If the model obeys the prompt strictly, it should return:  
  * `"ERROR: Requires splitting into multiple stories (violates INVEST)"`

What to record:

* Did it actually reject?  
* Or did it still produce a story anyway?

This is the most direct way to test the claim:

* `"ALWAYS estimate ≤13 points; if >13, respond: "ERROR: Requires splitting into multiple stories (violates INVEST)""`

---

### **Test F: Check the “prevents common LLM pitfalls” claim**

1. Use the same prompt 3 to 5 times with the same user query.  
2. Compare outputs.

Expected result:

* Structure should remain mostly consistent.  
* Content may vary.

What to record:

* Whether it leaks technical implementation details into the Description or AC  
* Whether it forgets non-functional requirements  
* Whether it drifts from the requested format

This does **not** prove the claim as fact, but it does let you test it practically.

---

## **6\) What may be inaccurate in RESPONSE 2**

These are the places I would watch most closely when you test:

1. Claim: `"Matches your examples exactly in structure, tone, and labeling conventions"`  
* This already looks inaccurate based on direct comparison.  
2. Claim: `"Capping story points at 13 (with auto-rejection for epics)"`  
* This looks like a prompt rule, not an Agile/Jira fact. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))  
3. Claim: `"Requires non-functional requirements in AC"`  
* Reasonable as guidance, but not a universal standard requirement for every story. ([Atlassian](https://www.atlassian.com/work-management/project-management/acceptance-criteria?utm_source=chatgpt.com))  
4. Claim: `"Eliminates ambiguity"`, `"Forces INVEST compliance"`, `"Prevents common LLM pitfalls"`  
* These are performance claims, not objective facts.

---

## **7\) Send me your report in this format**

1. Claim: `"INVEST-compliant Jira stories"`  
   * What I checked:  
   * What I found:  
   * Source used:  
2. Claim: `"Use Given-When-Then format"`  
   * What I checked:  
   * What I found:  
   * Source used:  
3. Claim: `"Estimate using Fibonacci: 1,2,3,5,8,13"`  
   * What I checked:  
   * What I found:  
   * Source used:  
4. Claim: `"Capping story points at 13 (with auto-rejection for epics)"`  
   * What I checked:  
   * What I found:  
   * Source used:  
5. Claim: `"Matches your examples exactly in structure, tone, and labeling conventions"`  
   * What I checked:  
   * What I found:  
6. Claim: `"The LLM will output a single, sprint-ready Jira story following your specifications."`  
   * What I checked:  
   * What I found:  
   * Why this is or is not verifiable:

If you paste the next response, I’ll keep using this exact claim-audit format.

