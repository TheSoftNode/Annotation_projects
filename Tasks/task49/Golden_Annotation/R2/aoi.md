# ⚠️ Response 2 Areas of Improvement

## AOI #1 - SUBSTANTIAL

**Response Excerpt:**

```
❌ **NO** multiple stories, subtasks, or epics
❌ **NO** technical implementation specifics
❌ **NO** vague AC like "System shall be user-friendly"
✅ **ALWAYS** prioritize *user value* over technical ease
⚠️ **Critical**: If the LLM violates *any* rule...
```

**Description:** The response uses an excessive number of emojis throughout the documentation, which reduces professionalism and is inappropriate for technical or engineering-focused communication.

**Severity:** Substantial

---

## AOI #2 - SUBSTANTIAL

**Response Excerpt:**

```
**Technical Notes**: [2-3 bullet points max; high-level tech considerations ONLY – no implementation details]
```

Combined with the example:

```
* Frontend: Add Google Sign-In button using Identity Services SDK
* Backend: Verify ID tokens via Google API; establish encrypted sessions
```

**Description:** The response contains an internal contradiction by instructing to provide "no implementation details" in the technical notes while simultaneously including SDK and API references in the example, which are implementation details.

**Severity:** Substantial

---

## AOI #3 - SUBSTANTIAL

**Response Excerpt:**

```
**1. Title** `As a [user type], I want to [action] so that [benefit]`
*Constraints*: Under 10 words; action-oriented; user-value focused
```

**Description:** The response removes the flexibility allowed in the original instructions by mandating only the "As a..." format and omitting the action-oriented title option, which contradicts the user's specification that both formats are acceptable.

**Severity:** Substantial

---

## AOI #4 - SUBSTANTIAL

**Response Excerpt:**

```
⚠️ **Critical**: If the LLM violates *any* rule (e.g., adds multiple stories, estimates >13 pts, omits AC edge cases), **reject the output and retry** with this prompt. Consistency requires strict adherence.
```

**Description:** The response includes operational guidance about how a user should handle incorrect outputs, which is outside the scope of generating an LLM prompt and adds unnecessary meta-instructions.

**Severity:** Substantial

---

## AOI #5 - SUBSTANTIAL

**Response Excerpt:**

```
*Constraints*: Under 10 words; action-oriented; user-value focused
```

**Description:** The response converts a flexible guideline into a strict rule by mandating that the title be under 10 words, whereas the original instruction specified "under 10 words when possible", which can lead to awkward phrasing or unnecessary constraint failures.

**Severity:** Substantial

---

## AOI #6 - SUBSTANTIAL

**Response Excerpt:**

```
✅ **ALWAYS** estimate ≤13 points; if >13, respond: *"❌ ERROR: Story too large—break it into sub-tasks."*
```

**Description:** The response presents the 13-point cap as a universal Agile or Jira standard when it is a custom prompt rule with no authoritative basis in standard Agile methodologies.

**Severity:** Substantial

**Verification of Issue:**

**Tool Type:** Research Documentation

**Source URL:** https://www.atlassian.com/agile/project-management/estimation

**Source Excerpt:**
```
Story points reward team members for solving problems based on difficulty, not time spent. This keeps team members focused on shipping value, not spending time.
```

The Atlassian documentation on Agile estimation discusses Fibonacci sequences and story points but does not establish 13 as a mandatory ceiling or auto-rejection threshold.

---

## AOI #7 - SUBSTANTIAL

**Response Excerpt:**

```
**Why this prompt works:** (...) **Matches your examples exactly** in structure, tone, and labeling conventions
```

**Description:** The response inaccurately claims to match the provided examples exactly when the structure differs in multiple ways, including using numbered headers instead of bold headers, adding rules not present in the examples such as "3-5 criteria minimum" and "under 10 words", and expanding domain labels to include monitoring and analytics which were not in the original examples.

**Severity:** Substantial

---

## AOI #8 - SUBSTANTIAL

**Response Excerpt:**

```
✅ **ALWAYS** include cross-functional requirements (security/perf/access) in AC
```

**Description:** The response presents cross-functional requirements as mandatory in all acceptance criteria when this is a best practice recommendation rather than a universal requirement in Agile methodologies.

**Severity:** Substantial

**Verification of Issue:**

**Tool Type:** Research Documentation

**Source URL:** https://www.atlassian.com/agile/project-management/user-stories

**Source Excerpt:**
```
Acceptance criteria can include non-functional requirements such as security or performance, when relevant to the story.
```

The Atlassian documentation indicates that non-functional requirements "can" be included when relevant, not that they must "ALWAYS" be included in every acceptance criteria.
