# System Architecture — HR Evaluation Agent
**Omysha Foundation | v1.1 | April 2026**

---

## 1. System Overview

The HR Evaluation Agent is a skill-based pipeline built on Claude Code. It
consists of one orchestrator skill, three sub-skills that execute sequentially
in the evaluation pipeline, and one standalone skill for on-demand rejection
screening.

**Key simplification (v1.1):** the transcript is read **exactly once** by
`1.transcript-analyzer`, which emits a structured "signal pool". Both scorers
(`2.natural-fit` and `3.org-fit-evaluator`) consume this pool — they no longer
re-scan the transcript. Previously, three sub-skills each scanned the raw
transcript independently, producing subtle inconsistencies and triplicating work.

```
┌─────────────────────────────────────────────────────────────────────┐
│                        USER (Suhani / Sushma)                       │
│                     Pastes transcript + invokes                     │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 0.evaluate-candidate (Orchestrator)                  │
│                                                                     │
│  Reads config/evaluation.json — all rules live there                │
│                                                                     │
│  1. Identify candidates    ──────────► Candidate list               │
│  2. Load role reference    ──────────► Role config + trait defs     │
│  3. Run evaluation pipeline (per candidate):                        │
│     ┌─────────────────────────────────────────────────────────┐     │
│     │                                                         │     │
│     │  ┌────────────────────────────┐                         │     │
│     │  │ 1.transcript-analyzer      │                         │     │
│     │  │ (single read pass)         │                         │     │
│     │  │                            │                         │     │
│     │  │ Emits the SIGNAL POOL:     │                         │     │
│     │  │  A. Cross-cutting signals  │                         │     │
│     │  │  B. HR-Round parameters    │                         │     │
│     │  │  C. Per-trait evidence     │                         │     │
│     │  │  D. Per-value evidence     │                         │     │
│     │  └──────────────┬─────────────┘                         │     │
│     │                 │                                       │     │
│     │        ┌────────┴────────┐                              │     │
│     │        ▼                 ▼                              │     │
│     │  ┌──────────────┐  ┌──────────────────┐                │     │
│     │  │ 2.natural-   │  │ 3.org-fit-       │                │     │
│     │  │ fit          │  │ evaluator        │                │     │
│     │  │              │  │                  │                │     │
│     │  │ 5 NF traits  │  │ 5 OF values      │                │     │
│     │  │ (role-       │  │ (universal)      │                │     │
│     │  │  specific)   │  │                  │                │     │
│     │  └──────┬───────┘  └────────┬─────────┘                │     │
│     │         │                   │                          │     │
│     │         └─────────┬─────────┘                          │     │
│     │                   ▼                                    │     │
│     │  ┌────────────────────────────────────────┐            │     │
│     │  │     Escalation check (Level 0/1/2)     │            │     │
│     │  │     driven by config/evaluation.json   │            │     │
│     │  └────────────────┬───────────────────────┘            │     │
│     │                   ▼                                    │     │
│     │  ┌────────────────────────────────────────┐            │     │
│     │  │  5.report-generator                    │            │     │
│     │  │   - scripts/calculate-score.js         │            │     │
│     │  │   - scripts/report-template.md         │            │     │
│     │  │   - scripts/generate-docx.py           │            │     │
│     │  └────────────────────────────────────────┘            │     │
│     └─────────────────────────────────────────────────────────┘     │
│                                                                     │
│  4. Multi-candidate comparison (if >1 candidate)                    │
│  5. Output: .docx + inline markdown                                 │
└─────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  justify-rejection    │
                    │  (on-demand, separate)│
                    │  H1–H5 hard criteria  │
                    │  S1–S7 soft flags     │
                    └──────────────────────┘
```

---

## 2. Skill Inventory

| Skill | Type | Purpose | Input | Output |
|-------|------|---------|-------|--------|
| **0.evaluate-candidate** | Orchestrator | Coordinates full evaluation pipeline | Interview transcript | .docx report + inline markdown |
| **1.transcript-analyzer** | Sub-skill | Single read pass; emits structured signal pool | Raw transcript text | Signal pool (A/B/C/D) + quality note |
| **2.natural-fit** | Sub-skill | Scores 5 role-specific Natural Fit traits | Signal pool + role reference | 5 trait scores (1–5) + NF average |
| **3.org-fit-evaluator** | Sub-skill | Scores 5 universal Org Fit values | Signal pool + OF value defs | 5 value scores (1–5) + OF average |
| **5.report-generator** | Sub-skill | Assembles final report and generates .docx | All prior outputs | Formatted report (.docx + markdown) |
| **justify-rejection** | Standalone | On-demand rejection screening | Transcript (+ optional scoring report) | Hard/soft rejection flags |

---

## 3. Data Flow

```
Interview Transcript (Zoom VTT / AI Companion / Q&A / Notes)
        │
        ▼
[1] IDENTIFY CANDIDATES
        │ Extract: name, role, date, rounds completed,
        │ availability, stipend, resume status
        ▼
[2] LOAD ROLE REFERENCE
        │ Match role → 2.natural-fit/references/natural-fit-[role].md
        │ Check traits_validated status (config/evaluation.json)
        ▼
[3a] TRANSCRIPT ANALYZER (single read pass)
        │ Output: Signal pool
        │   A. Cross-cutting signals (communication, confidence,
        │      org awareness, attitude) with Strong/Moderate/Weak/Poor labels
        │   B. HR Round parameter extractions (availability, stability,
        │      stipend, motivation, expectations, career goals, org alignment)
        │   C. Per-NF-trait evidence index (keyed by trait name)
        │   D. Per-OF-value evidence index (keyed by value name)
        │   + transcript quality note
        ▼
[3b] NATURAL FIT (if NF round conducted)
        │ Input: signal pool Part C + role reference
        │ Does NOT re-read transcript
        │ Output: 5 trait scores + observations + NF avg
        ▼
[3c] ORG FIT EVALUATOR (if OF round conducted)
        │ Input: signal pool Part D + docs/hr-evaluation-documentation.md §3
        │ Does NOT re-read transcript
        │ Output: 5 value scores + observations + OF avg
        ▼
[3d] ESCALATION CHECK ◄──── config/evaluation.json
        │ Level 0: auto-resolve (insufficient evidence → default score)
        │ Level 1: flag in report (near tier boundary, placeholder traits)
        │ Level 2: pause and ask (only for genuinely exceptional cases)
        ▼
[3e] REPORT GENERATOR
        │ Run: 5.report-generator/scripts/calculate-score.js → Total Score
        │ Apply: 5.report-generator/scripts/report-template.md → structure
        │ Run: 5.report-generator/scripts/generate-docx.py → Word document
        ▼
    OUTPUTS
    ├── data/evaluation-reports/batch-YYYY-MM-DD-[role].docx
    └── Inline markdown in chat
```

---

## 4. Decision Points — Human vs. Agent

This is the key architectural distinction Murali highlighted. The system is
designed **human-on-the-loop, not in-the-loop.** Suhani defines the rules once
in `config/evaluation.json`; the agent executes within them.

### The two mechanisms that replace Suhani's case-by-case judgment

| Mechanism | What it replaces | Where it lives |
|-----------|------------------|----------------|
| **Config-driven defaults** | Suhani's decisions on thresholds, defaults, availability, role readiness | `config/evaluation.json` |
| **3-level escalation hierarchy** | Suhani's decisions on when to ask Nitin Sir vs. when to decide herself | `0.evaluate-candidate/SKILL.md` (Decision Authority section) |

### Decision-point mapping

| Decision Point | In-the-loop (old) | On-the-loop (current) |
|---------------|-------------------|----------------------|
| Insufficient evidence for a trait | Ask Suhani for observations | Auto-score from `default_insufficient_evidence_score`, note in report |
| Role not stated in transcript | Ask user | Infer from context if `auto_infer_role_from_context: true`; escalate only if no context exists |
| Placeholder role traits | Ask user to confirm proceeding | Config flag `allow_placeholder_scoring` decides; warning added to report header |
| Ambiguous signal | Ask which interpretation | Apply conservative interpretation, flag in report |
| Score near tier boundary (within `tier_boundary_threshold`) | Ask for additional input | Flag in report: "Score near boundary — recommend HR OL review" |
| Transcript quality poor | Ask user to fill gaps | Score what's available, lower assessment confidence, note limitations |

### Escalation hierarchy

```
Level 0: AUTO-RESOLVE (no human involvement)
  - Insufficient evidence → default score from config
  - Missing role → infer from transcript context (if enabled)
  - Poor transcript sections → skip, note limitation
  - Ambiguous signal → conservative interpretation

Level 1: FLAG IN REPORT (human reviews output)
  - Score near tier boundary (within configured threshold)
  - Placeholder role traits used
  - 3+ traits scored with default (reliability reduced)
  - Transcript quality: Low

Level 2: PAUSE AND ASK (human must respond — capped by max_escalations_per_batch)
  - Role completely unidentifiable (no context clues)
  - Candidate/interviewer identity confusion
  - Contradictory hard-rejection evidence
  - Placeholder scoring blocked by config
```

The contract: if the agent is pausing for something not on the Level 2 list,
that is a bug — push it to Level 0/1 and add a config flag if needed.

---

## 5. Configuration Layer

All configurable parameters live in `config/evaluation.json`. Suhani edits this
file to tune the agent's behavior — no code changes required.

### Configuration schema (evaluation.json)

```json
{
  "scoring": {
    "default_insufficient_evidence_score": 2,
    "tier_boundary_threshold": 0.3,
    "recommendation_thresholds": {
      "recommended": 8.5,
      "can_be_considered": 7.0,
      "borderline": 5.5,
      "not_recommended": 3.5
    }
  },
  "autonomy": {
    "auto_resolve_insufficient_evidence": true,
    "auto_resolve_ambiguous_signals": true,
    "auto_infer_role_from_context": true,
    "allow_placeholder_scoring": false,
    "max_escalations_per_batch": 3
  },
  "rejection_screening": {
    "auto_include_in_pipeline": false,
    "include_flags_in_report": false
  },
  "roles": {
    "hr": {
      "availability_requirement": "From 3:00 PM onwards on weekdays",
      "reference_file": "2.natural-fit/references/natural-fit-hr.md",
      "traits_validated": true
    },
    "marketing": {
      "availability_requirement": "5:00 PM to 9:00 PM on weekdays",
      "reference_file": "2.natural-fit/references/natural-fit-marketing.md",
      "traits_validated": false
    }
  }
}
```

---

## 6. File Structure

```
claude-skills/
├── CLAUDE.md                          ← Project-level instructions
├── config/
│   └── evaluation.json                ← Master evaluation config
├── data/
│   └── evaluation-reports/            ← Generated .docx reports
├── docs/
│   ├── project-overview.md            ← PRD
│   ├── architecture.md                ← This document
│   ├── interview-process.md           ← Process workflows
│   ├── evaluation-framework.md        ← Scoring philosophy and calibration
│   └── hr-evaluation-documentation.md ← Single source of truth for agents
└── skills/
    ├── 0.evaluate-candidate/          ← Orchestrator
    │   └── SKILL.md
    ├── 1.transcript-analyzer/         ← Single read pass → signal pool
    │   └── SKILL.md
    ├── 2.natural-fit/                 ← NF scorer (5 role-specific traits)
    │   ├── SKILL.md
    │   └── references/
    │       ├── natural-fit-hr.md      ← Production-ready
    │       ├── natural-fit-project.md ← Production-ready
    │       ├── natural-fit-rab.md     ← Production-ready
    │       ├── natural-fit-marketing.md
    │       ├── natural-fit-community.md
    │       ├── natural-fit-product.md
    │       └── natural-fit-general.md
    ├── 3.org-fit-evaluator/           ← OF scorer (5 universal values)
    │   └── SKILL.md
    ├── 5.report-generator/            ← Report assembly + .docx
    │   ├── SKILL.md
    │   └── scripts/
    │       ├── calculate-score.js
    │       ├── generate-docx.py
    │       └── report-template.md
    └── justify-rejection/             ← Standalone: rejection screening
        └── SKILL.md
```

---

## 7. Key Design Principles

1. **Single read, structured signal pool.** The transcript is parsed once by
   `1.transcript-analyzer`. Scorers consume structured evidence — never the raw
   transcript. This eliminates triplicated scanning and inter-skill drift.

2. **Separation of scoring and rejection.** Evaluation reports score fit;
   rejection screening is a separate concern (`justify-rejection`). This
   prevents rejection bias from influencing fit scores.

3. **Round-gating.** Never score what wasn't assessed. If a candidate only
   completed GD + HR, they get a qualitative summary — not fabricated NF/OF scores.

4. **Evidence-grounded scoring.** Every score must cite a specific behavioral
   example from the signal pool. No score without evidence.

5. **Configuration over conversation.** Rules that don't change per-candidate
   (thresholds, availability windows, defaults) live in `config/evaluation.json`,
   not chat.

6. **Escalate exceptions, not routine.** The agent handles 90%+ of decisions
   autonomously (Level 0/1). Only genuinely ambiguous or high-stakes edge cases
   warrant human input (Level 2).

7. **Single source of truth.** `docs/hr-evaluation-documentation.md` is the
   canonical reference for values, traits, criteria, and questions. Skills read
   from it; they don't duplicate it.
