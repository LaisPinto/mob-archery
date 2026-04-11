import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mob_archery/app/modules/accessibility/stores/accessibility_state.dart';
import 'package:mob_archery/app/modules/timer/models/timer_config_model.dart';
import 'package:mob_archery/app/modules/timer/services/timer_feedback_service.dart';
import 'package:mob_archery/app/modules/timer/stores/timer_state.dart';

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

  Timer? _timer;

  // ── Accessibility sync (legacy) ───────────────────────────────────────

  void syncAccessibilityPreference() {
    final updated = state.config.value.copyWith(
      isAccessibleMode: accessibilityState.isAccessibleTimerEnabled.value,
    );
    runInAction(() {
      state.config.value = updated;
      state.remainingSeconds.value = updated.totalSeconds;
    });
  }

  // ── Config CRUD ───────────────────────────────────────────────────────

  void saveConfig(TimerConfigModel config) {
    runInAction(() {
      final idx = state.savedConfigs.indexWhere((c) => c.id == config.id);
      if (idx >= 0) {
        state.savedConfigs[idx] = config;
      } else {
        state.savedConfigs.add(config);
      }
    });
  }

  void deleteConfig(String id) {
    runInAction(() => state.savedConfigs.removeWhere((c) => c.id == id));
  }

  void duplicateConfig(TimerConfigModel original) {
    final copy = original.copyWith(
      id: 'copy_${DateTime.now().millisecondsSinceEpoch}',
      name: '${original.name} (cópia)',
    );
    runInAction(() => state.savedConfigs.add(copy));
  }

  // ── Execution ─────────────────────────────────────────────────────────

  void startTimer(TimerConfigModel config) {
    _timer?.cancel();
    final withA11y = config.copyWith(
      isAccessibleMode: accessibilityState.isAccessibleTimerEnabled.value,
    );
    runInAction(() {
      state.activeConfig.value = withA11y;
      state.currentRound.value = 1;
      state.currentEnd.value = 1;
      state.isABPhase.value = true;
      state.remainingSeconds.value = withA11y.endTotalSeconds;
      state.isRunning.value = false;
      state.isEndFinished.value = false;
      state.infoMessage.value = null;
    });
  }

  void start() {
    if (state.isRunning.value || state.isEndFinished.value) return;

    runInAction(() => state.isRunning.value = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = state.remainingSeconds.value - 1;
      if (next <= 0) {
        t.cancel();
        runInAction(() {
          state.remainingSeconds.value = 0;
          state.isRunning.value = false;
          state.isEndFinished.value = true;
          state.infoMessage.value = 'End finalizado';
        });
        if (state.soundEnabled.value) {
          timerFeedbackService.playCompletionSound();
        }
        if (state.vibeEnabled.value) {
          timerFeedbackService.vibeCompletion();
        }
        if (state.flashEnabled.value) {
          timerFeedbackService.flashCompletion();
        }
        timerFeedbackService.announce('End finalizado');
        return;
      }
      runInAction(() => state.remainingSeconds.value = next);
      // Aviso amber: flash único ao entrar nos últimos 30s
      if (next == 30 && state.flashEnabled.value) {
        timerFeedbackService.flash();
      }
      if (next <= 10) {
        if (state.soundEnabled.value) {
          timerFeedbackService.playWarningSound();
        }
        if (state.vibeEnabled.value) {
          timerFeedbackService.vibeWarning();
        }
        if (state.flashEnabled.value) {
          timerFeedbackService.flash();
        }
      }
    });
  }

  void pause() {
    _timer?.cancel();
    runInAction(() => state.isRunning.value = false);
  }

  void nextEnd() {
    _timer?.cancel();
    final config = state.activeConfig.value;
    if (config == null) return;

    runInAction(() {
      state.isRunning.value = false;
      state.isEndFinished.value = false;
      state.infoMessage.value = null;

      if (config.isABCD) {
        state.isABPhase.value = !state.isABPhase.value;
      }

      final nextEnd = state.currentEnd.value + 1;
      if (nextEnd > config.endsPerRound) {
        final nextRound = state.currentRound.value + 1;
        if (nextRound > config.rounds) {
          state.isEndFinished.value = true;
          state.infoMessage.value = 'Treino concluído!';
          return;
        }
        state.currentRound.value = nextRound;
        state.currentEnd.value = 1;
      } else {
        state.currentEnd.value = nextEnd;
      }

      state.remainingSeconds.value = config.endTotalSeconds;
    });
  }

  void reset() {
    _timer?.cancel();
    final config = state.activeConfig.value ?? state.config.value;
    runInAction(() {
      state.isRunning.value = false;
      state.remainingSeconds.value = config.endTotalSeconds;
      state.isEndFinished.value = false;
      state.infoMessage.value = null;
    });
  }

  void toggleSound() =>
      runInAction(() => state.soundEnabled.value = !state.soundEnabled.value);

  void toggleVibe() =>
      runInAction(() => state.vibeEnabled.value = !state.vibeEnabled.value);

  void toggleFlash() =>
      runInAction(() => state.flashEnabled.value = !state.flashEnabled.value);

  // ── Legacy compat ─────────────────────────────────────────────────────

  void updateConfig(TimerConfigModel newConfig) {
    runInAction(() {
      state.config.value = newConfig;
      state.remainingSeconds.value = newConfig.totalSeconds;
      state.infoMessage.value = null;
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}