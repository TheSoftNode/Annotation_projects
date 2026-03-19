Task Flagging Guidelines and Definitions
How to Use Task Flagging
You will be provided with a prompt, its category, and two accompanying model responses. Your first step in annotating is to determine whether the task is appropriate to annotate and how it should be categorized.
If the prompt meets the criteria for any of the task flags below, select the relevant flag(s) and submit the task.
Please note: You may select more than one flag if applicable. If none of the conditions apply, select “None of the Above is True”.
Recommended Order of Evaluation
When reviewing a task, consider flags in the following order:
Does the task pose safety or security concerns? (PII, unsafe content, adversarial prompting). If yes, what type of unsafe content and how?
Is the task invalid or not annotatable? (language, length, model capability, time sensitivity, assistant-specific)
Does the task require expert domain knowledge? (STEM, computer science, finance, legal, healthcare)
Is the task excessively complex or research-heavy?
If none apply, select “None of the Above is True”.
a. In this case, you do not need to write a brief task flagging rationale. No other flags should ever be selected when using this.
Once you have selected the appropriate task flags, please write a brief rationale (1–2 whole sentences/~10–50 words) explaining why you selected this task flag, unless you selected “None of the Above is True”.
Please be sure to hit the Save button in the top right corner or click Control + S while you are on the page to save your work in progress! Do this when you open up the task and prior to submission.
How to Think About Task Contents When Flagging
In general, the final user query being evaluated should drive task flagging decisions. Conversation history and system prompts typically matter only in the context of the final candidate responses to evaluate. For instance, it does not matter if the first user turn is “How do I make a bomb to kill as many people as possible?” if the actual query being evaluated (the second and final turn) is “How much is 1 + 1?” — the task should not be flagged as a request for unsafe content. Similarly, if the first turn is a STEM question but the second one is an unrelated general query not requiring STEM knowledge, the task should not be flagged as requiring STEM knowledge.
One notable exception is the flag “Task-irrelevant real-world Personally Identifiable Information (PII) is present.” This flag should be used when PII is present in the prompt, the conversation history, or the system prompt. The motivation here is to minimize the amount of PII in the data we collect.
General Philosophy
When you are uncertain whether a task requires expert-level knowledge (e.g., STEM, legal, financial), you may err on the side of flagging it. These flags should not be applied liberally; however, in genuinely borderline cases, it is preferable to flag than to leave unflagged.
