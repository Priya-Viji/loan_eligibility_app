class LoanResultEntity {
  final bool isEligible;
  final String riskLevel;
  final String suggestion;
  final int score;

  const LoanResultEntity({
    required this.isEligible,
    required this.riskLevel,
    required this.suggestion,
    required this.score,
  });
}
