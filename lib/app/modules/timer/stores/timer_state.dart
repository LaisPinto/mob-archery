import 'package:mobx/mobx.dart';
import 'package:mob_archery/app/modules/timer/enums/timer_mode.dart';
import 'package:mob_archery/app/modules/timer/models/timer_config_model.dart';

class TimerState {
  // ── Saved configs (mock local persistence) ───────────────────────────
  final ObservableList<TimerConfigModel> savedConfigs =
      ObservableList.of(_defaultConfigs);

  // ── Active config for current run ────────────────────────────────────
  final Observable<TimerConfigModel?> activeConfig = Observable(null);

  // ── Execution state ───────────────────────────────────────────────────
  final Observable<int> remainingSeconds = Observable(240);
  final Observable<bool> isRunning = Observable(false);
  final Observable<int> currentRound = Observable(1);
  final Observable<int> currentEnd = Observable(1);
  final Observable<bool> isABPhase = Observable(true);
  final Observable<bool> isEndFinished = Observable(false);

  // ── Signal toggles ────────────────────────────────────────────────────
  final Observable<bool> soundEnabled = Observable(true);
  final Observable<bool> vibeEnabled = Observable(true);
  final Observable<bool> flashEnabled = Observable(false);

  // ── Messages ──────────────────────────────────────────────────────────
  final Observable<String?> infoMessage = Observable(null);

  // ── Legacy — kept for accessibility sync in TimerAction ───────────────
  final Observable<TimerConfigModel> config = Observable(
    const TimerConfigModel(
      id: '_default',
      name: '',
      arrowsPerEnd: 6,
      endsPerRound: 6,
      rounds: 1,
      isABCD: true,
      plusTenPerArrow: false,
      timerMode: TimerMode.competition,
      isAccessibleMode: false,
    ),
  );
}

const _defaultConfigs = [
  TimerConfigModel(
    id: 'wa_standard',
    name: 'Padrão WA – 18m',
    arrowsPerEnd: 3,
    endsPerRound: 6,
    rounds: 1,
    isABCD: true,
    plusTenPerArrow: false,
    timerMode: TimerMode.competition,
    isAccessibleMode: false,
  ),
  TimerConfigModel(
    id: 'indoor_fast',
    name: 'Indoor Rápido',
    arrowsPerEnd: 3,
    endsPerRound: 4,
    rounds: 1,
    isABCD: false,
    plusTenPerArrow: false,
    timerMode: TimerMode.competition,
    isAccessibleMode: false,
  ),
];