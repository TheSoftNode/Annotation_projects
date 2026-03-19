Code Supplemental Guidance

Determining Severity of Areas of Improvement
When identifying limitations in a response, severity should be determined based on impact, not intent or effort.
Severity depends on how much the issue interferes with the user’s ability to correctly, safely, and effectively achieve their goal.
Context always matters, but severity should be evaluated primarily across three dimensions:
• Correctness – Is the information or solution technically accurate?
• Functionality / Applicability – Does it work as intended for the user’s stated or clearly implied use case?
• Reliability – Would a reasonable user trust and reuse this response without being misled?

Substantial Areas of Improvement
A substantial issue is a problem that materially undermines the response’s core utility, correctness, or reliability. These issues significantly reduce the overall quality of the response and often require meaningful correction.
Substantial issues typically include:
Code & Execution Issues
• Code that fails to run, crashes, or errors in a standard execution environment
• Code that runs but produces incorrect, incomplete, or misleading results
• Silent or logical failures where execution succeeds but the user’s goal is not actually met (e.g., missing outputs, incorrect filtering logic, incomplete processing)
• Missing critical dependencies, imports, or setup steps that prevent real-world use
Technical Correctness Issues (Beyond Code)
• Incorrect explanations of technical concepts, APIs, algorithms, or system behavior
• Flawed system design reasoning that would not work in practice
• Recommendations that are technically unsound, misleading, or unsafe for the described scenario
C. Instruction-Following & Intent Failures
• The response does not meaningfully address the user’s core question or objective
• The solution solves a different problem than the one the user asked
• The response should ask clarifying questions due to ambiguity but instead makes unjustified assumptions

Minor Areas of Improvement
A minor issue is an area for improvement that does not undermine the response’s core correctness or usability. The response remains broadly useful despite the issue.
Minor issues typically include:
A. Code Quality & Robustness
• Non-critical inefficiencies or suboptimal implementation choices
• Missing edge-case handling when not explicitly requested
• Limited error handling when production-level robustness is not required

B. Explanation & Clarity
• Explanations that are shorter, less clear, or less structured than ideal
• Missing optional context that would improve understanding but is not necessary for correctness
• Slight mismatches in terminology that do not create technical inaccuracies

C. Style & Presentation
• Formatting, readability, or organization issues
• Excessive or insufficient verbosity relative to expectations
• Minor stylistic inconsistencies with language or framework conventions

Applying Severity to Different Types of Tasks
Code Generation & Debugging
• Incorrect logic, broken execution, unmet requirements, or significant edge-case failures (including edge cases that cause silent or hard-to-detect failures and would reasonably mislead the user) → Substantial
• Style issues, missing comments, non-optimal structure, or limited edge-case handling (when the core logic works and the user’s primary goal is met) → Minor

Technical Explanations
• Incorrect or misleading technical claims → Substantial
• Shallow or less detailed explanations → Minor

System Design / Architecture
• Designs that would not work in practice or ignore key constraints → Substantial
• Missing scalability discussion or optional tradeoffs → Minor

Ambiguous Prompts
• Failing to ask clarifying questions when ambiguity blocks correctness → Substantial
• Making reasonable assumptions but noting them clearly → Usually Minor

Edge Case Handling
Evaluate edge-case handling based on likelihood, detectability, and expected robustness.
• Substantial: Edge cases that are likely to occur and cause silent, hard-to-detect failures or incorrect results, especially when the user would reasonably trust the code as-is.
• Minor: Missing or incomplete handling of rare or non-critical edge cases when the core functionality works and production-level robustness was not requested.

Production-level code:
If the prompt explicitly or implicitly requests production-ready code, robust edge-case handling is expected. Silent failures or crashes due to malformed or unexpected inputs should be treated as substantial issues.

Example:
• A script runs successfully but silently drops valid values due to unexpected input types → Substantial
• A function works for normal inputs but does not handle empty lists when not requested → Minor

Completeness (Code & Technical Responses)
A complete response enables the user to understand and use the solution, not just see the code.
• Explanation: The response should provide enough explanation for the user to follow the logic. A separate explanation section is not always required; clear structure and meaningful comments may be sufficient for simple code. Use judgment based on complexity and user needs.
• Context & Setup: When relevant, the response should mention required libraries, dependencies, or setup steps (e.g., installation commands). This is not mandatory when installation is outside the scope of the user’s request.
• Usage Example: When helpful, include an example showing how to use the solution (e.g., a function call or docstring example). Usage examples are optional for simple snippets or purely conceptual explanations.
• Style & Readability: Code should follow established best practices for the language (e.g., PEP 8 for Python). For languages without strict standards, a consistent and sensible style is sufficient. Tools such as IDE linters may be used to validate style automatically.
○ Minor style deviations (e.g., variable naming, missing docstrings) should be treated as minor issues unless they significantly affect readability.
○ If the user explicitly requests adherence to a specific style guide, failure to follow it should be treated as a substantial issue due to instruction-following failure.
