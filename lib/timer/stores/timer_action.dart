import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mob_archery/accessibility/stores/accessibility_state.dart';
import 'package:mob_archery/timer/models/timer_config_model.dart';
import 'package:mob_archery/timer/services/timer_feedback_service.dart';
import 'package:mob_archery/timer/stores/timer_state.dart';

class TimerAction {
  TimerAction(
    this.state,
    this.accessibilityState,
    this.timerFeedbackService,
  ) {
    syncAccessibilityPreference();
  }

  final TimerState state;
  final AccessibilityState accessibilityState;
  final TimerFeedbackService timerFeedbackService;

  Timer? timer;

  void syncAccessibilityPreference() {
    final updatedConfig = state.config.value.copyWith(
      isAccessibleMode: accessibilityState.isAccessibleTimerEnabled.value,
    );
    runInAction(() {
      state.config.value = updatedConfig;
      state.remainingSeconds.value = updatedConfig.totalSeconds;
    });
  }

  void updateConfig(TimerConfigModel newConfig) {
    runInAction(() {
      state.config.value = newConfig;
      state.remainingSeconds.value = newConfig.totalSeconds;
      state.infoMessage.value = null;
    });
  }

  void start() {
    if (state.isRunning.value) {
      return;
    }

    if (state.remainingSeconds.value <= 0) {
      reset();
    }

    runInAction(() => state.isRunning.value = true);
    timer = Timer.periodic(const Duration(seconds: 1), (activeTimer) {
      final nextValue = state.remainingSeconds.value - 1;
      if (nextValue <= 0) {
        activeTimer.cancel();
        runInAction(() {
          state.remainingSeconds.value = 0;
          state.isRunning.value = false;
          state.infoMessage.value = 'Timer complete.';
        });
        timerFeedbackService.completion();
        timerFeedbackService.announce('Timer complete');
        return;
      }

      runInAction(() => state.remainingSeconds.value = nextValue);
      if (nextValue <= 10) {
        timerFeedbackService.warning();
      }
    });
  }

  void pause() {
    timer?.cancel();
    runInAction(() => state.isRunning.value = false);
  }

  void reset() {
    timer?.cancel();
    runInAction(() {
      state.isRunning.value = false;
      state.remainingSeconds.value = state.config.value.totalSeconds;
      state.infoMessage.value = null;
    });
  }

  void dispose() {
    timer?.cancel();
  }
}
