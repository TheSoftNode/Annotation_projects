Pre-Submission Checklist

Strengths
☐ Your strengths are written in complete sentences (e.g., starting with “The response…”) and do not begin with a verb.
☐ Each strength highlights one distinct capability only (no grouped or combined strengths).
☐ Your strengths contain no grammar/spelling errors.
☐ Your strengths go beyond basic expectations. Do not list correct grammar, spelling, or understanding of clear user intent. Focus on specific aspects that meaningfully contribute to solving the user’s query.
☐ Your strengths do not also mention areas of improvement.
☐ Your strengths are in the present tense.
• Good Example: The response provides a clear and detailed explanation for all of the code in the prompt, placing an additional emphasis on static_url_path as instructed.
• Good Example: The response is clearly structured with appropriate section headings, which improves readability and makes the information easier for the user to follow.

Areas of Improvement
☐ For every component needing improvement, you clearly describe how the model response failed to meet expectations.
☐ If the response includes code, you have executed the code to verify factual correctness
☐ If the response includes code: verify that it runs successfully and fully satisfies the user’s intended use case. Confirm that all required imports, dependencies, and setup steps are present. Watch for silent or logical failures—cases where the code executes without errors but does not actually do what the user asked (e.g., runs but omits expected outputs, or an app launches but fails to provide the requested information). If the code does not run or does not meet the user’s needs, debug and repair it until it does.
☐ You have captured any invalid URL references
☐ Your areas of improvement are written in complete sentences (e.g., starting with “The response…”) and do not begin with a verb.
☐ You do not over-prioritize conciseness: prefer responses that fully address the user’s query, even if they include some irrelevant detail, over responses that miss key info
☐ You do not penalize references to prior turns unless they significantly reduce readability in the full conversation context.
☐ You do not penalize responses for missing exhaustive error handling unless production-level code is explicitly requested.
☐ You do not nitpick minor presentation details when the response is otherwise clear and correct.
☐ You have flagged any aspects that contradict the LLM’s core principles, including persona, formatting, verbosity, and handling of ambiguity.
☐ You have captured all emoji usage.
☐ You have reviewed the markdown to ensure all code blocks are properly enclosed and tables are correctly formatted.
☐ You have called out formatting improvements.
☐ You have identified unnecessary verbosity or fluff (introductory or concluding pleasantries).

• Good Example:
○ Response Excerpt: Finally, the routes argument is not provided here
○ Description: The response incorrectly claims that routes is an argument of the Blueprint constructor, but routes is actually a file getting imported.

• Good Example:
○ Response Excerpt: 🎉 You’re all set!
○ Description: The response contains several emojis that are unwarranted for the context of a coding response.

• Good Example:
○ Response Excerpt: Below is a complete, ready-to-run example of a minimal chatbot built with Python, Flask, and the OpenAI API (gpt-4o or any GPT-3.5-turbo model). Feel free to copy, paste, and run it on your machine.
○ Description: The response should have asked some clarifying questions since the prompt is too vague to just output code

• Good Example:
○ Response Excerpt:
appendMessage('You', msg);
appendMessage('Bot', data.reply);
.user { color: #0066cc; }
.bot { color: #008800; }
○ Description: There is a mismatch between the JavaScript and CSS in the response, where the JavaScript uses the class names 'You' and 'Bot' while the CSS targets .user and .bot.

Overall Numeric Score
☐ Your overall preference score should be holistically supported by your annotations and reflect how well the response addresses the user’s request, considering both strengths and areas of improvement (AOIs).

Score of 5
• The response fully and clearly meets the user’s request
• Strong throughout, with no meaningful issues
• No areas of improvement that affect correctness, clarity, or usefulness

Score of 4
• The response largely meets the user’s request and is useful overall
• Clear strengths are present
• May include:
○ A few minor areas of improvement, or
○ A single substantial issue that is easy to identify and fix and does not significantly reduce overall usefulness
• Any issues do not materially undermine the response’s ability to help the user

Score of 3
• The response partially meets the user’s request
• Strengths are present but are meaningfully offset by issues
• Includes at least one substantial area of improvement or several minor issues that together reduce usefulness

Score of 2
• The response has significant issues that limit its usefulness
• Only limited strengths, if any
• Fails to adequately address key aspects of the user’s request

Score of 1
• The response fails to meet the user’s request in a meaningful way
• Major gaps, errors, or misunderstandings
• No meaningful strengths to call out

Note: Responses scoring below 5 are not required to be fully runnable. This depends on the severity and impact of the issues and whether the response meaningfully addresses the prompt’s core requirements.

Preference Ranking & Justification
☐ Your preference ranking is supported by the rest of your annotation, and in particular, your overall quality scores for each response
• Slightly Better (0–1 point difference): Use when both responses are largely appropriate and differ only in minor ways (clarity, formatting, or personal preference). An imperfect response rated 4 may still be preferred over a flawless 5 if the issues are purely cosmetic and don’t impact quality.
• Better vs. Much Better (1–2+ point difference):
○ Better: One response is noticeably stronger, with a 1–2 point gap (even if it may still be imperfect).
○ Much Better: One response clearly outperforms the other (2+ point gap), often due to major errors, instruction-following failures, or significant readability issues in the weaker response.
• Neither Response is Valid: Use only when both responses are poor (overall quality scores are ≤ 2) and fail to meaningfully answer the prompt. In these cases, do not rank one over the other to avoid reinforcing flawed behavior.

☐ Preference ranking should prioritize whether the response answers the user’s question, then accuracy, relevance, sufficiency of explanation, and only lastly secondary factors like verbosity, formatting, or grammar.
☐ In the justification statement you refer to the model responses as R1 and R2
☐ In the justification statement, do not restate your ranking preference (e.g., “Bad Example”). Think of the justification as an introductory context that leads into your preference ranking. For example:
“Justification>. Therefore, R2 is much better than R1.”
• Good Example: R2 is factually correct and provides a clear, well-structured explanation of the code, with a strong emphasis on static_url_path and helpful examples. In contrast, R1 contains both a factual error and a counting error, which reduce its reliability and overall usefulness.
• Bad Example: Response 2 is much better than Response 1 because it is more comprehensive and does not contain any factual inaccuracies. Response 1 has a factual error and counting error.
