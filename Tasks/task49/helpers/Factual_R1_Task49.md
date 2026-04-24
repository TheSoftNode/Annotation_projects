Below I’m only breaking down the parts of **RESPONSE 1** that contain a factual or checkable claim. Everything else in that response is either instruction text, style guidance, or opinion.

## **1\) Factual / checkable claims from RESPONSE 1**

### **1\. Claim: `"Agile INVEST principles (Independent, Negotiable, Valuable, Estimable, Small, Testable)."`**

What is being claimed, exactly:

* That **INVEST** is an Agile/user-story concept.  
* That the letters expand to:  
  * **Independent**  
  * **Negotiable**  
  * **Valuable**  
  * **Estimable**  
  * **Small**  
  * **Testable**

How to verify manually:

* Look up Bill Wake’s original INVEST reference and check the acronym expansion.  
* Best source to check first: Bill Wake’s own site. ([XP123](https://xp123.com/invest-in-good-stories-and-smart-tasks/?utm_source=chatgpt.com))

Verification status:

* **Supported.** Bill Wake’s article explicitly gives the INVEST expansion exactly that way. ([XP123](https://xp123.com/invest-in-good-stories-and-smart-tasks/?utm_source=chatgpt.com))

---

### **2\. Claim: `"Acceptance Criteria: Use Given-When-Then format or bullet points to define testable conditions, including edge cases and error handling."`**

What is being claimed, exactly:

* That **Given-When-Then** is an accepted format for writing acceptance criteria.  
* That **bullet/checklist format** is also used for acceptance criteria.  
* That acceptance criteria should be **testable**.

How to verify manually:

* Check an Agile source for what Given-When-Then is.  
* Check an Atlassian source for how acceptance criteria are commonly written. ([Agile Alliance](https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com))

Verification status:

* **Mostly supported, with nuance.**  
* Agile Alliance defines **Given-When-Then** as a template for acceptance tests for a user story. ([Agile Alliance](https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com))  
* Atlassian says acceptance criteria are clear, concise, and testable, and notes common formats including Given-When-Then and checklist-style criteria. ([Atlassian](https://www.atlassian.com/work-management/project-management/acceptance-criteria?utm_source=chatgpt.com))  
* The response wording says “**Use** Given-When-Then format or bullet points,” which is fine as guidance, but it is **not a universal Jira rule**. It is a recommended/common practice, not a hard platform requirement. ([Atlassian Community](https://community.atlassian.com/forums/App-Central-articles/Acceptance-criteria-in-Jira-how-to-write-store-and-validate-them/ba-p/3165137?utm_source=chatgpt.com))

---

### **3\. Claim: `"Story Points: Estimate effort using Fibonacci sequence (1, 2, 3, 5, 8, 13). Justify briefly based on complexity."`**

What is being claimed, exactly:

* That story points are estimated using the **Fibonacci sequence**.  
* That the sequence listed is **1, 2, 3, 5, 8, 13**.  
* That this is tied to **complexity/relative effort**.

How to verify manually:

* Check whether Agile/Jira sources describe Fibonacci-based story points.  
* Check whether story points are described as relative estimates of effort/complexity. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))

Verification status:

* **Supported as a common Agile practice, but not a universal requirement.**  
* Atlassian says Fibonacci story points are a way to estimate relative effort/complexity using numbers from the Fibonacci sequence. ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))  
* Atlassian also says story points are a **relative estimation method** for effort, complexity, and risk. ([Atlassian](https://www.atlassian.com/agile/project-management/estimation?utm_source=chatgpt.com))  
* The response wording may sound mandatory, but the better reading is: this is a **recommended/common approach**, not the only valid one. Atlassian’s wording supports “a way,” not “the only way.” ([Atlassian](https://www.atlassian.com/agile/project-management/fibonacci-story-points?utm_source=chatgpt.com))

---

### **4\. Claim: `"This prompt ensures consistent, high-quality Jira story outputs tailored to the user’s specific need while enforcing structure, clarity, and Agile alignment."`**

What is being claimed, exactly:

* That the prompt will **ensure**:  
  * consistency,  
  * high quality,  
  * tailoring to the user’s need,  
  * structure,  
  * clarity,  
  * Agile alignment.

Verification status:

* **Not a factual claim you can verify as stated.**  
* This is an **evaluative/performance claim**, not a concrete fact like a definition or standard.  
* “Ensures,” “high-quality,” and “tailored” depend on the LLM, model behavior, and output quality thresholds.  
* I did **not** find a primary source that could prove this exact guarantee, because it is not a standards-based factual statement. It is closer to marketing/opinion language than a verifiable fact.

---

## **2\) Things in RESPONSE 1 that are not really factual claims**

These are instructions or preferences, not facts:

* `"generate a single, well-structured Jira story"`  
* `"Focus on delivering clear user value"`  
* `"under 10 words"`  
* `"no detailed specs"`  
* `"Prioritize user value over technical details"`  
* `"Ensure the story is self-contained"`  
* `"Do not split into multiple stories — keep it focused and actionable"`

These are not the kind of statements you verify as true/false against a source. They are prompt constraints.

---

## **3\) Code applicability**

There is **no code** in RESPONSE 1\.

That means:

* no script,  
* no command,  
* no API call,  
* no library import,  
* no config,  
* no markup,  
* no executable example.

So for your section **“CODE (IF APPLICABLE)”**, the correct conclusion is:

### **No code testing is applicable for RESPONSE 1\.**

---

## **4\) How to manually test RESPONSE 1 anyway**

Since there is no code, what you can test is the **behavioral claim** of the prompt: whether it actually produces the kind of Jira story it says it will.

### **Best environment**

Use your **Mac** for this one.

Why:

* You do not need a terminal.  
* You do not need GitHub Codespaces.  
* This is a plain-text prompt evaluation task, not a runtime/code execution task.

### **Dependencies you need first**

None.

Optional only:

* Access to an LLM chat UI or API if you want repeatable tests.

---

## **5\) Step-by-step manual test plan for RESPONSE 1**

### **Test A: Check whether the prompt really produces one Jira story**

1. Open your LLM on your Mac.  
2. Paste **RESPONSE 1’s prompt verbatim**.  
3. Replace:  
   * `User Question: [INSERT USER QUESTION HERE]`  
     with a real input, for example:  
   * `User Question: integrate baymax sdk in my react application`  
4. Submit it.

Expected result:

* The output should contain **one** Jira story, not multiple.

What to record:

* Did it generate exactly one story?  
* Did it stay on-topic?

---

### **Test B: Check whether it uses INVEST-aligned structure**

1. Run the same prompt.  
2. Inspect the output manually.

Expected result:

* You should see:  
  * a **Story Title**  
  * a **Story Description**  
  * **Acceptance Criteria**  
  * **Story Points**  
  * **Labels/Tags**

What to record:

* Missing sections  
* Extra sections  
* Whether the story is small enough to look sprint-sized

---

### **Test C: Check the acceptance-criteria format claim**

1. Use the same prompt.  
2. Look specifically at the acceptance criteria.

Expected result:

* The model should produce either:  
  * **Given-When-Then** criteria, or  
  * bullet/checklist acceptance criteria.

What to record:

* Which format it used  
* Whether the criteria are testable  
* Whether edge cases/error handling are included

---

### **Test D: Check the story-points claim**

1. Run the prompt with 3 different inputs:  
   * simple feature,  
   * medium feature,  
   * complex feature.  
2. Look at the story point values returned.

Expected result:

* Values should usually come from:  
  * **1, 2, 3, 5, 8, 13**

What to record:

* Whether it uses only those values  
* Whether the justification matches complexity

---

### **Test E: Check the “high-quality / consistent” claim**

This is the closest thing to testing the non-factual claim.

1. Use the exact same prompt 3 times with the same user question.  
2. Compare outputs.

Expected result:

* If the claim were strong, outputs would be consistently structured.  
* Content may vary, but structure should remain stable.

What to record:

* Did all outputs keep the same sections?  
* Did quality vary a lot?  
* Did any output violate the prompt constraints?

Note:

* This does **not** prove the claim as fact.  
* It only gives you evidence about whether the claim seems reasonable in practice.

---

## **6\) What you should send me back**

Send me your findings in this format:

1. Claim: `"Agile INVEST principles (Independent, Negotiable, Valuable, Estimable, Small, Testable)."`  
   * What I checked:  
   * What I found:  
   * Source used:  
2. Claim: `"Acceptance Criteria: Use Given-When-Then format or bullet points to define testable conditions, including edge cases and error handling."`  
   * What I checked:  
   * What I found:  
   * Source used:  
3. Claim: `"Story Points: Estimate effort using Fibonacci sequence (1, 2, 3, 5, 8, 13). Justify briefly based on complexity."`  
   * What I checked:  
   * What I found:  
   * Source used:  
4. Claim: `"This prompt ensures consistent, high-quality Jira story outputs tailored to the user’s specific need while enforcing structure, clarity, and Agile alignment."`  
   * What I checked:  
   * What I found:  
   * Why it is or is not verifiable:

If you want, paste the next response you want audited and I’ll break it down in the exact same format.

