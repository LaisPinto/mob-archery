import 'package:mobx/mobx.dart';
import 'package:mob_archery/accessibility/services/accessibility_feedback_service.dart';
import 'package:mob_archery/accessibility/stores/accessibility_state.dart';

class AccessibilityAction {
  AccessibilityAction(this.state, this.feedbackService);

  final AccessibilityState state;
  final AccessibilityFeedbackService feedbackService;

  Future<void> toggleHighContrast(bool value) async {
    runInAction(() => state.isHighContrastEnabled.value = value);
    await _feedback('High contrast ${value ? 'enabled' : 'disabled'}');
  }

  Future<void> toggleDarkMode(bool value) async {
    runInAction(() => state.isDarkModeEnabled.value = value);
    await _feedback('Dark mode ${value ? 'enabled' : 'disabled'}');
  }

  Future<void> toggleScreenReaderAnnouncements(bool value) async {
    runInAction(() => state.isScreenReaderAnnouncementsEnabled.value = value);
    await _feedback('Announcements ${value ? 'enabled' : 'disabled'}');
  }

  Future<void> toggleHapticFeedback(bool value) async {
    runInAction(() => state.isHapticFeedbackEnabled.value = value);
    await _feedback('Haptic feedback ${value ? 'enabled' : 'disabled'}');
  }

  Future<void> toggleFlash(bool value) async {
    runInAction(() => state.isFlashEnabled.value = value);
    await _feedback('Flash alert ${value ? 'enabled' : 'disabled'}');
  }

  Future<void> toggleAccessibleTimer(bool value) async {
    runInAction(() => state.isAccessibleTimerEnabled.value = value);
    await _feedback('Accessible timer ${value ? 'enabled' : 'disabled'}');
  }

  void setTextScale(double value) {
    runInAction(() => state.textScaleFactor.value = value.clamp(0.8, 2.0));
  }

  Future<void> _feedback(String message) async {
    if (state.isHapticFeedbackEnabled.value) {
      await feedbackService.haptic();
    }
    if (state.isScreenReaderAnnouncementsEnabled.value) {
      await feedbackService.announce(message);
    }
  }
}
