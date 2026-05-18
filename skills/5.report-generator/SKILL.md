---
name: report-generator
description: >
  Called internally by evaluate-candidate orchestrator as the final step.
  Assembles the scoring report from all agent outputs. Do not trigger directly.
user-invocable: false
---

# Report Generator

Assembles the final candidate evaluation report from all agent outputs.
The report is a scoring document — it rates candidates on fit, not on
whether they should be rejected.

## On activation

1. Receive ALL outputs: candidate metadata, behavioral signals, trait scores,
   value scores — for EVERY candidate mentioned in the transcript (including
   GD-only eliminations)
2. **Run `scripts/calculate-score.js`** (relative to this skill folder) with the trait and value scores
3. Assemble evaluation data as a **JSON object** following the schema defined in
   `scripts/generate-docx.py` (see the docstring at the top of that file)
4. Write the JSON to a temp file and run:
   `python scripts/generate-docx.py <input.json> <output.docx>`
   Save the .docx to `data/evaluation-reports/` with naming convention:
   `batch-YYYY-MM-DD-[role].docx`
5. Also output the report as clean markdown in the chat (using
   `scripts/report-template.md` as the structure reference) so the HR user
   can review it inline before opening the Word document

## Assembly rules

### Round-gating — only include sections for rounds that were conducted

The report structure adapts based on which rounds the candidate actually completed.
Do NOT include scoring sections for rounds that were never conducted.

| Rounds completed | Report sections to include |
|-----------------|--------------------------|
| GD only | Section 1 (Introduction) only — brief entry with name, outcome, note. |
| GD + HR Round | Sections 1–2 (Introduction, HR Round Evaluation) + Overall Evaluation Summary + Recommendation (qualitative only). NO NF/OF. |
| GD + HR + NF only | Sections 1–2 + Section 4 (NF Primary) + Section 5 (NF Secondary if applicable) + Overall Evaluation Summary. NO OF. No Total Score. |
| GD + HR + NF + OF | Full report — all sections. Total Score computed. Full recommendation. |

### General rules

- Use the updated `scripts/report-template.md` structure — it matches Suhani's evaluation format
- Every trait gets a **1-2 sentence narrative + Signal: one-liner + Rating** — concise and evaluative, not a table row or checklist
- OF values get a **1 sentence narrative evaluation** in each table cell — not just "Score X"
- Include **Natural Fit Summary** (2 strengths + 1 concern + verdict) after each NF section — keep it tight
- Include **Organizational Fit Summary** (2-3 strengths + 1 concern + verdict) after OF section
- Support **secondary role NF evaluation** when a secondary role was assessed — present primary and secondary independently; do **NOT** compare them or recommend which role is a stronger fit (per HR OL, role suitability decisions happen after the report)
- Never quote candidates verbatim — write in third-person HR evaluation voice
- Never exaggerate strengths — if evidence is thin, say so
- For scored candidates, recommendation must cite specific trait names, value names, and the score
- Remove all template placeholders from final output

### Key Risk (required for every scored candidate)

Every fully-scored candidate must include a **Key Risk** field — **1–2 plain sentences**. No numbered lists. No compound parenthetical constructions. If there are multiple risks, name the most critical one as the primary sentence, and mention others briefly in a second sentence only if they materially change the decision.

This is the hiring risk — the thing that could make the hire go wrong even if the score looks acceptable:
- Commitment risk (timeline clash, multi-application pipeline, early-exit history)
- Structural skill gap that directly affects role performance (e.g., Communication 2.5 for an HR role)
- Motivation misalignment (instrumental vs. role-committed)
- Low-confidence assessment that could materially change the recommendation

Write it as a direct, declarative statement: "Commitment risk — Master's abroad timeline clashes with the 6-month window." Not as a hedge. Not as a numbered list.

If there is no material risk, write: "No material risk identified at assessment stage."

### Action Label (required for every scored candidate)

The **Action Label** is the PRIMARY recommendation signal. It is shown first and largest in the report — the score tier appears only as supporting context beneath it. **Do not display both at equal prominence — pick one clear call.**

| Recommendation Tier | Action Label |
|--------------------|-------------|
| Recommended (8.5+) | ✅ **Hire** |
| Can Be Considered (7.0–8.4) | 🟡 **Hold** |
| Borderline (5.5–6.9) | 🟡 **Hold — needs HR OL review** |
| Not Recommended (3.5–5.4) | ❌ **Reject** |
| Strong No (below 3.5) | ❌ **Reject** |

The score tier (e.g., "Can Be Considered") appears in the score table and as small supporting text below the action label — never as a headline alongside it. A decision-maker should see one clear call, not two overlapping labels.

### Placement Fit note (for Good/Strong candidates only)

When a candidate's NF or OF verdict is **Good or Strong** (average ≥ 3.5), include a 1-line **Placement Fit** note in the Recommendation section suggesting where within the team they would add most value — based on their highest-scoring traits.

- Ground it in the actual scores: "Strongest in Communication and Empathy — best fit for employee-facing or welfare functions rather than recruitment or policy."
- Skip this field entirely for Adequate or Weak candidates.
- Do NOT make placement decisions — just surface a fit signal for HR OL to consider.

### GD elimination entries — minimum content standard

Every GD/pre-interview elimination entry must include:
- **Name**
- **Stage eliminated** (GD, HR Round, pre-interview, deferred)
- **Outcome field** — a definitive, unhedged statement: "Eliminated at GD" / "Did not advance to HR Round" / "Deferred." Do NOT use qualifiers like "inferred" or "status unclear" in the outcome field. Inference reasoning belongs only in the note.
- **Note** — explicit reason from transcript, or clearest inference with observable basis. If no explicit reason: write what was observed ("Active GD participant; not called to HR round — reason not stated by interviewer").
- **Ambiguous cases** — classify firmly. "Did not advance to HR Round" is a definitive outcome. Do NOT write "status ambiguous" or "may have been dropped." Make the call and put the reasoning in the note, not the outcome.

### Writing style — match Suhani's evaluation voice

The reports must read like Suhani wrote them — concise, evaluative, judgment-forward.
Key characteristics:

1. **Evaluative, not descriptive.** "Exposure is still limited to support roles; independent
   ownership yet to be tested." — This evaluates. "Candidate discussed ownership." — This describes.
   Always do the former.

2. **Acknowledge the candidate's stage.** "Early-stage candidate with relevant foundational
   exposure." Don't over-praise beginners or under-credit experienced candidates.

3. **Signal lines are headlines.** Each NF trait ends with "Signal: [one-sentence takeaway]" —
   the single most important behavioral observation for that trait.

4. **Balanced in one sentence.** "Shows adaptability, but mostly within guided environments." —
   Strengths AND limits in the same breath. Do not separate into separate paragraphs.

5. **Specific over generic.** Name the actual evidence — not "uses tools" but which tools,
   which pattern of behavior.

6. **Communication fluency ≠ trait strength.** A less articulate candidate with genuine
   understanding must be scored the same as a fluent one with equivalent depth. Score
   thinking, not delivery.

7. **HR Round is rich, not just facts.** Each parameter has both Observation (what they
   said) and Assessment (what it means). "3 internships; all unpaid" → "Learning-focused
   mindset; early-stage career approach."

## Score-to-recommendation mapping

| Score Range | Label | Emoji |
|-------------|-------|-------|
| 8.5 – 10.0 | Recommended | ✅ |
| 7.0 – 8.4 | Can Be Considered | 🟢 |
| 5.5 – 6.9 | Borderline | 🟡 |
| 3.5 – 5.4 | Not Recommended | 🔴 |
| Below 3.5 | Strong No | ⛔ |

## Multi-candidate mode

After all individual reports, add a Comparative Summary Table:

| Rank | Name | Role | NF Avg | OF Avg | Total /10 | Recommendation |

Ranked by Total Score descending.
Candidates within 0.3 points: "Too close to rank — recommend HR OL review both"

## Footer on every report

```
Final decision authority: HR OL — Nitin Sir
This report is a scoring input, not a hiring decision.
To check rejection criteria (H1–H5, S1–S7), use /justify-rejection.
Omysha Foundation — Confidential
```

## Word document output

The primary deliverable is a `.docx` file generated via `scripts/generate-docx.py`.
The JSON input must include ALL candidates — both fully evaluated candidates
(in `candidates` array) and GD-only eliminations (in `gd_eliminations` array).

After generating, tell the user:
> "Report saved to `data/evaluation-reports/batch-[date]-[role].docx`"
