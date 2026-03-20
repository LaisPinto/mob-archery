import 'package:mobx/mobx.dart';

class AccessibilityState {
  final Observable<bool> isHighContrastEnabled = Observable<bool>(false);
  final Observable<bool> isAccessibleTimerEnabled = Observable<bool>(false);
  final Observable<bool> isScreenReaderAnnouncementsEnabled =
      Observable<bool>(true);
  final Observable<bool> isHapticFeedbackEnabled = Observable<bool>(true);
}
