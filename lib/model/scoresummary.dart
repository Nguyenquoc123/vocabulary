class ScoreSummary {
  final int totalAttempts;
  final int totalScore;

  ScoreSummary({
    required this.totalAttempts,
    required this.totalScore,
  });

  factory ScoreSummary.fromJson(Map<String, dynamic> json) {
    return ScoreSummary(
      totalAttempts: int.parse(json["total_attempts"].toString()),
      totalScore: int.parse(json["total_score"].toString()),
    );
  }
}
