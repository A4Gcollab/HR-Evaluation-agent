# Interview Process & Agent Workflow
**Omysha Foundation | v1.0 | March 2026**

---

## 1. Interview Pipeline

Omysha Foundation's interview process has three sequential rounds. Candidates may be eliminated at any stage. The agent enters the picture **after** all rounds are complete and a transcript is available.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────────────────┐
│   Round 1    │────►│   Round 2    │────►│       Round 3            │
│ Group        │     │ HR Round     │     │ Natural Fit + Org Fit    │
│ Discussion   │     │              │     │                          │
│ (GD)         │     │              │     │                          │
└──────┬───────┘     └──────┬───────┘     └────────────┬─────────────┘
       │                    │                          │
  Eliminated?          Eliminated?              All rounds done
  (poor comm,          (availability,
   zero                 stipend,                       │
   participation)       commitment)                    ▼
       │                    │              ┌──────────────────────┐
       ▼                    ▼              │   Transcript ready   │
  Brief entry          Partial report     │   for evaluation     │
  in report            (qualitative)      └──────────┬───────────┘
                                                     │
                                                     ▼
                                          ┌──────────────────────┐
                                          │  Agent evaluates     │
                                          │  (evaluate-candidate)│
                                          └──────────┬───────────┘
                                                     │
                                                     ▼
                                          ┌──────────────────────┐
                                          │  Report → Nitin Sir  │
                                          │  (final decision)    │
                                          └──────────────────────┘
```

---

## 2. Round Details

### Round 1 — Group Discussion (GD)

| Aspect | Detail |
|--------|--------|
| **Purpose** | Evaluate communication, confidence, and team behavior in a group setting |
| **Participants** | Multiple candidates together |
| **Conducted by** | HR team (Sushma / Suhani) |
| **Signals observed** | Communication clarity, participation level, collaborative vs. dominant behavior, thought structure under pressure, basic Omysha awareness |
| **Elimination criteria** | Severely poor communication, zero participation |
| **Data generated** | Group observation notes (often part of the combined transcript) |
| **What the agent can score from GD** | Nothing — GD observations inform the interview summary only |

### Round 2 — HR Round

| Aspect | Detail |
|--------|--------|
| **Purpose** | Assess availability, commitment, motivation, and basic fit |
| **Participants** | Individual candidate |
| **Conducted by** | Sushma (primary), Suhani |
| **Points checked** | Introduction/background, understanding of Omysha, availability and hours, 6-month commitment, stipend expectations, communication quality |
| **Elimination criteria** | Hard rejection triggers H1–H5 (availability, stipend, commitment conflicts) |
| **Data generated** | One-on-one Q&A transcript |
| **What the agent can score from HR** | Behavioral signals (transcript-analyzer) + logistical fact extraction. NOT NF or OF scores. |

### Round 3 — Natural Fit + Organizational Fit Round

| Aspect | Detail |
|--------|--------|
| **Purpose** | Assess role-specific suitability (NF) and cultural alignment (OF) |
| **Participants** | Individual candidate |
| **Conducted by** | Nausheen (primary), Suhani |
| **Structure** | 8–9 structured questions: 4–5 for NF traits, 4–5 for OF values |
| **Secondary role** | If candidate has a secondary role preference, additional NF assessment is conducted |
| **Data generated** | Structured Q&A transcript |
| **What the agent can score** | Full NF scores (5 traits) + full OF scores (5 values) → Total Score out of 10 |

---

## 3. Roles and Responsibilities

### Interview Team

| Person | Interview Role | Rounds Involved |
|--------|---------------|-----------------|
| **Sushma** | Primary interviewer for GD and HR Round | Round 1, Round 2 |
| **Suhani** | HR Lead, supports all rounds, operates the agent | All rounds |
| **Nausheen** | Primary interviewer for NF/OF assessment | Round 3 |

### Post-Interview

| Person | Responsibility |
|--------|---------------|
| **Suhani** | Provides transcript to agent, reviews output reports, configures evaluation rules |
| **Agent** | Processes transcript, scores candidates, generates .docx report |
| **Nitin Sir (HR OL)** | Receives reports, makes final hire/reject decisions |

---

## 4. Transcript Capture

### Supported Formats

| Format | Source | Quality |
|--------|--------|---------|
| Zoom VTT | Zoom auto-transcription | Variable — may have speaker misattribution |
| Zoom AI Companion | Zoom AI summary + transcript | Good — structured with speaker labels |
| Q&A format | Manual notes (interviewer types questions and responses) | High — but may miss nuance |
| Summary notes | Post-interview summary by interviewer | Low — significant detail loss |

### Formatting guidelines for best results
- Include speaker labels (Interviewer / Candidate name)
- Separate rounds with clear headers (e.g., "--- HR Round ---", "--- NF Assessment ---")
- Note which rounds were conducted and which were skipped
- For multi-candidate batches, clearly delineate where one candidate's section ends and another begins
- Include candidate's stated availability and stipend discussions verbatim if possible

### Quality impact on agent output

| Transcript Quality | Agent Capability | Assessment Confidence |
|-------------------|-----------------|----------------------|
| Full transcript, all rounds, speaker labels | Full scoring pipeline | High |
| Partial transcript, missing one round | Score available rounds only, skip missing | Medium |
| Summary notes only | Behavioral signal extraction only, limited scoring | Low |
| Garbled / heavily auto-transcribed | Best-effort extraction, flag limitations | Low |

---

## 5. Timeline

| Event | Timing |
|-------|--------|
| Interview batch conducted | Day 0 |
| Transcript available | Day 0 (Zoom auto) or Day 1 (manual notes) |
| Agent evaluation triggered | Day 0–1 (Suhani pastes transcript) |
| Report generated | Minutes after transcript is provided |
| Suhani reviews report | Day 0–1 |
| Report delivered to Nitin Sir | Day 1–2 |
| Final decision communicated | At Nitin Sir's discretion |

---

## 6. Agent Workflow — Step by Step

This section documents what happens inside the agent when Suhani pastes a transcript.

### Step 1: Candidate Identification
```
Input:  Raw transcript
Action: Scan for all candidate names, roles, dates, rounds completed
Output: Candidate list with metadata
Gate:   If role is ambiguous → check config for auto_infer_role setting
```

### Step 2: Role Reference Loading
```
Input:  Role name from Step 1
Action: Load references/natural-fit-[role].md
Check:  Is role reference production-ready?
Gate:   If placeholder → check config for allow_placeholder_scoring
```

### Step 3a: Transcript Analysis (per candidate)
```
Input:  Full transcript for this candidate
Action: transcript-analyzer extracts 5 signal categories + logistical facts
Output: Structured behavioral signal summary
Runs:   For any candidate with at least GD + HR Round data
```

### Step 3b: Natural Fit Scoring (per candidate)
```
Input:  Signal pool (from transcript-analyzer) + role reference
Action: natural-fit scores 5 role-specific traits
Output: 5 trait scores (1–5) + NF average
Runs:   ONLY if NF round was conducted in transcript
```

### Step 3c: Organizational Fit Scoring (per candidate)
```
Input:  Transcript + signals
Action: org-fit-evaluator scores 5 universal values
Output: 5 value scores (1–5) + OF average
Runs:   ONLY if OF round was conducted in transcript
```

### Step 3d: Escalation Check
```
Input:  All scores and evidence from 3a–3c
Action: Check for insufficient evidence, ambiguity, boundary scores
Route:  Per config/evaluation.json autonomy settings:
        - auto_resolve → apply defaults, note in report
        - escalate → pause and ask Suhani (max 3 per batch)
```

### Step 3e: Report Generation
```
Input:  All outputs from 3a–3d
Action: calculate-score.js → Total Score
        report-template.md → structure
        generate-docx.py → Word document
Output: .docx saved to data/evaluation-reports/
        + inline markdown in chat
```

### Step 4: Multi-Candidate Comparison
```
Input:  All individual reports
Action: Rank scored candidates, flag within-0.3 ties
Output: Comparative summary table appended to report
```

---

## 7. Feedback Loop

### How evaluation quality is reviewed and improved

1. **Report review by Suhani**: Every report is reviewed before going to Nitin Sir. Suhani flags scoring discrepancies.

2. **Decision tracking**: When Nitin Sir makes a final decision that differs from the agent's recommendation, that's a signal to review the scoring criteria.

3. **Calibration sessions** (planned): Suhani manually scores a candidate, then compares with agent output. Differences >1 point on any trait trigger a review of that trait's reference definitions.

4. **Role trait validation**: Placeholder role traits (Marketing, Community, Product, Project) should be validated through calibration before being marked production-ready.

5. **Threshold tuning**: If the agent consistently recommends candidates that Nitin Sir rejects (or vice versa), the recommendation thresholds in `config/evaluation.json` should be adjusted.
