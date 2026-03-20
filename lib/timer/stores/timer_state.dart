import 'package:mobx/mobx.dart';
import 'package:mob_archery/timer/enums/timer_mode.dart';
import 'package:mob_archery/timer/models/timer_config_model.dart';

class TimerState {
  final Observable<TimerConfigModel> config = Observable<TimerConfigModel>(
    const TimerConfigModel(
      arrows: 6,
      timerMode: TimerMode.competition,
      isAccessibleMode: false,
    ),
  );
  final Observable<int> remainingSeconds = Observable<int>(240);
  final Observable<bool> isRunning = Observable<bool>(false);
  final Observable<String?> infoMessage = Observable<String?>(null);
}
