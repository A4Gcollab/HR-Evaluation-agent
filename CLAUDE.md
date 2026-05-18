# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

HR Evaluation Agent for Omysha Foundation. Evaluates interview candidates by analyzing transcripts and generating structured scoring reports.

## Architecture

Skill-based pipeline with one orchestrator and three sub-skills, plus one standalone:

```
0.evaluate-candidate/   orchestrator — coordinates pipeline. Owns the
                        Suhani-replacement decision logic: config-driven
                        autonomy + 3-level escalation hierarchy.
1.transcript-analyzer/  SINGLE read pass over the transcript. Emits a
                        structured "signal pool" with cross-cutting signals,
                        HR-Round parameters, and per-trait / per-value
                        evidence indexes.
2.natural-fit/          Scores 5 role-specific NF traits. Consumes the signal
                        pool — does NOT re-read the transcript. Owns the role
                        reference files (references/natural-fit-*.md).
3.org-fit-evaluator/    Scores 5 universal OF values. Consumes the signal pool.
5.report-generator/     Assembles the final report. Owns scripts/
                        (calculate-score.js, generate-docx.py,
                        report-template.md). Emits .docx + inline markdown.

justify-rejection/      Standalone on-demand rejection screening (H1–H5, S1–S7).
                        NOT part of the evaluate-candidate pipeline — invoked
                        separately via /justify-rejection.
```

The transcript is read **exactly once** (in 1.transcript-analyzer). Both scorers
operate on the structured signal pool — no duplicate scanning.

See `docs/architecture.md` for full system diagram and data flow.

## Key Files

- `config/evaluation.json` — Master config for scoring rules, autonomy settings, role configs
- `docs/hr-evaluation-documentation.md` — Single source of truth for all trait/value definitions
- `docs/project-overview.md` — PRD with requirements and success criteria
- `docs/architecture.md` — System architecture and decision point mapping
- `docs/interview-process.md` — Interview pipeline and agent workflow
- `docs/evaluation-framework.md` — Scoring philosophy, calibration, bias mitigation

## Design Principles

1. **Human-on-the-loop, not in-the-loop.** The agent executes autonomously within rules defined in `config/evaluation.json`. It only escalates genuine exceptions to the user.
2. **Configuration over conversation.** Rules that don't change per-candidate (thresholds, availability, defaults) live in config files, not chat.
3. **Round-gating.** Never score what wasn't assessed. No NF/OF scores without the actual round data.
4. **Separation of scoring and rejection.** Fit scores and rejection flags are independent concerns.
5. **Evidence-grounded scoring.** Every score cites a behavioral example. No score without evidence.
