class HomeSummaryModel {
  const HomeSummaryModel({
    required this.sessionCount,
    required this.totalArrows,
    required this.averageScore,
    required this.totalXCount,
  });

  final int sessionCount;
  final int totalArrows;
  final double averageScore;
  final int totalXCount;
}
