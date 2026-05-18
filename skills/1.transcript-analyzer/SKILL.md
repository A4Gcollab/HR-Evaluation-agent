---
name: transcript-analyzer
description: >
  Called internally by evaluate-candidate orchestrator. Reads the transcript
  ONCE and extracts a structured signal pool that the natural-fit and
  org-fit-evaluator scorers consume. Do not trigger directly.
user-invocable: false
---

# Transcript Analyzer

This is the **single read pass** over the transcript. The two scorers
(`2.natural-fit`, `3.org-fit-evaluator`) operate on the structured output of
this skill and never re-read the raw transcript themselves.

The job is to **extract and label** — never to score, rate, or recommend.

---

## Inputs from orchestrator

- Full transcript for one candidate
- The role being evaluated (so the per-trait evidence index can be keyed to the
  correct trait names — read `2.natural-fit/references/natural-fit-[role].md`
  for the trait list)
- Whether an OF round is present in the transcript (so the per-value evidence
  index can be skipped when not applicable)

---

## Output — the Signal Pool

A single structured artifact with four parts. The orchestrator passes this
forward to the scorers verbatim.

### Part A — Cross-cutting behavioral signals

Used as context by both scorers. Not directly scored.

| Category | Label | Evidence |
|----------|-------|----------|
| Communication | Strong / Moderate / Weak / Poor | 2–3 sentences |
| Confidence and Engagement | Strong / Moderate / Weak / Poor | 2–3 sentences |
| Organizational Awareness | Strong / Moderate / Weak / Poor | 2–3 sentences |
| Behavioral and Attitude | Strong / Moderate / Weak / Poor | 2–3 sentences |

#### Handling nervous candidates (communication + confidence labeling)

Interviewers try to settle nervous candidates before evaluation, so the transcript
usually reflects a candidate who has been given a fair chance to express themselves.
When labeling Communication and Confidence:

- **Minor nervousness** (a slow start, one or two stumbles, recovers) → do not
  downgrade. Label per the candidate's settled-state performance.
- **Significant lack of confidence that persists across the interview** (excessive
  hesitation, inability to complete professional-level answers, loss of coherence)
  → this is a valid signal to label down to `Weak` or `Poor`. Confidence in
  communicating is considered important for functioning effectively at the org.

Flag which bucket this is in the evidence sentences so scorers can interpret
correctly.

### Part B — HR Round parameter extractions

Feeds directly into the report's HR Round Evaluation table. Only include
parameters the candidate actually discussed.

| Parameter | Observation | Assessment |
|-----------|-------------|------------|
| **Availability** | Specific times, constraints, college schedule | Fit with role requirements |
| **Stability** | Other commitments, academic schedule, transition plans | Risk assessment |
| **Past Stipend** | Previous compensation, expectations | Career stage and motivation signal |
| **Motivation** | Why this internship, what drives them | Alignment with role and org |
| **Expectations** | What they hope to gain | Whether it matches what org offers |
| **Career Goals** | Stated career direction | Alignment with role trajectory |
| **Org Alignment** | Understanding of Omysha Foundation, A4G, VONG | Depth and authenticity |

Extract observations AND assessments. Do NOT label with rejection codes
(H1–H5, S1–S7) — rejection screening is handled by `/justify-rejection`.

#### Priority parameters (HR OL calibration)

These three parameters have the **greatest influence on the final decision** and
must be extracted in full depth whenever they appear in the transcript. If any
of the three are missing from the HR Round, note the gap explicitly:

1. **Availability & Schedule Alignment** — college timings, daily schedule,
   ability to meet required working hours for the role
2. **Commitment & Stability** — can the candidate consistently stay engaged
   for the **required 6-month duration**
3. **Motivation & Intent to Join** — genuine interest in the role and
   organization; clarity on *why* they want to join

Other parameters (Past Stipend, Expectations, Career Goals, Org Alignment) are
important supporting context but secondary to the three above. Extract them
when present; do not over-invest effort when the priority three are weakly
covered.

#### Multi-application / other placement mentions

When the candidate mentions **applying elsewhere, having other offers, or
being in other placement pipelines**, capture this in the **Stability** row
of Part B (not as a separate rejection flag — rejection screening happens in
`/justify-rejection`). Note both:
- The factual observation (e.g., "mentioned ongoing placements at two other organizations")
- Whether the candidate also expressed **clear intent to commit to Omysha if selected** — this is the key differentiator

This is a **cautious signal**, not an automatic negative. Exploring multiple
options is normal. The risk flag only fires when commitment/intent is unclear.

### Part C — Per-trait evidence index (NF)

For each of the 5 traits in the loaded role reference, list the relevant
behavioral observations from the transcript. This is what `2.natural-fit`
will consume to assign scores.

```
trait_name: <name from role reference>
signal_strength: Strong | Moderate | Weak | Poor | Absent
evidence:
  - <paraphrased behavioral observation 1>
  - <paraphrased behavioral observation 2>
  - ...
ambiguity_notes: <if any signal is contradictory or unclear>
```

If a trait has no supporting evidence in the transcript, output the trait
with `signal_strength: Absent` and `evidence: []`. Do not invent evidence.
Do not extrapolate from GD or HR Round signals — those rounds do not test
the NF traits.

### Part D — Per-value evidence index (OF)

Same structure as Part C, but for the 5 organizational values:
1. Ownership and Alignment
2. Respect and Acceptance
3. Innovation and Imagination
4. Agility
5. Integrity and Authenticity

Skip this part entirely if the OF round is not present in the transcript.

---

### Part E — GD participant status index

For every person who appeared in the GD, record their outcome and reason. This feeds directly into the GD Eliminations section of the report.

```
name: <candidate name>
outcome: Eliminated at GD | Eliminated at HR | Did not advance to HR | Deferred | Completed all rounds
elimination_reason: <explicit reason from transcript, or clearest inference with note "inferred">
gd_observation: <1 sentence on what they did or said in GD — even if eliminated>
```

**Rules for elimination_reason:**
- If the interviewer explicitly states a reason (e.g., "H4 — only 2 months available"), use it verbatim.
- If no explicit reason: infer from context and mark as "inferred — [basis]." Example: "inferred — no audible contribution in transcript."
- NEVER leave `elimination_reason` blank or write "not stated" alone without adding the observed context.

**Rules for ambiguous outcomes:**
- If a candidate was active in GD but was never explicitly called into the HR round and no explicit elimination was recorded: classify outcome as "Did not advance to HR Round" and note "no explicit elimination or invitation in transcript."
- Do NOT leave the outcome open-ended.

---

## Transcript quality note

Append to the signal pool:

- **Rounds present:** GD / HR Round / NF Round / OF Round (mark which are missing)
- **Transcript length:** Full / Partial / Summary only
- **Format detected:** Zoom VTT / Q&A / Summary notes
- **Limitations:** anything that will affect scoring accuracy

### Breakout rooms

Breakout-room conversations are **not captured in Zoom transcripts**. This is
expected and is not itself a transcript quality issue. By design, the HR team
runs all key discussions and assessments in the main session where the
transcript exists. Off-record breakouts are typically quick internal HR
coordination, not evaluation moments.

- Do **not** flag "breakout rooms held" as a quality limitation.
- Do flag it if a candidate's main-session coverage is clearly incomplete
  *because* assessment happened in breakout (rare). Note it as:
  "Partial coverage — portion of assessment appears to have occurred in a
  breakout room not captured in transcript."

---

## Rules

- Extract and label only — never assign scores
- Never make recommendations
- Never quote candidate verbatim — paraphrase as behavioral observations
- Flag ambiguous evidence in `ambiguity_notes`, do not silently pick a side
- Note evidence gaps explicitly with `signal_strength: Absent`
- Do NOT cross the round-gating line — if NF round wasn't conducted, leave
  Part C empty; if OF round wasn't conducted, omit Part D
