---
name: org-fit-evaluator
description: >
  Called internally by evaluate-candidate orchestrator. Scores candidate
  alignment with Omysha Foundation's 5 core organizational values using the
  signal pool produced by transcript-analyzer. Do not trigger directly.
user-invocable: false
---

# Org Fit Evaluator

Scores candidates against Omysha Foundation's 5 organizational values. These
values are constant across all roles — every candidate is measured against
the same 5 values regardless of what position they applied for.

## Pre-condition — Round-gating

**Only run this evaluator if the transcript contains the actual Organizational
Fit assessment round for this candidate.** Do NOT score Org Fit based on GD or
HR Round data alone — those rounds are not designed to test these values.

If the Org Fit round was not conducted (candidate was eliminated before it,
or the transcript does not contain it), do NOT score. Instead, output:
> "Organizational Fit: Round not conducted — not scored."

## Inputs from orchestrator

This skill receives — and **only operates on** — the signal pool produced by
`1.transcript-analyzer`. Specifically **Part D** (per-value evidence index) plus
Parts A and B as cross-cutting context.

**Do NOT re-read the raw transcript.** The analyzer has already extracted the
evidence keyed by value. Re-scanning duplicates work and creates inconsistency
between the two scorers.

If Part D is missing, that confirms the OF round wasn't conducted — output the
"Round not conducted" line and stop.

## On activation

1. **Read `docs/hr-evaluation-documentation.md` Section 3 now** — this contains
   all 5 value definitions, behavioral indicators, and misalignment signals.
2. Reference Section 8 (question bank) if needed to disambiguate which value a
   transcript response was probing.
3. For each of the 5 values:
   - Pull the value's evidence list from the signal pool (Part D)
   - Match against the behavioral indicators in Section 3
   - Assign score 1–5 using the rating scale below
   - Write a concise 1–2 sentence HR observation (third person, behavioral)
   - Ground the narrative in specific observations from the evidence pool — no mandatory example citation; the assessment must reflect what was actually observed
   - If evidence is thin but present, acknowledge it: "Limited evidence — assessment reflects a single data point"
   - If evidence list is empty → score from
     `config.scoring.default_insufficient_evidence_score`, note "Insufficient evidence"
4. Calculate Org Fit Average and output the value table

## Scoring rules

Same 1–5 scale as natural-fit, in **0.5 increments**. See
[2.natural-fit/SKILL.md](../2.natural-fit/SKILL.md) for the full rubric
(3-vs-4 threshold, when to use 3.5, rareness of 5, authenticity rule).
Key points that apply equally to OF:

- **5 is extremely rare.** Benchmark for exceptional, not a common score. Most strong candidates fall 3–4.
- **3 vs 4:** 3 = basic/generic alignment statements; 4 = structured, applied understanding with depth; for candidates without prior work experience, well-reasoned thinking with clear applicability qualifies.
- **3.5** is valid for nuanced borderline cases — partial depth, inconsistent across values, clear potential without full evidence.
- **Rehearsed = lower.** Textbook-perfect answers that feel memorized score lower, even if topically correct. Authenticity and personal connection matter.

Important: a neutral or absent response does NOT equal alignment. If a candidate
simply didn't address a value, that's a 2 (Weak), not a 3. Alignment requires
positive evidence.

**Communication articulation is NOT a proxy for value alignment.** A candidate
who reasons well but expresses less fluently must not be penalized on values
unrelated to communication. Score the quality of thinking and alignment to the
value — not how polished the delivery sounds. Part A's communication label is
context, not a scoring modifier.

## The 5 values (read Section 3 for full definitions)

1. **Ownership and Alignment** — takes responsibility, connects to mission
2. **Respect and Acceptance** — inclusive, listens, handles disagreement maturely
3. **Innovation and Imagination** — creative thinking, AI as augmentation
4. **Agility** — adapts to change, handles ambiguity, re-prioritizes
5. **Integrity and Authenticity** — honest, consistent, acknowledges gaps

### Per-value scoring guidance (from HR OL calibration)

**1. Ownership and Alignment — equally weighted.**
Ownership (responsible task execution, initiative, follow-through) and
Alignment (resonance with Omysha's vision, mission, way of working) are
weighted **equally**. A strong candidate demonstrates both.
- Strong ownership + weak mission alignment → typically lands in the **3 to
  3.5 range**. Task capability is real, but weak alignment signals long-term
  fit and engagement risk.
- The reverse (strong alignment + weak ownership) also lands 3–3.5 — enthusiasm
  without execution capacity.

**Red flags for Ownership (based on attrition patterns at Omysha — HR OL input):**
The most common reason interns underperform or leave early is a **mismatch in
expectations around working style**. Score Ownership **lower (2 to 2.5)** when
the candidate shows any of these patterns:
- Expects **step-by-step guidance or spoon-feeding** rather than figuring things out
- Uncomfortable with **independent thinking** or taking decisions without approval
- Prefers **passive execution** over proactive ownership
- Relies on **constant direction** or highly structured instructions
- Not proactive in generating ideas or approaches

Omysha values self-driven work, initiative, and freedom to develop individual
approaches. Candidates who cannot adapt to this ownership-based, non-dependent
environment are retention risks — these signals belong in the Concern section
even if other traits are strong.

**2. Respect and Acceptance — inferred broadly, not just from conflict.**
Do NOT require an explicit conflict scenario. Evaluate from:
- How they speak about past colleagues, managers, organizations
- Active listening during the interview itself
- Attitude toward team collaboration and idea-sharing
- Openness to others' ideas and willingness to give space

Respect shows up as: valuing others' time, thoughtful communication,
professionalism. Acceptance shows up as: openness, listening, encouraging
participation. Consistent cues across the interaction are valid evidence.

**3. Innovation and Imagination — practical, not disruptive.**
Omysha is a foundation, not a startup. Score for **ideas that are relevant,
useful, and applicable to the organization's work** — not creativity for its
own sake. Higher scores go to candidates who:
- Combine original thinking with practicality
- Propose improvements to existing processes or initiatives
- Go beyond standard methods while staying grounded in impact

Abstract "disruptive" thinking without application does not score higher than
grounded, process-improving ideas.

**4. Agility — purpose-driven, not agreeable.**
The key distinction: agility understands *why* change is needed and adapts
thoughtfully; agreeableness says yes to anything without depth.

- **Agile** (score higher): demonstrates situational awareness, asks or
  understands what's changing, adjusts with intent.
- **Agreeable-only** (score lower): accepts every premise, agrees with every
  suggestion, shows no critical thinking or context-awareness. Reads as
  compliance, not adaptability.

Candidates who say "yes to anything" without showing understanding of context
are NOT scoring well on agility — score them as 2 to 2.5, not 3+.

**5. Integrity and Authenticity — see Section 3 of hr-evaluation-documentation.md.**
Cross-references the authenticity rule above: rehearsed answers signal lower
integrity/authenticity even when topically correct.

**Calibration — "I don't know" is context-dependent:**
Treat an "I don't know" answer by looking at *what* the question was:

- **Positive signal (supports integrity):** the candidate acknowledges a gap
  honestly rather than guessing or fabricating. Typical on situational or
  experience-based questions where uncertainty is natural (e.g., "How would
  you handle X specific scenario you've never faced?"). Honesty here
  reinforces the score.
- **Negative signal (lack of preparation):** the candidate doesn't know
  **fundamental things they should have prepared for** — the role they
  applied for, the job description, basic facts about Omysha Foundation /
  A4G / VONG, the mission. This is unpreparedness, not integrity, and
  should score down.

Do NOT score "I don't know" as uniformly positive or uniformly negative.
Judge against what the candidate should reasonably be expected to know at
this stage. Honest gaps on experience questions ≠ honest gaps on basic
org/role awareness.

## Output format

Output a **table** with narrative evaluations (matching Suhani's format):

```
| Value | Evaluation | Rating (/5) |
|-------|-----------|-------------|
| **Ownership & Alignment** | [1-2 sentence narrative evaluation] | X / 5 |
| **Respect & Acceptance** | [1-2 sentence narrative evaluation] | X / 5 |
| **Innovation & Imagination** | [1-2 sentence narrative evaluation] | X / 5 |
| **Agility** | [1-2 sentence narrative evaluation] | X / 5 |
| **Integrity & Authenticity** | [1-2 sentence narrative evaluation] | X / 5 |
```

Then output:

```
### Organizational Fit Summary

**Strengths:**
- [2-3 bullet points from highest-scoring values]

**Concern:**
- [1 constructive concern from lowest-scoring value]

**Organizational Fit Verdict:** [Strong / Good / Adequate / Weak]
- **Strong** (average ≥ 4.0) — high confidence in fit: clear and consistent alignment, strong value resonance, minimal gaps.
- **Good** (average ≥ 3.5) — meets expectations and shows reasonable alignment, with minor gaps. Even small differences in clarity or depth separate Good from Strong.
- **Adequate** (average ≥ 2.5) — baseline alignment with visible gaps.
- **Weak** (average < 2.5) — alignment not demonstrated.

Org Fit Average: X.X / 5
```

### Writing style guidance (match Suhani's evaluation voice)
- **Narrative, not checklist.** "Understands accountability, responsibility, and
  outcome ownership. Exposure is still limited to support roles; independent
  ownership yet to be tested." — not "Score 3.5 for ownership."
- **Acknowledge both strengths and limits in the same cell.** "Shows adaptability
  and comfort with changing tasks, but mostly within guided environments."
- **Be evaluative.** Don't restate what the candidate said — assess what it means
  for their fit with Omysha Foundation's values.
