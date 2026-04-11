import 'package:mob_archery/app/modules/training/enums/bow_type.dart';
import 'package:mob_archery/app/modules/training/enums/registered_by.dart';
import 'package:mob_archery/app/modules/training/models/training_end_model.dart';

class TrainingMetricsService {
  TrainingEndMetrics calculateEndMetrics(List<String> arrows) {
    int totalScore = 0;
    int xCount = 0;
    int tenCount = 0;
    final normalizedArrows = <String>[];

    for (final arrow in arrows) {
      final normalizedArrow = arrow.trim().toUpperCase();
      if (normalizedArrow == 'X') {
        normalizedArrows.add('X');
        totalScore += 10;
        xCount += 1;
        continue;
      }
      if (normalizedArrow == 'M') {
        normalizedArrows.add('M');
        continue;
      }

      final score = int.tryParse(normalizedArrow);
      if (score == null || score < 1 || score > 10) {
        throw FormatException('Invalid arrow score: $arrow');
      }

      normalizedArrows.add(score.toString());
      totalScore += score;
      if (score == 10) {
        tenCount += 1;
      }
    }

    return TrainingEndMetrics(
      arrows: normalizedArrows,
      totalScore: totalScore,
      averageScore: normalizedArrows.isEmpty
          ? 0.0
          : totalScore / normalizedArrows.length,
      xCount: xCount,
      tenCount: tenCount,
    );
  }

  TrainingEndModel buildEndModel({
    required String endId,
    required String sessionId,
    required String userId,
    required List<String> arrows,
    required double distance,
    required BowType bowType,
    required RegisteredBy registeredBy,
    required String? spotterName,
  }) {
    final metrics = calculateEndMetrics(arrows);

    return TrainingEndModel(
      endId: endId,
      sessionId: sessionId,
      userId: userId,
      arrows: metrics.arrows,
      averageScore: metrics.averageScore,
      xCount: metrics.xCount,
      tenCount: metrics.tenCount,
      distance: distance,
      bowType: bowType.name,
      registeredBy: registeredBy.name,
      spotterName: spotterName,
      createdAt: DateTime.now(),
    );
  }
}

class TrainingEndMetrics {
  const TrainingEndMetrics({
    required this.arrows,
    required this.totalScore,
    required this.averageScore,
    required this.xCount,
    required this.tenCount,
  });

  final List<String> arrows;
  final int totalScore;
  final double averageScore;
  final int xCount;
  final int tenCount;
}
