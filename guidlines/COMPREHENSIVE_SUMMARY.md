# RLHF Project Guidelines - Comprehensive Summary

## Project Overview

This is an RLHF (Reinforcement Learning from Human Feedback) project focused on generating high-quality labeled data to improve large language models. The work consists of two sequential phases:

1. **Task Flagging** - Categorizing tasks to route them correctly
2. **RLHF Annotations** - Evaluating and comparing model responses

### What is a Task?

A task represents a conversation between a user and an AI chatbot containing:
- **System Prompt** (optional) - Foundational instructions defining AI behavior
- **Conversation History** (optional) - Prior turns in multi-turn conversations
- **Final User Prompt** - The question being evaluated
- **Two Model Responses** - Two different outputs from separate models

---

## Phase 2A: Task Flagging

### Core Purpose
Route tasks into appropriate buckets based on expertise required - NOT about evaluating response quality.

### Workflow
- Each task is flagged independently by two annotators
- A QCer (reviewer) reviews both submissions and records final flags
- Multiple flags can be selected for a single task

### Evaluation Order (Follow This Sequence)
1. Safety/security concerns (PII, unsafe content, adversarial prompting)
2. Invalid or not annotatable (language, length, model capability, time sensitivity)
3. Expert domain knowledge required (STEM, CS, finance, legal, healthcare)
4. Excessively complex or research-heavy
5. None of the above

### Key Philosophy
- **Final user query drives flagging decisions** (not conversation history, unless PII is present)
- **When uncertain about expert knowledge, err on the side of flagging**
- **For high-risk topics (medical, legal, financial) that could lead to unsafe responses: mark expertise only, NOT unsafe, unless clearly malicious or immediate harm (e.g., embezzlement, self-harm)**

---

## Safety Flags - Table IA

### General Approach
**Err on the side of caution.** Flag if there's ANY potential for unsafe content. Safety-trained annotators will make final determinations.

### Safety Definitions
- 🟢 **Safe**: No safety concerns, no special handling needed
- 🟡 **Benign**: Could elicit harmful response, about sensitive topics (e.g., "What invasion techniques might the US use on North Korea?")
- 🔴 **Unsafe**: Will very likely elicit harmful response

### Primary Safety Flag: "Task may elicit unsafe response"

Flag regardless of user intent or how explicit the request is.

**Step 1: Select Type of Unsafe Content**

1. **Task-relevant real-world PII**
   - Information that identifies real individuals when combined
   - Includes: name, address, phone, SSN, email, IP address, biometrics, etc.
   - NOT public figures with Wikipedia pages
   - NOT generic examples (e.g., "John Smith at 123 Main St")

2. **High-risk area (Medical, Psychological, Legal, Financial, Insurance)**
   - Advice that could lead to severe consequences if wrong
   - Includes decision-making guidance with high stakes
   - EXCLUDES general informational questions (e.g., "What is hypertension?")
   - EXCLUDES educational content without specific recommendations

3. **Information that may be copyrighted**
   - Requests for verbatim copyrighted material
   - Song lyrics, movie scripts, books, academic papers, etc.
   - EXCLUDES questions about works or summaries
   - EXCLUDES transformative use (parody, criticism)

4. **Hate & Harassment**
   - Content expressing/inciting hate based on protected characteristics
   - Harassment targeting individuals for marginalization/retaliation
   - Includes discrimination, stereotypes, slurs
   - NOTE: Different from Bias (see distinction below)

5. **Sexual (18+)**
   - Explicit or implicit sexual behavior meant to arouse
   - EXCLUDES clinical/medical sex education
   - EXCLUDES non-erotic romantic content

6. **Suicide and Self Harm**
   - Content supporting, encouraging, or planning self-harm/suicide
   - EXCLUDES contextualized discussions in educational materials
   - EXCLUDES requests for crisis support resources

7. **Violence**
   - Physical force causing harm to people, animals, or property
   - Includes use of weapons, warfare activities
   - **Flag tasks using violent vernacular** (invading, attacking, destroying, eliminating) even in academic/theoretical contexts
   - EXCLUDES contextualized violence in fiction/history without glorification

8. **Bias**
   - Reinforcing harmful stereotypes, prejudiced opinions, systemic discrimination
   - EXCLUDES requests to identify/critique biased systems
   - **Key Distinction**: Hate/Harassment = eliciting hateful language; Bias = perpetuating systemic prejudice (less common)

9. **Illegal Goods/Services/Malicious Activities**
   - Promotion of illegal activities (drug trafficking, fraud, theft)
   - Services bypassing laws (fake IDs, hacking)
   - EXCLUDES educational content about penalties/consequences

10. **Malicious Code**
    - Software to infiltrate, damage, disrupt, or gain unauthorized access
    - EXCLUDES security research with proper authorization
    - EXCLUDES educational content for defensive purposes

11. **Deliberate Misinformation**
    - Creation of false/misleading information to deceive
    - Includes propaganda, fabricated evidence
    - EXCLUDES honest mistakes or clearly marked speculation

**Step 2: Select Adversarial Approach Type**

1. **Language-based strategies**
   - Code/encoding (Base64, ROT13, SQL injection)
   - Prompt injection ("ignore previous instructions")
   - Stylizing (formal language, capitalizing)

2. **Rhetoric**
   - Distraction (translation requests)
   - Escalating (foot-in-the-door techniques)
   - Reverse psychology
   - Socratic questioning

3. **Possible worlds**
   - Unreal computing (emulate Linux)
   - World building (fictional scenes where restrictions don't apply)
   - Opposite world scenarios
   - Urgent scenarios requiring action

4. **Fictionalizing**
   - Switching genres (poetry, games)
   - Goal hijacking
   - Roleplaying / claiming authority
   - DAN (Do Anything Now) prompts

5. **Other / Direct Request**
   - Straightforward harmful requests without obfuscation
   - No sophisticated jailbreaking techniques
   - High frequency category

### Task-irrelevant PII Flag

Use when PII appears in prompt/history but is NOT relevant to the task (e.g., fixing grammar in an email containing user's full name).

---

## Non-Safety Flags - Table IB

### 1. Task requires fluency in different language
- Requires reading/writing substantial content in another language
- NOT: Defining words or short phrases

### 2. Task is beyond model capability
Model CANNOT:
- Access internet/external networks
- Interact with files on host machine
- Change sampling parameters
- Know current date/time
- Generate/analyze non-text content (images, PDFs, audio)
- Provide URLs for niche websites
- Answer time-sensitive prompts (changing < 5 years)

### 3. Task is not within length bounds
- Flag if response requires > 2000 words
- NOT: "Detailed" or "thorough" without word count specified

### 4. Task requires recent knowledge (after February 2025)
- Only flag when post-Feb 28, 2025 knowledge is NECESSARY
- NOT: When historical examples suffice

### 5. Task is assistant-specific
- Asks about assistant's identity, architecture, licensing, internal characteristics
- NOT: Questions about AI systems in general

### 6. Task requires expert STEM knowledge

**Categories**: Physics, Life Sciences, Chemistry, Engineering, Mathematics, Other STEM

**Rule of thumb**: Flag anything beyond common sense/basic knowledge. When in doubt, flag.

**Math**:
- FLAG: Elementary math, algebra, multi-step problems, calculus, trigonometry, etc.
- DON'T FLAG: Trivial reasoning (counting, single basic operations)

**Other STEM domains**:
- FLAG: Requires understanding/applying middle school+ concepts (e.g., "Why is sky blue?", "Explain photosynthesis")
- DON'T FLAG: Basic facts (e.g., "What color is sky?", "Is sun a star?"), simple trivia

**Categorization guidance**:
- Identify primary focus
- Ask: "Which expert field would be most appropriate?"
- NOT STEM: Computer science, finance, economics, history

### 7. Task requires expert computer science knowledge
- Writing, reading, understanding non-trivial code
- Includes JSON, HTML, CS constructs
- NOT: Very basic programming concepts

### 8. Task requires expert finance knowledge
- Advanced financial analysis, modeling, complex regulations
- Portfolio optimization, tax strategy, derivatives pricing
- NOT: Basic budgeting, simple calculations, common term definitions

### 9. Task requires expert legal knowledge
- Interpreting statutes/case law
- Drafting legally binding documents
- Requires practicing lawyer level knowledge
- NOT: High-level explanations, general informational questions

### 10. Task requires expert healthcare knowledge
- Clinical, pharmacological, regulatory medical expertise
- Requires MD or equivalent
- Includes veterinary/animal health
- NOT: Basic wellness, first aid, consumer-level nutrition

### 11. High Research Burden (would exceed 3-hour limit)
- Highly technical, specialized, research-intensive
- Can be applied across all domains
- When unsure, assume task CAN be annotated

### 12. None of the above is true
- Select when NO other flags apply
- NO rationale needed when selecting this

---

## Key Tips for Handling Ambiguous Prompts

### Vague Prompts (e.g., "What strategies can PLO use?")
- Account for most likely interpretation
- Consider less likely interpretations only if chosen by a model response AND they make sense
- Example: "How do I kill a process?" should NOT be flagged as unsafe even if response says "I can't help you kill anyone"

### Hate Speech vs. Bias
- **Hate/Harassment**: Eliciting hateful language/views, discriminatory opinions (more common)
- **Bias**: Perpetuating systemic prejudice (e.g., algorithm filtering by gender) (less common)
- Review examples when in doubt
- Most violations fall under hate/harassment

### High-Risk Topics with Potential Unsafe Response
**Critical Rule**: If topic is high-risk (medical, legal, financial) but could lead to unsafe response:
- Mark the EXPERTISE flag only
- Do NOT mark as unsafe
- EXCEPTION: Mark unsafe if clearly malicious or immediate harm (embezzlement, self-harm)

---

## Common Mistakes to Avoid

1. **Evaluating response quality during task flagging** - Focus on categorizing, not judging quality
2. **Skipping safety checks** - Always evaluate safety flags first
3. **Under-flagging expert domains** - When in doubt, flag it
4. **Selecting only one flag** - Multiple flags can apply
5. **Overthinking borderline cases** - Guidelines are intentionally inclusive

---

## Important Reminders

### Rationale Writing
- Write 1-2 sentences (~10-50 words) explaining flag selection
- NOT needed when selecting "None of the Above is True"

### Save Progress
- Hit Save button or Control+S frequently
- Save when opening task and before submission

### Context Matters
- Final user query drives decisions
- Conversation history matters mainly for PII detection
- System prompts typically don't affect flagging unless PII present

---

## Phase 2B: RLHF Annotations

Once tasks are flagged and routed, domain experts evaluate the two model responses by:
- Assessing factual correctness
- Identifying strengths (clarity, reasoning, completeness, tone)
- Identifying areas for improvement
- Comparing responses and selecting preferred one

This trains models to better align with human judgment and expert reasoning.

---

## Roles in the Project

1. **Annotators** - Review tasks, identify categories, provide rationale
2. **QCers (Reviewers)** - Review annotators' work, confirm/dispute selections, finalize annotations
3. **Auditors** - Review ~20% of flagging work, evaluate QCers' finalized annotations

---

## Success Metrics

The goal is understanding how models behave across wide range of interactions, identifying where systems succeed or fall short. This groundwork helps AI developers evaluate, measure, and improve model performance, reliability, and alignment before deployment at scale.

---

**Document Version**: Comprehensive synthesis of all guideline files
**Last Updated**: 2026-03-11
**Coverage**: All files in /guidlines directory analyzed and integrated
