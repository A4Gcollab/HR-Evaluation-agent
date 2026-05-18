---
name: evaluate-candidate
description: >
  Use this skill to evaluate HR interview candidates at Omysha Foundation and
  generate structured scoring reports. Triggers when a user pastes an interview
  transcript, Zoom AI Companion export, VTT file, or meeting notes and asks to:
  evaluate a candidate, generate an HR report, assess fit, score an applicant,
  compare candidates, rank applicants, or decide who to hire. Also triggers for
  casual phrasing like "check this candidate", "is this a good fit", "who should
  we shortlist", "rate this person", or "run evaluation". Always use this skill
  when interview transcript data is present alongside any evaluation or reporting
  intent — even if not explicitly requested.
---

# Evaluate Candidate — Omysha Foundation

Orchestrator for the candidate evaluation pipeline. Coordinates four sub-skills
to produce a structured scoring report:

```
0. evaluate-candidate    (this skill — orchestrator)
   ├── 1. transcript-analyzer    → extracts evidence ONCE from transcript
   ├── 2. natural-fit            → scores 5 role-specific NF traits
   ├── 3. org-fit-evaluator      → scores 5 universal OF values
   └── 5. report-generator       → assembles report, runs scripts, emits .docx
```

Final hire/reject decision is always made by HR OL (Nitin Sir). This report is an
input to that decision, not the decision itself.

---

## Decision Authority — what replaces Suhani's judgment

Historically, Suhani made every judgment call: how to score with thin evidence,
when to escalate, which role to assume, what to do with placeholder traits. This
agent replaces that case-by-case judgment with **two explicit mechanisms**:

### Mechanism 1 — `config/evaluation.json` (rules Suhani would have applied)

Read this file **first, before doing anything else.** It encodes:

- **Scoring defaults** — what score to assign when evidence is insufficient (was: Suhani's "score 2 with a note")
- **Autonomy flags** — what the agent decides vs. what it asks (was: Suhani choosing whether to ask Nitin Sir)
- **Role configs** — which roles are validated, which are placeholder, availability windows (was: Suhani checking each role's reference doc)
- **Recommendation thresholds** — score ranges per tier (was: Suhani applying the rubric mentally)
- **Escalation budget** — `max_escalations_per_batch` (was: Suhani choosing what to surface to HR OL)

If a value is in the config, **use the config — do not re-decide.** Hardcoding a
threshold or default in the agent re-introduces the very judgment we are replacing.

### Mechanism 2 — Three-level escalation hierarchy (when to act vs. ask)

Every situation that previously needed Suhani's intervention now falls into one of
three buckets. The agent operates **on the loop** — Suhani reviews the report, but
does not need to participate in every intermediate decision.

| Level | What it means | Who acts |
|-------|--------------|----------|
| **0 — AUTO-RESOLVE** | Apply the configured default, note it in the report | Agent silently |
| **1 — FLAG IN REPORT** | Proceed normally, but surface the situation in the output | Agent + reviewer reads later |
| **2 — PAUSE AND ASK** | Genuinely exceptional — needs a human answer to continue | User |

Full table in **Step 3d** below. The contract is: if the agent is pausing for
something that isn't on the Level 2 list, that is a bug — push it down to Level
0/1 and add a config flag if needed.

---

## Step 0 — Load configuration

Read `config/evaluation.json`. All decisions in subsequent steps must respect
its values. Do not hardcode thresholds, availability windows, or default scores.

## How to invoke

- **Single candidate:** Paste transcript → skill triggers automatically
- **Multiple candidates:** Paste all transcripts → evaluates each, then compares
- **Explicit:** /evaluate-candidate [transcript]

## Step 1 — Identify ALL participants

Scan the entire transcript and identify **every candidate mentioned** — not just
those who reached later rounds. Build a complete participant list:

For each candidate, extract:
- Candidate name
- Role applied (primary + secondary if mentioned)
- Interview date
- Rounds completed (GD only / GD + HR / GD + HR + Fit)
- Availability stated (if discussed)
- Stipend discussed (if any)
- Resume provided (yes / no)
- Outcome so far (still in process / eliminated at GD / eliminated at HR / completed all rounds)

Candidates eliminated at GD or removed for technical issues get a brief summary
entry in the report (name, outcome, note). They do NOT go through the full
scoring pipeline — there is insufficient data.

Candidates who completed at least GD + HR Round get full evaluation (Steps 2–3).

#### GD elimination entries — minimum content standard

Every elimination entry must include a **reason**. If the transcript states a reason, use it. If not, infer the most likely reason from context (e.g., low contribution, availability issue, interviewer feedback heard). Write: "Elimination reason not stated; [describe what was observed in GD]."

**Ambiguous cases — classify firmly, no hedging in the outcome field:**
- If a candidate was active in GD but not called into the HR round and no explicit elimination or invitation was recorded, classify outcome as: "Did not advance to HR Round."
- The word "inferred" and phrases like "status ambiguous" or "may have been dropped" must NOT appear in the outcome field. They belong in the note only if needed.
- The outcome the decision-maker reads must be a definitive call, not a question.

### Role identification
If role is missing or ambiguous:
- If `config.autonomy.auto_infer_role_from_context` is `true`: infer the role
  from transcript context (e.g., questions asked, discussion topics, candidate's
  stated interest). Note the inference in the report: "Role inferred from
  transcript context — not explicitly stated."
- If inference is not possible (no contextual clues at all), **then** ask the user.
- If `auto_infer_role_from_context` is `false`: ask the user before proceeding.

## Step 2 — Load role reference

Match the applied role to the correct reference file. These contain the 5 Natural Fit
trait definitions, score indicators, and behavioral signals for that role. They are
reference data — read the relevant one before scoring.

| Role | Reference File |
|------|---------------|
| HR | `2.natural-fit/references/natural-fit-hr.md` |
| Marketing | `2.natural-fit/references/natural-fit-marketing.md` |
| Community | `2.natural-fit/references/natural-fit-community.md` |
| Product Mgmt | `2.natural-fit/references/natural-fit-product.md` |
| Project Mgmt | `2.natural-fit/references/natural-fit-project.md` |
| RAB (Research & Analysis) | `2.natural-fit/references/natural-fit-rab.md` |
| Unknown/Other | `2.natural-fit/references/natural-fit-general.md` |

Note which reference was loaded — it appears in the final report.

### Secondary role handling

Some candidates are assessed for both a primary and secondary role. When the
transcript contains NF assessment questions for a secondary role:

1. Load the secondary role reference file in addition to the primary
2. Run natural-fit separately for the secondary role's 5 traits
3. Include the secondary role NF evaluation as a separate section in the report
   (Section 5 in the report template)
4. Present both evaluations **independently** — do **NOT** recommend which role
   is the stronger fit. Per HR OL, role suitability decisions are made after
   the report, not within it. The primary role remains the candidate's main
   preference; the secondary NF is an additional independent data point.
5. The Total Score is computed from the PRIMARY role NF only (secondary is advisory)

### Role data readiness

Not all role references contain validated trait definitions. Check the config:
`config.roles.[role].traits_validated`

| Role | Status |
|------|--------|
| HR | Production-ready (`traits_validated: true`) |
| Project Mgmt | Production-ready (`traits_validated: true`) |
| RAB | Production-ready (`traits_validated: true`) |
| Marketing | Placeholder (`traits_validated: false`) |
| Community | Placeholder (`traits_validated: false`) |
| Product Mgmt | Placeholder (`traits_validated: false`) |
| General | Placeholder (`traits_validated: false`) |

If the role's `traits_validated` is `false`:
- If `config.autonomy.allow_placeholder_scoring` is `true`: proceed but include a
  prominent warning in the report header: "Natural Fit criteria for [Role] are
  draft indicators and may not reflect finalized evaluation standards."
- If `allow_placeholder_scoring` is `false`: **ask the user** before proceeding.
  Only continue if they confirm.

## Step 3 — Run evaluation pipeline

Each step receives the outputs of all previous steps. **The transcript is read
exactly once, in step 3a.** Steps 3b and 3c consume the structured signal pool
that 3a produces — they do not re-scan the transcript.

### Round-gating rule

**Only score what was actually assessed.** Do not extrapolate or infer scores for
rounds that were never conducted:

| Rounds in transcript | What to score | What NOT to score |
|---------------------|---------------|-------------------|
| GD only | GD summary entry only (name, outcome, brief note) | Do NOT score NF or OF — no data |
| GD + HR Round | 3a (transcript analysis) + GD/HR summary | Do NOT score NF or OF — those rounds didn't happen |
| GD + HR + NF Round | 3a + 3b (Natural Fit scoring) | Do NOT score OF unless OF round was conducted |
| GD + HR + NF + OF | 3a + 3b + 3c (full evaluation) | All sections scored |

**Never infer Natural Fit or Org Fit scores from GD or HR Round signals.** GD tests
group discussion ability, not role-specific traits. HR Round tests availability,
motivation, and background — not the 5 NF traits or 5 OF values. Scoring NF/OF
without the actual round data gives false precision and can unfairly penalize
candidates who simply did not get the opportunity to be assessed.

For candidates without NF/OF round data, the report should:
- Show "Round not conducted — not scored" instead of scores
- Include a qualitative GD/HR summary with behavioral observations
- Note what rounds were completed and why evaluation is limited
- NOT produce a Total Score out of 10 (since the formula requires both NF and OF)

Run the applicable steps below based on what rounds are present in the transcript.

**3a → Analyze transcript** (single read)
Read `1.transcript-analyzer/SKILL.md` for instructions.
- Input: full transcript for this candidate
- Output: a **signal pool** — structured behavioral signals (communication,
  confidence, org awareness, attitude), HR Round parameter extractions, transcript
  quality note, and a per-trait/per-value evidence index keyed by NF trait name
  and OF value name
- Runs for: any candidate who completed at least GD + HR Round

**3b → Score Natural Fit**
Read `2.natural-fit/SKILL.md` for instructions.
- Input: signal pool from 3a + loaded role reference (the transcript itself is NOT re-read)
- Output: 5 trait scores (1–5) + HR observations + Natural Fit Average
- Runs for: candidates whose transcript contains a Natural Fit assessment round

**3c → Score Organizational Fit**
Read `3.org-fit-evaluator/SKILL.md` for instructions.
- Input: signal pool from 3a (the transcript itself is NOT re-read)
- Read: `docs/hr-evaluation-documentation.md` Section 3 for value definitions
- Output: 5 value scores (1–5) + HR observations + Org Fit Average
- Runs for: candidates whose transcript contains an Organizational Fit assessment round

**3d → Escalation check (config-driven)**

Before finalizing scores, review the evidence collected in 3a–3c. The agent's
behavior here is controlled by `config/evaluation.json` autonomy settings.

#### Level 0 — AUTO-RESOLVE (no human involvement)

These are handled silently. The agent applies defaults and notes it in the report.

| Situation | Auto-resolution | Report note |
|-----------|----------------|-------------|
| Insufficient evidence for a trait/value | Score = `config.scoring.default_insufficient_evidence_score` (default: 2) | "Insufficient evidence — default score applied" |
| Ambiguous/contradictory signal | Apply the more conservative interpretation | "Ambiguous signal — conservative interpretation applied" |
| Poor transcript quality (partial/garbled) | Score what's available, skip missing sections | "Transcript quality limitation — [detail]" |
| Multiple possible interpretations | Choose the interpretation supported by more evidence | "Multiple interpretations possible — majority-evidence interpretation used" |

Auto-resolution requires: `config.autonomy.auto_resolve_insufficient_evidence: true`
and/or `config.autonomy.auto_resolve_ambiguous_signals: true`. If these are `false`,
the agent falls through to Level 2 (ask user) instead.

#### Level 1 — FLAG IN REPORT (human reviews output, agent does not pause)

These are noted prominently in the report so Suhani can review them, but the agent
continues without pausing.

| Situation | What the agent does | Flag in report |
|-----------|-------------------|----------------|
| Score within `tier_boundary_threshold` of a recommendation tier | Assign the computed score normally | "Score near tier boundary (X.X) — recommend HR OL review" |
| Placeholder role traits used | Score with draft traits (if `allow_placeholder_scoring: true`) | "WARNING: NF traits for [Role] are draft indicators" |
| 3+ traits scored with default due to insufficient evidence | Complete the report | "Assessment reliability reduced — multiple traits lack evidence" |
| Transcript quality is Low | Score what's possible | "Low confidence assessment — limited transcript data" |
| Transcript-only assessment with evidence of unclear capture | Score per transcript; mention adjustment may be warranted | "Transcript-only assessment — HR OL may adjust ±0.5 based on in-person observation; higher adjustment possible if transcript clearly underrepresents the candidate" |

**Note on transcript-only assessments:** the agent only sees the transcript — it
cannot observe tone, audio clarity, or in-person presence. In Suhani's workflow,
when the transcript appeared weak but the candidate performed stronger in
person, she applied a moderate adjustment (~0.5) — or a larger one in clear
underrepresentation cases. Since this agent cannot see the interview, it
**reports what the transcript shows** and flags the possibility so HR OL can
apply a manual adjustment if warranted. The agent does NOT fabricate an
adjustment on its own.

#### Level 2 — PAUSE AND ASK (human must respond)

The agent only pauses for these genuinely exceptional situations. Maximum
`config.autonomy.max_escalations_per_batch` escalations per batch (default: 3).

| Situation | When it triggers |
|-----------|-----------------|
| Role completely unidentifiable | `auto_infer_role_from_context` is true but no context clues exist |
| Candidate vs. interviewer identity confusion | Cannot determine who is the candidate in the transcript |
| Contradictory hard-rejection evidence | Candidate says available AND has confirmed schedule conflict |
| Placeholder scoring blocked | `allow_placeholder_scoring` is false and role traits aren't validated |
| **Transcript too unclear to score reliably** | Critical sections are garbled, missing, or so ambiguous that scoring would require assumption. See rule below. |

#### Transcript-clarity rule (HR OL — strict)

Evaluation must never be based on assumption. Even a 0.5-point difference can
change rankings and tier assignment. Therefore:

- If the transcript is **partial but readable** (some sections missing,
  generally intelligible) → Level 1 flag: "Low confidence assessment —
  limited transcript data." Proceed with scoring what is available.
- If the transcript is **truly unclear or missing critical sections**
  (garbled audio, missing the NF or OF round entirely mid-section, ambiguous
  attribution of answers, no way to tell what the candidate actually said
  about the priority HR parameters) → **Level 2 pause**. Ask the user:
  > "Transcript quality for [candidate] is insufficient for reliable scoring
  > in [specific section]. Can you share the audio recording, re-export the
  > transcript, or provide the missing context?"

Do not infer content from surrounding context when the gap is in a scoring-
critical section. All scores must be fully evidence-based, not inferred.

Rules for escalation questions (Level 2 only):
- Ask **one question at a time** — do not batch questions together
- Prioritize questions that would **change a recommendation tier**
- Maximum `max_escalations_per_batch` questions total across all candidates
- If the HR user says "skip" or "I don't remember", proceed with auto-resolution
  and note "HR unable to provide additional context" in the observation

**3e → Generate report**
Read `5.report-generator/SKILL.md` for instructions.
- Input: ALL outputs from 3a–3d + parsed candidate data + GD-elimination summaries
- Run: `5.report-generator/scripts/calculate-score.js` to compute Total Score
- Use: `5.report-generator/scripts/report-template.md` for report structure
- Generate: Word document via `5.report-generator/scripts/generate-docx.py`
- Output: final structured evaluation report (.docx + inline markdown)

## Step 4 — Multi-candidate mode

Most transcripts contain multiple candidates in a single meeting. This is the
default mode — run Steps 1–3 independently per candidate.

After all individual evaluations (and after clarifying questions in Step 3d are
resolved), the report-generator produces:

1. **Full scored reports** for candidates who completed NF + OF rounds
2. **Partial reports** for candidates who completed GD + HR but not NF/OF rounds —
   these include a qualitative summary and behavioral observations but NO NF/OF
   scores and NO Total Score
3. **Brief entries** for GD-only eliminations (name, outcome, note)
4. **Comparative Summary Table** — only candidates with Total Scores are ranked:

| Rank | Name | Role | NF Avg | OF Avg | Total /10 | Recommendation |

Candidates without Total Scores appear below the table with a note:
"[Name] — [rounds completed] — Not scored (insufficient round data)"

Flag candidates within 0.3 points: "Too close to rank — recommend HR OL review both"

### Tie-break for closely-ranked candidates

When two or more candidates in the same batch give similar-quality answers and
their Total Scores land within 0.3 points, rely on **interview performance as
the primary signal** and use **background as a supporting differentiator** —
not the other way around.

Differentiators to surface in the comparative summary, in order of weight:
1. **Primary weight — interview performance:** HR Round depth, GD
   participation, NF and OF evidence specificity, authenticity of answers
2. **Supporting — background:** resume strength, relevant past experiences,
   indicators of exposure and stability

Do NOT rank a weaker-interview candidate above a stronger-interview candidate
just because the resume looks better. Background is a tie-breaker for close
calls, not a replacement for transcript-based evaluation. Note the
differentiator used explicitly in the comparative summary: e.g., "Both
candidates scored 7.8; Candidate A ranks above Candidate B due to deeper HR
Round motivation signal and more specific NF evidence; resume context is
comparable."

## Step 5 — Output

The final deliverable is a **Word document (.docx)** saved to
`data/evaluation-reports/batch-YYYY-MM-DD-[role].docx`.

The report-generator also outputs inline markdown in the chat so the HR user
can review immediately without opening the file.

Tell the user where the file was saved and remind them:
> "To check rejection criteria for any candidate, use `/justify-rejection`."

## Scoring system

Each trait and value is scored 1–5 in **0.5 increments** (1, 1.5, 2, 2.5, 3,
3.5, 4, 4.5, 5):

- 5 = Exceptional — out-of-the-box, original, deeply applied. **Extremely rare** — treat as a benchmark, not a common score. Most strong candidates fall 3–4.
- 4 = Good — clear, structured, typically supported by a relevant example or lived experience
- 3 = Adequate — basic or partially correct, shows some understanding but generic and lacking depth
- 2 = Weak — minimal or indirect evidence
- 1 = Poor — no meaningful evidence or signal actively contradicts the trait

**Half-scores (e.g., 3.5)** are valid and expected for nuanced borderline cases
— partial depth, inconsistent answers across questions, or clear potential
without full evidence. Do not force rounding.

**Authenticity rule:** a textbook-perfect answer that feels rehearsed is NOT
scored highly, even if topically correct. Personal insight, lived experience,
and original framing are required for 4+.

See [2.natural-fit/SKILL.md](../2.natural-fit/SKILL.md) and
[3.org-fit-evaluator/SKILL.md](../3.org-fit-evaluator/SKILL.md) for full
rubrics and examples.

**Total Score = Natural Fit contribution + Org Fit contribution (out of 10)**
See `5.report-generator/scripts/calculate-score.js` for exact calculation.

| Score Range | Recommendation | Meaning |
|-------------|----------------|---------|
| 8.5 – 10.0 | Recommended | Strong profile, clear endorsement |
| 7.0 – 8.4 | Can Be Considered | Moderately positive but cautious — **"yes with reservations," not a strong endorsement.** Candidate is not among the strongest profiles but shows potential and reasonable alignment. May perform well with the right opportunity or guidance. |
| 5.5 – 6.9 | Borderline | Mixed signals; HR OL review required |
| 3.5 – 5.4 | Not Recommended | Clear gaps against role requirements |
| Below 3.5 | Strong No | Disqualifying profile on fit alone |

### NF vs OF imbalance

Both NF and OF are **equally important**. A strong recommendation requires
alignment on **both dimensions**.

If the candidate is strong on one and weak on the other (e.g., NF 4.2, OF 2.8),
do NOT round up to a confident recommendation based on the average alone.
Instead:
- Compute the Total Score normally
- Flag the imbalance explicitly in the Overall Evaluation Summary
- If the computed tier is "Recommended" or "Can Be Considered" but the
  imbalance is significant, add: "Recommendation is cautious due to NF/OF
  imbalance — [dimension] is significantly weaker"

The recommendation should reflect consistent alignment across both dimensions,
because both directly impact performance and long-term fit.

### No score-driven follow-up tier

The agent does **not** recommend scheduling a follow-up interview based on
score range. Follow-ups are **situational** decisions made by HR OL when there
are specific doubts or clarifications needed — not driven by a borderline
score. If a candidate's score lands near a tier boundary, flag it per the
Level 1 escalation rule ("Score near tier boundary — recommend HR OL review"),
but do NOT propose a follow-up as a recommendation tier.

## What this skill does NOT do

This skill focuses on scoring and rating candidates. It does **NOT** run rejection
screening (H1–H5, S1–S7) as part of the standard evaluation.

**Do not include rejection flags, hard rejections, or soft flags in the evaluation
report.** Mixing rejection analysis into the scoring report biases the scorer and
undermines fair evaluation. Scores must reflect observed behavioral evidence only.

If the user wants to understand why a candidate was or should be rejected, they
should use `/justify-rejection` separately. That skill cross-references availability,
stipend, and commitment data against Omysha Foundation's hard and soft rejection
criteria.

When generating a report, include this note at the end:
> To check rejection criteria (H1–H5, S1–S7) for any candidate, use `/justify-rejection`.
