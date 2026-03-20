import 'package:mob_archery/timer/enums/timer_mode.dart';

class TimerConfigModel {
  const TimerConfigModel({
    required this.arrows,
    required this.timerMode,
    required this.isAccessibleMode,
  });

  final int arrows;
  final TimerMode timerMode;
  final bool isAccessibleMode;

  int get totalSeconds {
    final baseSeconds = switch (timerMode) {
      TimerMode.competition => arrows == 3
          ? 120
          : arrows == 6
              ? 240
              : arrows * 30,
      TimerMode.perArrowThirtySeconds => arrows * 30,
    };

    final accessibleSeconds = isAccessibleMode ? arrows * 10 : 0;
    return baseSeconds + accessibleSeconds;
  }

  TimerConfigModel copyWith({
    int? arrows,
    TimerMode? timerMode,
    bool? isAccessibleMode,
  }) {
    return TimerConfigModel(
      arrows: arrows ?? this.arrows,
      timerMode: timerMode ?? this.timerMode,
      isAccessibleMode: isAccessibleMode ?? this.isAccessibleMode,
    );
  }
}
