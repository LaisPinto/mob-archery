import 'package:mobx/mobx.dart';

class AccessibilityState {
  final Observable<bool> isHighContrastEnabled = Observable<bool>(false);
  final Observable<bool> isDarkModeEnabled = Observable<bool>(false);
  final Observable<bool> isScreenReaderAnnouncementsEnabled =
      Observable<bool>(true);
  final Observable<bool> isHapticFeedbackEnabled = Observable<bool>(true);
  final Observable<bool> isFlashEnabled = Observable<bool>(false);
  final Observable<bool> isAccessibleTimerEnabled = Observable<bool>(false);
  final Observable<double> textScaleFactor = Observable<double>(1.0);
}
