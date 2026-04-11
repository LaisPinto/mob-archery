import 'package:mobx/mobx.dart';
import 'package:mob_archery/app/modules/home/services/home_summary_service.dart';
import 'package:mob_archery/app/modules/home/stores/home_state.dart';
import 'package:mob_archery/app/modules/training/stores/training_state.dart';

class HomeAction {
  HomeAction(
    this.state,
    this.homeSummaryService,
    this.trainingState,
  );

  final HomeState state;
  final HomeSummaryService homeSummaryService;
  final TrainingState trainingState;

  void refreshSummary() {
    runInAction(() {
      state.summary.value =
          homeSummaryService.buildSummary(trainingState.sessions.toList());
    });
  }
}
