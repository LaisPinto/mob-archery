import 'package:mobx/mobx.dart';
import 'package:mob_archery/training/models/training_end_model.dart';
import 'package:mob_archery/training/models/training_session_model.dart';

class TrainingState {
  final ObservableList<TrainingSessionModel> sessions =
      ObservableList<TrainingSessionModel>();
  final ObservableList<TrainingEndModel> ends =
      ObservableList<TrainingEndModel>();
  final Observable<TrainingSessionModel?> selectedSession =
      Observable<TrainingSessionModel?>(null);
  final Observable<bool> isLoading = Observable<bool>(false);
  final Observable<String?> errorMessage = Observable<String?>(null);
  final Observable<String?> successMessage = Observable<String?>(null);
}
