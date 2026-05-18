# Scoring Calculation Verification

## Test Case

**Natural Fit Scores:** 4, 3, 5, 4, 3
**Org Fit Scores:** 4, 4, 3, 5, 3

---

## Expected Calculation

```
Natural Fit Average = (4 + 3 + 5 + 4 + 3) / 5
                    = 19 / 5
                    = 3.8

Org Fit Average     = (4 + 4 + 3 + 5 + 3) / 5
                    = 19 / 5
                    = 3.8

Total Score         = ((3.8 + 3.8) / 2) × 2
                    = (7.6 / 2) × 2
                    = 3.8 × 2
                    = 7.6

Total Score: 7.6 / 10
```

---

## Recommendation Mapping

| Score Range | Recommendation |
|-------------|----------------|
| 8.5 – 10.0 | Recommended |
| 7.0 – 8.4  | Can Be Considered |
| 5.5 – 6.9  | Borderline |
| 3.5 – 5.4  | Reject |
| Below 3.5  | Strong Reject |

**7.6 falls in 7.0 – 8.4 → Can Be Considered ✓**

---

## Verification: calculate-score.js Output

```js
calculateScore([4, 3, 5, 4, 3], [4, 4, 3, 5, 3])
// → { naturalFitAvg: 3.8, orgFitAvg: 3.8, totalScore: 7.6, scoreRecommendation: "Can Be Considered" }
```

**Status: PASS**
