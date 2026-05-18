
# Product Requirements Document — HR Evaluation Agent
**Omysha Foundation | v1.0 | March 2026**

---

## 1. Problem Statement

Omysha Foundation interviews candidates across multiple roles (HR, Marketing, Community, Product, Project) through a 3-round process: Group Discussion, HR Round, and Natural Fit + Organizational Fit Round. After each interview batch, the HR team (primarily Suhani and Sushma) manually:

- Re-reads entire interview transcripts (often 60–90 minutes of Zoom recordings)
- Extracts behavioral signals from unstructured conversation data
- Scores each candidate against 5 role-specific Natural Fit traits and 5 universal Organizational Fit values
- Computes composite scores and maps them to recommendation tiers
- Writes structured evaluation reports for HR OL (Nitin Sir) to make final decisions
- Cross-references availability, stipend, and commitment against rejection criteria

This process takes 2–4 hours per candidate batch and is error-prone due to cognitive load, inconsistent scoring across evaluators, and the difficulty of holding multiple trait definitions in memory while reading transcripts.

**The agent eliminates this manual work.** Suhani pastes a transcript, and the agent produces a complete, structured evaluation report in minutes — scored, formatted, and ready for Nitin Sir's review.

---

## 2. Users and Personas

| User | Role | Interaction with Agent | Decision Authority |
|------|------|----------------------|-------------------|
| **Suhani** | HR Lead / Primary Operator | Pastes transcripts, configures evaluation rules, reviews reports | Defines workflows and evaluation standards |
| **Sushma** | HR Associate / Interviewer | Conducts interviews, provides transcripts, may paste transcripts | Provides interview context when asked |
| **Nausheen** | Interviewer (NF/OF rounds) | Conducts fit assessment rounds | None — input captured in transcripts |
| **Nitin Sir** | HR OL / Final Decision Maker | Receives reports, makes hire/reject decisions | Final authority on all hiring |

### Primary user journey (target state)
Suhani's interaction should be:
1. Configure evaluation rules once (availability windows, scoring thresholds, role configs)
2. Paste transcript → agent runs autonomously
3. Review final report → forward to Nitin Sir
4. Intervene only when agent flags an exception

---

## 3. Functional Requirements

### 3.1 Core Capabilities

| ID | Requirement | Status |
|----|------------|--------|
| FR-1 | Parse interview transcripts (Zoom VTT, AI Companion, Q&A format, summary notes) | Implemented |
| FR-2 | Identify all candidates in a multi-candidate transcript | Implemented |
| FR-3 | Extract behavioral signals across 5 categories (communication, confidence, org awareness, attitude, quality) | Implemented |
| FR-4 | Score Natural Fit: 5 role-specific traits, 1–5 scale, with HR observations | Implemented |
| FR-5 | Score Organizational Fit: 5 universal values, 1–5 scale, with HR observations | Implemented |
| FR-6 | Compute Total Score (NF + OF, out of 10) and map to recommendation tier | Implemented |
| FR-7 | Generate .docx evaluation report with standardized template | Implemented |
| FR-8 | Multi-candidate comparison with ranked summary table | Implemented |
| FR-9 | On-demand rejection screening (H1–H5 hard, S1–S7 soft) via /justify-rejection | Implemented |
| FR-10 | Round-gating: only score dimensions for which actual round data exists | Implemented |

### 3.2 Configuration Capabilities (needed for on-the-loop)

| ID | Requirement | Status |
|----|------------|--------|
| FR-11 | Configurable availability windows per role (e.g., HR: 3 PM+, Others: 5–9 PM) | Needed |
| FR-12 | Configurable scoring thresholds for recommendation tiers | Needed |
| FR-13 | Configurable rejection criteria with enable/disable per criterion | Needed |
| FR-14 | Role-specific default configs (which reference file, which traits, availability rule) | Needed |
| FR-15 | Escalation rules: when to pause and ask HR vs. auto-resolve with defaults | Needed |

### 3.3 Autonomy Capabilities (needed for on-the-loop)

| ID | Requirement | Status |
|----|------------|--------|
| FR-16 | Auto-resolve insufficient evidence with configured default score instead of always asking | Needed |
| FR-17 | Auto-detect role from transcript context when not explicitly stated | Partial |
| FR-18 | Auto-apply rejection screening as part of pipeline (configurable) | Needed |
| FR-19 | Exception-only escalation: only pause for boundary scores (within 0.3 of tier) or genuine ambiguity | Needed |
| FR-20 | Batch processing: handle multiple transcripts in sequence without per-candidate confirmation | Needed |

---

## 4. Non-Functional Requirements

| ID | Requirement | Target |
|----|------------|--------|
| NFR-1 | Report generation time | < 5 minutes per candidate batch |
| NFR-2 | Scoring consistency | Same transcript should produce same scores (within 0.2 variance) across runs |
| NFR-3 | Evidence grounding | Every score must cite a specific behavioral example — no unsupported ratings |
| NFR-4 | Transcript format flexibility | Support Zoom VTT, AI Companion, Q&A notes, and free-form summary |
| NFR-5 | Role coverage | Production-ready traits for HR; placeholder traits for 5 other roles |
| NFR-6 | Data confidentiality | Reports marked confidential; no candidate data persisted beyond reports |

---

## 5. What This Agent Does NOT Do

- **Does not make hiring decisions.** Final authority is always Nitin Sir.
- **Does not replace the interview process.** It evaluates transcripts after interviews happen.
- **Does not contact candidates.** It produces reports for internal HR use only.
- **Does not store candidate data long-term.** Reports are generated and saved to `data/evaluation-reports/`; no database.
- **Does not auto-reject.** Hard rejection flags are advisory inputs to the report, not automated actions.

---

## 6. Success Criteria

| Metric | Baseline (manual) | Target (with agent) |
|--------|-------------------|---------------------|
| Time per candidate batch | 2–4 hours | < 10 minutes |
| Scoring consistency across batches | Variable (evaluator-dependent) | Within 0.2 points for same evidence |
| HR interventions per batch | Continuous (every decision) | < 3 exception escalations |
| Report completeness | Sometimes missing sections | 100% template coverage |
| Rejection criteria coverage | Sometimes forgotten | 100% automated screening |

---

## 7. Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Agent scores differently than Suhani would | Trust erosion, unusable reports | Calibration sessions: Suhani scores a candidate manually, compares with agent output, adjusts reference files |
| Transcript quality too poor to score | False low scores | Transcript quality detection + escalation when quality is below threshold |
| Placeholder role traits used for real evaluations | Inaccurate NF scores | Warn user prominently; block scoring until traits are validated (configurable) |
| Over-reliance on agent | HR loses evaluative judgment | Agent produces reports, not decisions; Suhani reviews every report |
| Bias in scoring | Unfair candidate treatment | Evidence-grounding requirement; no score without behavioral example |

---

## 7A. Organizational Context (HR OL calibration input)

The following context from HR OL shapes how the agent interprets candidate
signals. It is reference data — the agent does not directly read this section
at runtime, but the corresponding scoring and flagging logic has been
distributed into the relevant skill files.

### Team sizes per role (current)

There is no fixed headcount or batch size — hiring flexes with organizational
needs and applicant volume. Current distribution:

| Function | Members |
|----------|---------|
| HR / OPM (Enablers) | ~3 PMs + ~3 HR-OPMs |
| Marketing — Branding | ~2 |
| Marketing — Lead Gen | ~2 |
| Marketing — PR | ~1 |
| Marketing — Growth | ~3 |
| RAB (Research & Analysis) | ~3 (across areas) |
| CB (Community Building) | ~3 (across 3 circles) |
| Tech | ~3 |

### HR intern day-to-day

HR/OPM interns are **hands-on from week one** — this shapes what "fit" looks
like. Day-to-day responsibilities include:
- Attending and chairing meetings
- Acting as HRBP for assigned team members
- Tracking performance, attendance, and leaves
- Managing coordination and communication

Over the first few weeks to a month, responsibilities expand to include
onboarding processes, appraisals and performance tracking, stipend coordination,
interview and hiring support, action planning and execution, and participation
in town halls and organizational initiatives. The role is **highly ownership-
driven from the start** — this is why passive/dependent work styles (see
Ownership red flags in `3.org-fit-evaluator`) are retention risks.

### Why interns leave early / underperform

The most common cause is a **mismatch in expectations around working style** —
candidates who expect step-by-step guidance or are uncomfortable with
independent thinking tend to struggle. Work styles that don't align with
Omysha, even if they score well on paper:
- Heavy reliance on constant direction or structured instructions
- Not proactive in thinking or decision-making
- Preference for passive execution over ownership

The agent is tuned to flag these signals in the Ownership & Alignment value
(see `3.org-fit-evaluator/SKILL.md`).

### When Nitin Sir overrides a recommendation

Overrides are based on deeper review — resume and background beyond the
transcript, additional interpretation, long-term potential, and judgment from
experience. These are not arbitrary and do not indicate the report was wrong.
The agent's role remains: produce an honest, evidence-grounded report.
Nitin Sir adds the layers the transcript alone cannot provide.

---

## 8. Roadmap

### Phase 1 — Current (Implemented)
- Core evaluation pipeline (transcript → signals → scores → report)
- HR role fully validated; other roles placeholder
- Human-in-the-loop: Suhani answers clarifying questions during evaluation

### Phase 2 — Next (This Sprint)
- System documentation (PRD, architecture, workflows)
- Configuration layer for evaluation rules
- Human-on-the-loop redesign: auto-resolve with defaults, escalate exceptions only
- Evaluation framework doc completed

### Phase 3 — Future
- Validate trait definitions for Marketing, Community, Product, Project roles
- Calibration workflow: compare agent scores vs. manual scores
- Batch processing mode for multiple transcript files
- Feedback loop: Nitin Sir's decisions feed back to refine scoring