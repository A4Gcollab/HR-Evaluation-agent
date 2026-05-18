# Skills — HR Evaluation Agent

This folder contains the skill-based agent for evaluating interview candidates
at Omysha Foundation. Each subfolder with a `SKILL.md` is an independently
discoverable Claude Code skill.

---

## Layout at a glance

```
skills/
├── 0.evaluate-candidate/    ← ENTRY POINT — the orchestrator
├── 1.transcript-analyzer/   ← internal sub-skill
├── 2.natural-fit/           ← internal sub-skill (+ role references/)
├── 3.org-fit-evaluator/     ← internal sub-skill
├── 5.report-generator/      ← internal sub-skill (+ scripts/)
└── justify-rejection/       ← standalone, user-invocable
```

## Naming conventions

- **Numeric prefix (`0`, `1`, `2`, `3`, `5`)** — indicates execution order
  inside the `evaluate-candidate` pipeline. `0` is the orchestrator; `1`–`5`
  run in sequence. (There is no `4`; the former `4.scoring-engine` was merged
  into `2.natural-fit` during the v1.1 consolidation.)
- **No prefix** — standalone skills that are not part of the pipeline. Invoked
  directly by the user (e.g., `/justify-rejection`).

## User-invocable vs. internal

| Skill | Invoked by |
|-------|-----------|
| `0.evaluate-candidate` | User — triggered by pasting a transcript or `/evaluate-candidate` |
| `1.transcript-analyzer` | Orchestrator only |
| `2.natural-fit` | Orchestrator only |
| `3.org-fit-evaluator` | Orchestrator only |
| `5.report-generator` | Orchestrator only |
| `justify-rejection` | User — `/justify-rejection` |

Internal sub-skills carry `user-invocable: false` in their frontmatter. Do not
trigger them directly — the orchestrator passes them the inputs they need
(signal pool, role reference, etc.). Calling them standalone will skip the
round-gating and configuration layer and produce incorrect reports.

---

## Pipeline contract

```
User pastes transcript
       │
       ▼
0.evaluate-candidate
       │  reads config/evaluation.json (thresholds, autonomy flags, role status)
       │
       ├──► 1.transcript-analyzer     (SINGLE read pass over transcript)
       │         │
       │         ▼
       │    SIGNAL POOL
       │    ├── A. Cross-cutting signals (communication, confidence, ...)
       │    ├── B. HR Round parameters  (availability, stipend, motivation, ...)
       │    ├── C. Per-NF-trait evidence index (keyed by trait)
       │    └── D. Per-OF-value evidence index (keyed by value)
       │
       ├──► 2.natural-fit               (consumes C + role reference)
       │         │
       ├──► 3.org-fit-evaluator         (consumes D + value definitions)
       │         │
       ├──► Escalation check (Level 0/1/2 per config)
       │
       └──► 5.report-generator          (calculate-score.js, generate-docx.py)
                 │
                 ▼
            data/evaluation-reports/batch-YYYY-MM-DD-[role].docx
```

**Core invariant:** the transcript is read **exactly once**. Sub-skills 2 and 3
operate only on the structured signal pool — never on the raw transcript. This
is the simplification Murali flagged; re-adding a transcript read inside any
scorer re-introduces the inconsistency between scorers that this design exists
to prevent.

---

## Where things live

| Thing you want to change | Where |
|--------------------------|-------|
| A scoring threshold, default score, or autonomy flag | `config/evaluation.json` |
| A trait definition for a specific role | `2.natural-fit/references/natural-fit-[role].md` |
| An OF value definition | `docs/hr-evaluation-documentation.md` §3 |
| Report template / layout | `5.report-generator/scripts/report-template.md` |
| Total-score formula | `5.report-generator/scripts/calculate-score.js` |
| Word-document rendering | `5.report-generator/scripts/generate-docx.py` |
| Rejection criteria (H1–H5, S1–S7) | `docs/hr-evaluation-documentation.md` §2 |
| Pipeline order / orchestration logic | `0.evaluate-candidate/SKILL.md` |

## Adding a new role

1. Add a `natural-fit-[role].md` file in `2.natural-fit/references/` with 5
   traits and Score 5/3/1 indicators (follow the existing HR/Project/RAB files
   as templates — they are the production-ready references).
2. Register the role in `config/evaluation.json` under `roles`:
   ```json
   "newrole": {
     "availability_requirement": "...",
     "hard_rejection_code": "H3",
     "reference_file": "2.natural-fit/references/natural-fit-newrole.md",
     "traits_validated": false,
     "minimum_commitment_months": 6
   }
   ```
3. Add the role to the role-lookup table in
   [0.evaluate-candidate/SKILL.md](0.evaluate-candidate/SKILL.md) (Step 2).
4. While `traits_validated: false`, reports will carry a header warning that
   the traits are draft indicators. Flip to `true` once the trait definitions
   are finalized.

---

## Decision authority (what replaces Suhani's judgment)

The agent is designed **human-on-the-loop**, not human-in-the-loop. Every
case-by-case judgment Suhani used to make is handled by one of two mechanisms:

1. **`config/evaluation.json`** — rules Suhani would have applied (scoring
   defaults, autonomy flags, role readiness, recommendation thresholds).
2. **3-level escalation hierarchy** (defined in
   [0.evaluate-candidate/SKILL.md](0.evaluate-candidate/SKILL.md)):
   - **Level 0 — auto-resolve:** apply configured default, note in report.
   - **Level 1 — flag in report:** proceed, but surface the situation.
   - **Level 2 — pause and ask:** only for genuinely exceptional cases, capped
     by `max_escalations_per_batch`.

If the agent is pausing for something not on the Level 2 list, treat it as a
bug — push it to Level 0/1 and add a config flag if needed.

---

## Reference documents

- [CLAUDE.md](../CLAUDE.md) — project-level instructions
- [docs/architecture.md](../docs/architecture.md) — system diagram, data flow, decision-point mapping
- [docs/project-overview.md](../docs/project-overview.md) — PRD and success criteria
- [docs/interview-process.md](../docs/interview-process.md) — interview pipeline and agent workflow
- [docs/evaluation-framework.md](../docs/evaluation-framework.md) — scoring philosophy, calibration, bias mitigation
- [docs/hr-evaluation-documentation.md](../docs/hr-evaluation-documentation.md) — canonical reference for traits, values, rejection criteria, and the question bank

Final decision authority for any hire/reject outcome rests with HR OL
(Nitin Sir). This agent produces a scoring input — not a hiring decision.
