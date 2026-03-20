import 'package:mobx/mobx.dart';
import 'package:mob_archery/home/models/home_summary_model.dart';

class HomeState {
  final Observable<HomeSummaryModel> summary = Observable<HomeSummaryModel>(
    const HomeSummaryModel(
      sessionCount: 0,
      totalArrows: 0,
      averageScore: 0,
      totalXCount: 0,
    ),
  );
}
