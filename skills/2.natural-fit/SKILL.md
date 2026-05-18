---
name: natural-fit
description: >
  Called internally by evaluate-candidate orchestrator. Role-aware Natural Fit
  scorer — loads role-specific reference file and scores 5 traits using the
  signal pool produced by transcript-analyzer. Do not trigger directly.
user-invocable: false
---

# Natural Fit

Scores candidates against 5 role-specific Natural Fit traits. Loads the correct
role reference file dynamically based on the applied role.

## Pre-condition — Round-gating

**Only run this scorer if the transcript contains the actual Natural Fit
assessment round for this candidate.** Do NOT score Natural Fit based on GD or
HR Round data alone — those rounds are not designed to test these traits.

If the Natural Fit round was not conducted (candidate was eliminated before it,
or the transcript does not contain it), do NOT score. Instead, output:
> "Natural Fit: Round not conducted — not scored."

## Inputs from orchestrator

This skill receives — and **only operates on** — what the orchestrator passes:

1. **Role name** and **reference path** (e.g. `references/natural-fit-hr.md`)
2. **Signal pool** from `1.transcript-analyzer` — already-extracted behavioral
   evidence indexed by NF trait name. The signal pool contains:
   - Per-trait evidence list (transcript snippets paraphrased as observations)
   - Per-trait signal strength label (Strong / Moderate / Weak / Poor / Absent)
   - Cross-cutting communication, confidence, and attitude signals
   - Transcript quality note (Full / Partial / Summary / Low confidence)

**Do NOT re-read the raw transcript.** The transcript-analyzer has already
extracted everything you need. Re-scanning is duplicate work and a source of
inconsistency between sub-skills.

If the signal pool is missing a trait's evidence entirely, that means the
analyzer found nothing — treat it as "Insufficient evidence" (Level 0
auto-resolve, score = `config.scoring.default_insufficient_evidence_score`).

## On activation

1. **Read the role reference file:** `references/natural-fit-[role].md`.
   This contains the 5 trait definitions with Score 5/3/1 indicators.
2. For each of the 5 traits:
   - Pull the trait's evidence list from the signal pool
   - Match the evidence against the Score 5/3/1 indicators in the reference
   - Assign score 1–5
   - Write a concise 1–2 sentence HR observation (third person, behavioral language)
   - Ground your narrative in specific observations from the evidence pool — no mandatory example citation; the assessment must reflect what was actually observed, not generic statements
   - If evidence list is empty → score from config default, note "Insufficient evidence"
3. Calculate Natural Fit Average and output the trait block

## Scoring rules

Scale is 1–5 in **0.5 increments** (1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5).

| Score | Label | When to assign |
|-------|-------|---------------|
| 5 | Exceptional | Out-of-the-box response, depth beyond standard answers, originality and real-life application, and clearly stands out from peers. **Extremely rare** — treat as a benchmark for exceptional performance; most strong candidates land 3–4. |
| 4 | Good | Structured, applied understanding with visible reasoning depth. For candidates without prior work experience, well-reasoned thinking with clear applicability qualifies — a prior work example is not required. |
| 3 | Adequate | Basic or partially correct answer. Shows some understanding but lacks depth, structure, or strong examples. Generic rather than applied. |
| 2 | Weak | Minimal or indirect evidence — also use for insufficient data. |
| 1 | Poor | No meaningful evidence, or signal actively contradicts the trait. |

### The 3 vs 4 threshold

The shift from 3 to 4 is **from generic statements to structured thinking and
applied understanding**. Example (conflict-handling prompt):

- **3-level:** "I would listen to both sides and try to solve the issue." — correct but surface-level and generic.
- **4-level:** "I would first listen to both sides individually, understand the root cause, then facilitate a discussion to reach a mutually acceptable solution" — ideally backed by a real example.

### When to use 3.5 (or any half-score)

Use half-scores for **nuanced borderline performance** — the candidate doesn't
fully meet the higher score's criteria but is clearly better than the lower one.
Typical triggers for 3.5:

- Partial depth, but lacks consistency
- Some answers strong, others average
- Clear potential but not enough evidence for a full 4

Do not force rounding. A 3.5 captures nuance that a forced 3 or 4 would lose.

### Authenticity rule — rehearsed answers score lower

A textbook-perfect answer that **feels rehearsed or scripted** is NOT scored
highly, even if technically correct. The Natural Fit round is designed to
assess whether qualities come genuinely from the candidate. Score lower when
answers lack:

- Personal insights or lived experience
- Original framing or stage-appropriate reasoning
- Natural alignment with the role (rather than memorized phrasing)

A correct-but-rehearsed answer typically lands at 3 or 3.5 at most, not 4+.

The reason scores should be evidence-grounded is that these reports inform real
hiring decisions. An inflated score could lead to a bad hire; a deflated score
could unfairly screen out a good candidate. Rate what you observe, not what you
hope or assume.

### Communication articulation is NOT a scoring proxy for other traits

A candidate who thinks well but expresses less fluently must not be penalized
on traits that are not about communication (e.g., Problem Solving, Ownership,
Discretion, Culture-setting). Communication quality is already captured as a
separate cross-cutting signal in Part A of the signal pool.

Specifically:
- Score the **quality of thinking and alignment to the trait** — not how
  polished the delivery sounds
- A plainly-worded answer with genuine depth scores the same as a fluent
  answer with equivalent depth
- Part A's "Communication: Weak" label does NOT lower scores on non-communication traits
- Apply articulation judgment only where verbal clarity is the actual measure

### Thin-evidence acknowledgment

When evidence is present but sparse (e.g., one partial signal), do not force
precision. In the narrative, acknowledge the limited evidence: "Limited evidence
observed — assessment reflects a single data point." Use half-scores (e.g., 2.5,
3.5) to signal uncertainty rather than rounding to a false whole number. If
evidence is entirely absent, use the config default and note "Insufficient evidence."

### Experience level does NOT shift the bar

First-time interns are scored against the **same scoring standards** as
candidates with prior experience. Do NOT:
- Inflate scores because "they're new and doing well for a first internship"
- Deflate scores because "they lack prior experience"

Instead, evaluate on:
- **Natural Fit alignment** — do the traits show up regardless of setting?
- **Thinking ability and approach** — how they reason, not how seasoned they sound
- **Clarity and intent** — what they demonstrate on the call today

A first-timer who shows strong NF alignment through academic or personal
examples can legitimately score 4 or 4.5 on a trait. An experienced candidate
who coasts on past titles without demonstrating the trait gets the same 3 a
first-timer would. Experience is context, not a scoring modifier.

## Role reference files

| Role | File |
|------|------|
| HR | `references/natural-fit-hr.md` |
| Marketing | `references/natural-fit-marketing.md` |
| Community | `references/natural-fit-community.md` |
| Product Management | `references/natural-fit-product.md` |
| Project Management | `references/natural-fit-project.md` |
| RAB | `references/natural-fit-rab.md` |
| General / Unknown | `references/natural-fit-general.md` |

## Output format

For each of the 5 traits, output a **narrative block** (not a table row):

```
### [Trait Name]
[1–2 sentence concise narrative. Evaluate depth of thinking and alignment to the trait.
Write in third person. No mandatory example citation — ground judgment in specific
observations from the evidence pool. When evidence is thin, acknowledge it.]

**Signal:** [One-sentence takeaway — the single most important behavioral observation for this trait.]

**Rating: X / 5**

---
```

After all 5 traits, output:

```
### Natural Fit Summary — [Role Name]

**Key Strengths:**
- [2 bullet points drawn from highest-scoring traits — specific, not generic]

**Possible Concern:**
- [1 constructive concern drawn from lowest-scoring trait]

### What belongs in "Possible Concern"

This section flags areas where the candidate does **not fully align** with
required natural traits for the role. Appropriate content includes:

- **Weak or inconsistent alignment** with key NF traits for the role
- **Borderline performance** on certain traits (e.g., 3.0 where role needs 3.5+)
- Traits with clear **scope for improvement**
- Softer concerns: candidate may need **additional guidance or support**, or
  certain traits are **not strongly demonstrated yet**

Focus on **potential risks to performance or fit**, even when they aren't
immediate disqualifiers. This is NOT a rejection section — it's a constructive
flag for HR OL to consider. Keep language honest but non-judgmental.

**Natural Fit Verdict:** [Strong / Good / Adequate / Weak]
- **Strong** (average ≥ 4.0) — high confidence in fit: clear and consistent alignment, strong understanding of the role, minimal gaps across traits.
- **Good** (average ≥ 3.5) — meets expectations and shows reasonable alignment, but with minor gaps or areas of improvement. Even small differences in response clarity or depth separate Good from Strong.
- **Adequate** (average ≥ 2.5) — baseline fit with visible gaps.
- **Weak** (average < 2.5) — fit not demonstrated.

Natural Fit Average: X.X / 5
Role reference used: [filename]
```

### Writing style guidance (match Suhani's evaluation voice)
- **Be specific, not generic.** "Comfortable breaking work into smaller parts and
  coordinating tasks within teams" — not "Shows good organizational skills."
- **Acknowledge stage.** "Exposure is still limited to support roles; independent
  ownership yet to be tested" — honest about where the candidate is.
- **Signal line is the headline.** It should be the single most important behavioral
  takeaway for that trait. Think of it as what you'd tell Nitin Sir in one sentence.
- **Evaluate, don't summarize.** "Responsive to urgency but largely driven by
  external direction rather than independent judgment" — this is an evaluation.
  "Discussed prioritization in the interview" — this is a summary. Only do the former.
