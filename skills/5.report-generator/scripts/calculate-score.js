/**
 * Omysha Foundation — Candidate Evaluation Score Calculator
 *
 * Used by report-generator to compute final scores and recommendation.
 *
 * Inputs:
 *   naturalFitScores - array of 5 numbers (each 1–5)
 *   orgFitScores     - array of 5 numbers (each 1–5)
 *
 * Outputs:
 *   naturalFitAvg      - average of 5 NF trait scores (rounded to 1 decimal)
 *   orgFitAvg           - average of 5 OF value scores (rounded to 1 decimal)
 *   totalScore          - final score out of 10 (rounded to 1 decimal)
 *   scoreRecommendation - one of 5 recommendation labels
 */

function calculateScore(naturalFitScores, orgFitScores) {
  // Validate inputs
  if (naturalFitScores.length !== 5 || orgFitScores.length !== 5) {
    throw new Error("Both score arrays must contain exactly 5 values");
  }

  const allScores = [...naturalFitScores, ...orgFitScores];
  if (allScores.some(s => s < 1 || s > 5 || !Number.isFinite(s))) {
    throw new Error("All scores must be between 1 and 5");
  }

  // Calculate averages
  const sum = (arr) => arr.reduce((a, b) => a + b, 0);
  const naturalFitAvg = round1(sum(naturalFitScores) / 5);
  const orgFitAvg = round1(sum(orgFitScores) / 5);

  // Total Score: each dimension contributes 50%, total out of 10
  // Formula: ((NF avg + OF avg) / 2) * 2 = NF avg + OF avg
  const totalScore = round1(((naturalFitAvg + orgFitAvg) / 2) * 2);

  // Map score to recommendation
  const scoreRecommendation = getRecommendation(totalScore);

  return {
    naturalFitAvg,
    orgFitAvg,
    totalScore,
    scoreRecommendation
  };
}

function getRecommendation(totalScore) {
  if (totalScore >= 8.5) return "Recommended";
  if (totalScore >= 7.0) return "Can Be Considered";
  if (totalScore >= 5.5) return "Borderline";
  if (totalScore >= 3.5) return "Not Recommended";
  return "Strong No";
}

function round1(num) {
  return Math.round(num * 10) / 10;
}

// --- Test / Example Usage ---
// const result = calculateScore([4, 3, 5, 4, 3], [4, 4, 3, 5, 3]);
// console.log(result);
// Expected: { naturalFitAvg: 3.8, orgFitAvg: 3.8, totalScore: 7.6, scoreRecommendation: "Can Be Considered" }

module.exports = { calculateScore };
