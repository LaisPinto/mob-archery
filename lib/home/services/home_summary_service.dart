import 'package:mob_archery/home/models/home_summary_model.dart';
import 'package:mob_archery/training/models/training_session_model.dart';

class HomeSummaryService {
  HomeSummaryModel buildSummary(List<TrainingSessionModel> sessions) {
    if (sessions.isEmpty) {
      return const HomeSummaryModel(
        sessionCount: 0,
        totalArrows: 0,
        averageScore: 0,
        totalXCount: 0,
      );
    }

    final totalArrows =
        sessions.fold<int>(0, (total, session) => total + session.totalArrows);
    final totalXCount =
        sessions.fold<int>(0, (total, session) => total + session.xCount);
    final weightedScore = sessions.fold<double>(
      0,
      (total, session) => total + (session.averageScore * session.totalArrows),
    );
    final averageScore = totalArrows == 0 ? 0.0 : weightedScore / totalArrows;

    return HomeSummaryModel(
      sessionCount: sessions.length,
      totalArrows: totalArrows,
      averageScore: averageScore,
      totalXCount: totalXCount,
    );
  }
}
