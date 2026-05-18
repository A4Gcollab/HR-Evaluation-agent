# Evaluation Framework
**Omysha Foundation | v1.0 | March 2026**

---

## Philosophy

The HR Evaluation Agent scores candidates on **observed behavioral evidence**, not on impressions, assumptions, or theoretical answers. Every score must be grounded in something the candidate actually said or did during the interview.

Core principles:
1. **Evidence over impression.** A score without a cited behavioral example is invalid.
2. **Score what was assessed.** Never extrapolate NF/OF scores from rounds that weren't conducted (round-gating).
3. **Separation of concerns.** Scoring (fit evaluation) and rejection (disqualifier screening) are independent processes. Rejection flags do not influence fit scores.
4. **Conservative by default.** When evidence is insufficient, the agent scores low (default: 2) and says so — it does not assume alignment.
5. **Reports inform, humans decide.** The agent produces a scoring input. Nitin Sir (HR OL) makes all hiring decisions.

---

## Competency Model

Candidates are assessed on two independent dimensions:

### Natural Fit (NF) — "Can they do this role well?"
5 role-specific traits that measure suitability for the applied position.
- Traits vary by role (HR, Marketing, Community, Product, Project)
- Defined in `skills/2.natural-fit/references/natural-fit-[role].md`
- Full definitions in `hr-evaluation-documentation.md` Sections 4–5

### Organizational Fit (OF) — "Do they align with our values?"
5 universal values assessed for every candidate regardless of role:
1. Ownership and Alignment
2. Respect and Acceptance
3. Innovation and Imagination
4. Agility
5. Integrity and Authenticity

Defined in `hr-evaluation-documentation.md` Section 3.

---

## Scoring System

### Rating scale (1–5)

| Score | Label | When to assign |
|-------|-------|---------------|
| 5 | Exceptional | Multiple strong behavioral signals with specific, detailed examples |
| 4 | Good | Clear evidence present, consistent signals across transcript |
| 3 | Adequate | Some evidence, meets baseline expectations but limited depth |
| 2 | Weak | Minimal or indirect evidence; also used for insufficient data |
| 1 | Poor | No meaningful evidence, or signal actively contradicts the trait/value |

**Important distinctions:**
- A neutral or absent response is a **2** (Weak), not a **3**. Alignment requires positive evidence.
- Score **2** is the default when evidence is insufficient. This prevents false precision.
- Score **5** requires multiple strong signals — a single good answer is a **4** at most.
- Score **1** requires active contradiction — absence of evidence alone is a **2**.

### Calibration guidance
- **Across candidates in a batch:** Maintain consistent standards. If two candidates give similar-quality answers for the same trait, they should receive the same score.
- **Across batches over time:** Reference the score indicators in the role files. Scores should be comparable across different evaluation sessions.
- **When in doubt:** Score conservatively (lower) and note the uncertainty. It's better to underscore and have Nitin Sir upgrade than to overscore and miss a concern.

---

## Weighting

### Total Score calculation

```
Natural Fit Average  = sum(5 NF trait scores) / 5
Org Fit Average      = sum(5 OF value scores) / 5
Total Score          = (NF Average + OF Average) / 2 × 2
                     = NF Average + OF Average  (out of 10)
```

Both dimensions contribute equally (50/50 weight). This is configurable in
`config/evaluation.json` under `scoring.nf_weight` and `scoring.of_weight`.

### Recommendation tiers

| Score Range | Recommendation | Meaning |
|-------------|---------------|---------|
| 8.5 – 10.0 | Recommended | Strong fit across both dimensions |
| 7.0 – 8.4 | Can Be Considered | Solid performance with minor gaps |
| 5.5 – 6.9 | Borderline | Mixed signals — HR OL should review carefully |
| 3.5 – 5.4 | Not Recommended | Significant concerns in one or both dimensions |
| Below 3.5 | Strong No | Weak evidence across the board |

Thresholds are configurable in `config/evaluation.json` under
`scoring.recommendation_thresholds`.

### Boundary flag
Candidates whose Total Score falls within `tier_boundary_threshold` (default: 0.3
points) of a tier boundary are flagged: "Score near tier boundary — recommend HR OL
review." This prevents mechanical cutoffs from overriding nuanced judgment.

---

## Bias Mitigation

### Structural safeguards
1. **Evidence requirement.** Every score must cite a behavioral example. This prevents "gut feeling" scoring.
2. **Round-gating.** Prevents scoring candidates on dimensions that weren't assessed — eliminating inference bias.
3. **Separation of scoring and rejection.** Knowing a candidate has a hard-rejection flag could bias the scorer to give lower fit scores. These are kept separate.
4. **Consistent trait definitions.** All candidates for the same role are scored against the same trait definitions from the same reference file.

### Operational safeguards
5. **Conservative defaults.** Insufficient evidence scores 2, not 3. This prevents the agent from giving "benefit of the doubt" scores that inflate ratings.
6. **No verbatim quotes.** Reports use third-person behavioral observations, not candidate quotes. This reduces anchoring on specific phrases.
7. **Multi-candidate consistency.** When evaluating a batch, the agent holds the same standard across all candidates. A behavior that earns a 4 for one candidate must earn a 4 for another.

### Known limitations
- The agent scores based on transcript content only. In-person cues (body language, tone, energy) are not captured unless the interviewer notes them.
- Transcript quality varies — auto-transcription may misattribute speakers or garble content. The agent flags quality issues but cannot fully compensate.
- Placeholder role traits (Marketing, Community, Product, Project) have not been calibrated. Scores using these traits should be treated as directional, not precise.

---

## Framework Versioning

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | March 2026 | Initial framework: 2-dimension model, 1-5 scale, 50/50 weighting, config-driven thresholds |

### When to update this framework
- After a calibration session reveals systematic scoring discrepancies
- When a new role's traits are validated and moved from placeholder to production
- When Nitin Sir's decisions consistently diverge from agent recommendations (threshold tuning)
- When the interview process structure changes (new rounds, different question banks)

### How to update
1. Update this document with the change
2. Update `config/evaluation.json` if thresholds or weights changed
3. Update role reference files if trait definitions changed
4. Update `hr-evaluation-documentation.md` if value definitions or questions changed
5. Increment version number and add to the table above
