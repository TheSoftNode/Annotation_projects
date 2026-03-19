Phase 2A: Task Flagging
Task Flagging Roles

Annotators
QCers (Reviewers)
Auditors
Responsibilities
Annotators review the contents of each task (which consists of a conversation between a user and an LLM chatbot) and identify the appropriate category for the task, along with a brief rationale explaining their selection.
Quality Checkers (QCers) review annotators’ work by confirming or disputing their category selections and making the final determination of the appropriate task category in the finalized annotation.
Auditors review approximately 20% of the total task flagging work, focusing on evaluating the QCers’ finalized annotations, including both the selected task category and the rationale provided.

Introduction
Task Flagging is the first step in Phase 2 and focuses on categorizing the nature of a task, rather than evaluating the quality of model responses. In this stage, you review each task and select the appropriate flags that describe its requirements and characteristics—for example, whether it requires domain expertise (e.g., STEM, legal, healthcare), involves recent information, may elicit unsafe content, or has other special constraints. These flags determine how tasks are routed into the appropriate workstreams for downstream RLHF annotation.
Flagging Workflow (Replication + QC)
Each task is independently flagged by two flaggers, after which a QCer (reviewer) reviews both submissions and records the final task flags. This additional review layer helps ensure accuracy and consistency before tasks proceed to the RLHF annotation stage.
