---
name: justify-rejection
description: >
  Use this skill ONLY when a user explicitly asks about rejection criteria,
  disqualification reasons, or availability/commitment concerns for a candidate.
  Triggers on: "why was this candidate rejected", "justify the rejection",
  "check rejection criteria", "does this person have any red flags", "is there
  a reason to reject", "check availability requirements", "run rejection
  screening", or "would this candidate be disqualified". Do NOT trigger during
  standard evaluation — use evaluate-candidate for scoring reports instead.
---

# Justify Rejection — Omysha Foundation

On-demand rejection screening. This skill is separate from the standard evaluation
pipeline because Omysha Foundation's primary methodology is scoring candidates on
fit, not screening for disqualifiers. Use this only when specifically asked.

## When to use

- User asks why a candidate was rejected or should be rejected
- User wants to verify a specific candidate against hard/soft criteria
- User asks about availability, stipend, or commitment requirements
- User wants a rejection-focused analysis after seeing a scoring report

## On activation

1. **Read `docs/hr-evaluation-documentation.md` Section 2 now** — this contains
   all rejection criteria. Never hardcode criteria in this skill.

2. Receive or parse the transcript for the candidate in question.

3. Screen against Hard Rejection Criteria (H1–H5):

   | Code | Category | What triggers it |
   |------|----------|-----------------|
   | H1 | Stipend | Demands beyond range or refuses offered amount |
   | H2 | Availability — HR | Not available from 3 PM onwards (HR roles only) |
   | H3 | Availability — other | Not available 5–9 PM weekdays (non-HR roles) |
   | H4 | Duration | Cannot commit 6 months or clearly evasive |
   | H5 | Active conflict | Ongoing work overlaps hours, not confirmed leaving |

4. Screen against Soft Flag Criteria (S1–S7):

   | Code | Category | What triggers it |
   |------|----------|-----------------|
   | S1 | Stipend discomfort | Uncomfortable but not refusing — retention risk |
   | S2 | Poor communication | Persistent pattern, not just nerves |
   | S3 | No org awareness | Can't describe Omysha Foundation or mission |
   | S4 | Attitude/behavior | Arrogance, dismissiveness, negativity |
   | S5 | Value misalignment | Conflicts with organizational values |
   | S6 | Schedule instability | Variable schedule, excessive commitments |
   | S7 | Unresolved commitments | Other work, vague about prioritizing |

5. If a scoring report already exists for this candidate, cross-reference:
   any Org Fit value scored 1 may indicate S5 (value misalignment).

## Output format

For each triggered criterion:
- **Hard:** ⛔ **[CODE] ([Category]):** [exact evidence from transcript]
- **Soft:** ⚠️ **[CODE] ([Category]):** [evidence + risk note for HR OL]
- **Clean:** "No rejection criteria triggered based on transcript review."

Include a summary: how many hard rejections, how many soft flags, and whether
the hard rejections would override a scoring-based recommendation.

## Important

- Hard rejections are disqualifying regardless of how well a candidate scored
- Soft flags are advisory — HR OL (Nitin Sir) makes the final call
- Complete the full screening even if a hard rejection is found early
- Ambiguous evidence → flag as "Unclear — requires follow-up"
- This skill does not generate a full evaluation report — use `/evaluate-candidate` for that

## Calibration notes (HR OL input)

### H2 — HR Availability is strict (no flexibility for strong profiles)

For HR roles, **3 PM availability is a firm requirement**. Even a candidate who
is available only from 4 PM onwards triggers H2, regardless of how strong the
rest of the profile is. Contextual reasons (college timings, commute) may be
mentioned in the report for HR OL's awareness, but do **not** soften the H2
trigger. Availability failure is a critical limiting factor on its own.

### S7 — Applying to multiple opportunities / other placements

Candidates mentioning other ongoing applications or placement pipelines is
**not an automatic S7** — exploring multiple opportunities is normal candidate
behavior. Treat it as a **cautious signal** weighted into S7 only when:
- The candidate indicates they would likely accept another offer if received
- There is no clear expression of commitment to Omysha if selected
- The other pipelines suggest a high risk of early drop-off

When the candidate mentions other applications but expresses clear intent to
commit if selected here, note it in the report's motivation/commitment
observation but do NOT trigger S7.
