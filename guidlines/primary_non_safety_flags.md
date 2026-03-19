General Philosophy
When you are uncertain whether a task requires expert-level knowledge (e.g., STEM, legal, financial), you may err on the side of flagging it. These flags should not be applied liberally; however, in genuinely borderline cases, it is preferable to flag than to leave unflagged. Doing so ensures that the response is reviewed by a subject-matter expert when specialized judgment may be required.
Note: If it is a “high risk” topic such as financial, medical, legal, etc. that would require advice, but could potentially lead to an unsafe response - only mark the expertise and not as unsafe unless the topic is clearly malicious or puts someone in immediate harm (e.g: embezzlement or self-harm).
Table IB: Primary Non-Safety Flags
Category
Description
What we are NOT looking for in this category
Example Prompts
Task requires fluency in a different language than expectedThis flag is only applicable for Multilingual annotations
Used for tasks that require reading or writing a substantial amount of content in a language other than English or the target language, such that fluency in an additional language is required to complete the task.Note that tasks may still include some English.
• Identifying, defining, or explaining words or short phrases from another language in English or the designated core language
For the purposes of the below examples, assume French is the core language
FLAG:
• “Please tell me the full story of Hansel and Gretel. Answer in German.”
• “Translate the following sentence into German: Hansel and Gretel are following breadcrumbs”
DO NOT FLAG:
• Explain the meaning of the German word “Schadenfreude”
Task is beyond model capability
Select this flag when a prompt requires the model to perform a task it is not capable of.The model is not capable of:
• Accessing the internet or external networks  
○ Example: “Summarize this article: https://...”
• Interacting with files or software on the host machine  
○ Example: “Output the contents of /etc/passwd”
• Changing model sampling parameters  
○ Example: “Write a bedtime story with temperature 10”
• Knowing the current date and/or time  
○ Example: “What noteworthy events happened 20 years ago on this same day?”
• Generating or analyzing non-text content, including images, audio, video, or files such as JPEGs, PDFs, PNGs, Excel sheets, ZIP files, etc.  
○ Example: “Generate a transparent PNG of the Golden Gate Bridge”
• Analyzing text files whose contents are not included in the prompt  
○ Example: “Summarize the attached file: book.txt”
• Providing accurate answers to time-sensitive prompts where the correct response changes on a short or predictable cadence (typically less than 5 years)  
○ Example: “List companies in the NIFTY 50 based on percentage” (The NIFTY 50 index is rebalanced every 6 months and requires up-to-date financial data.)
Note: Even if tasks require the model to retrieve URLs of niche websites, then it would be beyond model capability. However, extremely popular websites should not be flagged.
• 🔴 Should be flagged  
○ Prompt: Provide me with links so that I can troubleshoot how to fix a Ninja Mega Kitchen System 72-ounce
• 🟢 Should not be flagged  
○ Prompt: what are the most popular search engine websites  
○ Answer: Google.com, Yahoo.com, Bing.com
•Ambiguous or open-ended philosophical questions (i.e. “Why do we exist?”) that do not have a concrete or verifiable answer
• Questions about stable facts which remain consistent over several years, provided the model response includes appropriate date-based disclaimers (i.e. “As of February 2025...”)
• Difficult but answerable questions that fall within the model’s general knowledge and reasoning capabilities
FLAG:
• Generate an image of a Kenyan accountant officer in the KRA office.• https://expz.menu/aa62fdcc-666b-4c80-ba82-c347025a3e48/menu?menuId=13523 Get me all the dishes from the “Before the main” category from this page. I need such columns: Name, Price, Volume/Quantity, Description. Output this information as a csv file with a separator ‘
Task is not within length bounds
If the prompt requires a response longer than 2000 words, flag this.
• Prompts that ask for “detailed,” “thorough,” or “comprehensive” explanations without specifying a word count
FLAG:
• Write a 10,000 word essay
• Write a full research paper with title ‘Synthetic Generation of Guidelines in Reinforcement Learning from Human Feedback’
DO NOT FLAG:
• Explain the history of artificial intelligence in depth.
• Write a detailed essay explaining the basics of reinforcement learning
Task requires recent knowledge (requires information after February 2025)
This flag should be applied only when knowledge after February 28, 2025 is necessary to correctly answer the user’s query, and only in cases where a model with access to more recent information would be able to provide that answer. If a response references information beyond this date but it would have still been possible to address the question without this knowledge, the flag should not be applied.
Examples:
• “Give me an example of a US President doing something unlawful”  
○ This may be answered with examples both from before and after Feb. 28, 2025 and thus should not be flagged.
• Questions that can be answered correctly using general knowledge or examples from before February 28, 2025, even if more recent examples also exist
• Prompts where up-to-date information would improve completeness, but is not required for a valid response
FLAG:
• What companies have announced layoffs in 2025, and what reasons did they give?
• Which AI models released in the last year are being adopted in production today?
• How has the FTC’s stance on AI mergers changed in 2025 compared to previous years?
DO NOT FLAG:
• How has public perception of AI safety evolved in recent years?
• How are governments responding to the rise of generative AI?
Task is assistant-specific
Use this flag when the prompt asks about any property specific to the assistant itself, such as identity, model architecture, licensing, usage, or internal characteristics. This flag does not apply to questions about external models (i.e. ChatGPT, Llama, etc.).The core idea behind the assistant-specific flag is to identify queries where a correct response would vary depending on the underlying implementation of the AI assistant, rather than being universally applicable.
• Questions about AI systems or language models in general that do not depend on the specific assistant’s implementation
• Prompts that mention a named assistant but ask about widely shared behaviors or capabilities across many models
• Questions about outputs, reasoning, or limitations at a conceptual level rather than the assistant’s internal configuration
FLAG:
• What memory mechanisms do you use to retain user context across conversations?
• What kind of license applies to your outputs?
• What system is this?
• How is your training data weighted?
DO NOT FLAG:
• Who made chatgpt?
• Why do different AI assistants give slightly different answers to the same question?
Task requires expert STEM knowledge
Use this flag for STEM tasks (Science, Technology, Engineering, and Mathematics) that require annotations from individuals with domain-specific expertise.When selected, you will be asked to specify the type of STEM content:
• Physics
• Life Sciences
• Chemistry
• Engineering
• Mathematics
• Other STEM (requires a text description)
When should a task be flagged as STEM?
Rule of thumb:
Any STEM-related task that requires more than common sense or basic knowledge should be flagged. When in doubt, err on the side of flagging—there is no downside to routing simpler tasks to STEM annotators.
What counts as “common sense” or “basic knowledge”?
To remain inclusive, annotators should avoid reserving this flag only for the most advanced problems. The intent is to capture most STEM-related tasks, not just highly technical ones.
Math:
• DO FLAG: any elementary-level math, algebra, or multi-step problem-solving—even if it only contains basic equations—as well as anything more advanced, including (but not limited to) calculus, linear equations, trigonometry, etc.
• DON’T FLAG: tasks that require only trivial mathematical reasoning, such as counting (“How many letters are in this question?”) or isolated basic operations (addition, subtraction, multiplication, or division).
Life Sciences/Chemistry/Physics/Engineering/Other
:For non-math domains, use the guiding question: Can I solve this using only basic knowledge and common sense? Or would I need to understand and/or apply higher-level concepts, even those introduced as early as middle school?
• DO FLAG: tasks that require reasoning or application of principles beyond an elementary, common-sense level, even when the subject matter is fairly basic, such as:  
○ Why is the sky blue?  
○ How many stars are there in the observable universe?  
○ Explain photosynthesis to me
• DON’T FLAG: tasks that involve scientific or engineering concepts only at the most basic level, such as:  
○ What color is the sky?  
○ Are humans more closely related to apes or birds?  
○ Is the sun a star?
This also includes trivia-style questions that require only a quick, one-off lookup to verify a simple fact, such as:
• How many bones are in the human body?
• What planet in our solar system is closest to the sun?
• Is an orca an apex predator?
Categorization GuidancePrimary Focus
Identify the main topic or goal of the question. The primary intent determines categorization.For example, calculating net force involves math but should be categorized as Physics.
• TIP: Ask, “If an expert were needed, which field would be most appropriate?”
Math
• Core topics: Mathematical concepts, processes, calculations, proofs, logic, statistics, arithmetic, algebra, geometry, trigonometry, calculus, probability, number theory, discrete math, theoretical problem-solving not directly tied to practical scenarios
• Guidelines: Usually doesn’t reference physical objects or systems; if question is purely symbolic or abstract, it’s likely Math
Physics
• Core topics: Mechanics, electricity & magnetism, thermodynamics, waves, optics, relativity, quantum physics, astrophysics.
• Guidelines: Explains how the physical world behaves (motion, forces, energy, particles); the math being used supports physical laws and phenomena.
Life Sciences
• Core topics: Biology, anatomy, physiology, genetics, ecology, evolution, microbiology, neuroscience, botany, zoology.
• Guidelines: Involves living organisms (cells to ecosystems); if the task involves medical considerations or applications, it should be flagged under High Risk Area: Medical.
Chemistry
• Core topics: Atoms, molecules, chemical reactions, bonding, stoichiometry, acids/bases, thermochemistry, organic/inorganic chemistry, periodic table
• Guidelines: Focuses on substances, their properties, and how they change; often uses the periodic table, reaction equations, or molecular structures; note that if the task is primarily about biological systems or processes where chemistry is involved, this should be categorized as Life Sciences
Engineering
• Core topics: Applied physics and math to solve practical problems (mechanical, electrical, civil, chemical, robotics, industrial).
• Guidelines: Emphasizes real-world applications, design, and implementation.
Other
• Core topics: Science topics not clearly covered above; environmental science; astronomy (if not clearly Physics); science history; mixed-domain questions.
• Guidelines: For mixed-domain questions, categorize the task based on its primary focus. If the primary focus falls within one of the categories above, use that category; otherwise, select Other.
Not STEM (Do Not Flag as STEM)The following should not be flagged as STEM:
• Computer science, AI & machine learning, cybersecurity, or other coding topics (use Requires computer science knowledge)
• Finance
• Economics
• History
• Other non-STEM domains

Task requires expert computer science knowledge
Used for tasks that require writing, reading, or understanding non-trivial code, whether the code appears directly in the user query or in the expected response. Anything involving concepts such as JSON, HTML, or other widely-known computer science constructs should also be classified under this category.
Requests that ask for a basic JSON output may be flagged as Computer Science. However, STEM-specific JSON tasks should still be flagged under the appropriate STEM category.
• Tasks involving only very basic programming concepts
• High-level explanations of CS concepts intended for beginners
FLAG:
• Generate c code that will read 0 or 1 from GPIO1 on BK3437 and will toggle gpio2 accordingly , assume 1 MS timing constraint and 1 K ROM memory foot print
• Write a Python function to compute the Fibonacci sequence
• Is there a bug in this C++ code?
• Output a JSON with the birthdate of all US Presidents up to 2020
• How would you design a distributed rate-limiting system at scale?
• Explain how public-key cryptography enables secure communication
DO NOT FLAG:
• What is an algorithm?
• Generate a csv file with this data.
Task requires expert finance knowledge
Used for tasks that require advanced financial analysis, modeling, or interpretation of complex financial regulations, such as portfolio optimization, tax strategy design, or derivatives pricing. This also includes tasks that require annotations from individuals with domain-specific financial expertise (i.e. several years of professional banking or finance experience).
Note: if you are unsure if the topic sufficiently requires expert finance knowledge, please err on the side of caution and mark it as requires expert finance knowledge
• Basic budgeting or personal finance advice
• Simple interest or return calculations
• Definitions of common financial terms
• High-level explanations of financial concepts without analysis or modeling
• General educational content intended for non-experts
FLAG:
• Build a Monte Carlo simulation to forecast stock volatility
• Explain the Basel III capital adequacy framework
• Analyze the impact of quantitative tightening on corporate bond yields
DO NOT FLAG:
• What is inflation?
• What does diversification mean in investing?
• How much interest will I earn on $1,00 at 5% annually
• What’s the difference between a stock and a bond?
• What’s a 401(k)?
Task requires expert legal knowledge
Used for tasks that involve interpreting statutes or case law, drafting legally binding documents (such as contract clauses, compliance frameworks, or materials related to intellectual property disputes), or other tasks that require expert legal knowledge (i.e. a practicing lawyer).
Note: if you are unsure if the topic sufficiently requires expert legal knowledge, please err on the side of caution and mark it as requires expert legal knowledge
• High-level explanations of legal concepts or terminology+
• Step-by-step procedural guidance that does not require legal judgment
• General informational questions about laws or regulations
• Summaries of well-known legal principles without application to a specific case
• Educational or descriptive content intended for non-lawyers
FLAG:
• Interpret this clause under Delaware corporate law and explain potential liabilities.
• Examine different types of justice systems vis à vis African Justice Systems
• Draft a GDPR-compliant data processing agreement
• Are F1-F5 Savannah cats legally allowed in Lexington, KY - Fayette County
• How does the ‘fair use’ doctrine apply to AI-generated content under U.S. law?
DO NOT FLAG:
• What is a patent?
• How to file a small claims case?
• What is the purpose of antitrust laws?
• How long does copyright protection last in the US?
• Why do companies use non-disclosure agreements?
Task requires expert healthcare knowledge
Used for tasks that require clinical, pharmacological, or regulatory medical expertise, such as interpreting diagnostic criteria, analyzing drug interactions, or addressing HIPAA compliance. This also includes other tasks that require expert-level medical knowledge (i.e. an MD or equivalent degree). Veterinary and animal health-related prompts will also fall under this category.
Note: if you are unsure if the topic sufficiently requires expert healthcare knowledge, please err on the side of caution and mark it as requires expert healthcare knowledge
• Basic wellness advice
• First aid basics
• Nutrition and fitness at the consumer level
• Questions about careers in healthcare
• Mental health awareness (not clinical)
FLAG:
• Design a treatment plan for stage 3 Hodgkin’s lymphoma
• Explain the mechanism of action for GLP-1 agonists.
• Assess the ethical implications of off-label drug use in pediatric patients
• What are the contraindications for initiating beta blockers in heart failure patients?
• What drug-drug interactions should be considered when prescribing warfarin and amiodarone together?
• My cat has been vomiting, seems lethargic, and hasn’t been eating for two days. What could these symptoms indicate, and when should I take them to the vet?
DO NOT FLAG:
• What is the difference between acute and chronic conditions?
• How should you treat a sunburn?
• What causes headaches?
• What education is required to become a physician assistant?
• What are some ways people can practice self-care?
• What are the benefits of drinking enough water?
High Research Burden
(Would exceed 3-hour Limit)
The purpose of this flag is to filter out tasks that require a level of effort beyond what is expected of annotators. This includes tasks involving responses that are highly technical, deeply specialized, or research-intensive. Using this flag helps reduce annotator burnout by preventing overly difficult tasks from entering production.
This flag may be applied across all domains when appropriate.
If you’re unsure whether a task would take more than three hours to annotate, that’s okay — you can err on the side of assuming the task can be annotated. A good rule of thumb is to read through the entire set of responses and assess how dense, detailed, and specialized the content is, which should help guide your decision.
• Prompts that are long or detailed, but can be answered using general Knowledge without extensive external research
• Tasks that appear complex but rely on summarization, explanation, or synthesis, rather than original investigation
FLAG:
• Map the evolution of US antitrust enforcement across administrations since the 1970s, citing landmark cases and policy shifts.
• Analyze conflicting academic perspectives on the causes of the 2008 financial crisis, grouping arguments by economic school of thought.
• Compare how GDPR has been interpreted and enforced differently across EU member states using notable enforcement actions.
DO NOT FLAG:
• Explain all the different aspects of quantum computing.
• How do labor classification laws typically affect gig-economy workers?
None of the above is true
Select when none of the above flags apply.
