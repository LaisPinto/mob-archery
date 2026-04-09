import 'package:mob_archery/timer/enums/timer_mode.dart';

class TimerConfigModel {
  const TimerConfigModel({
    required this.id,
    required this.name,
    required this.arrowsPerEnd,
    required this.endsPerRound,
    required this.rounds,
    required this.isABCD,
    required this.plusTenPerArrow,
    required this.timerMode,
    required this.isAccessibleMode,
  });

  final String id;
  final String name;
  final int arrowsPerEnd;
  final int endsPerRound;
  final int rounds;
  final bool isABCD;
  final bool plusTenPerArrow;
  final TimerMode timerMode;
  final bool isAccessibleMode;

  // Back-compat alias used by legacy callers
  int get arrows => arrowsPerEnd;

  int get totalArrows => arrowsPerEnd * endsPerRound * rounds;

  int get endTotalSeconds {
    final base = switch (timerMode) {
      TimerMode.competition => arrowsPerEnd == 3
          ? 120
          : arrowsPerEnd == 6
              ? 240
              : arrowsPerEnd * 30,
      TimerMode.perArrowThirtySeconds => arrowsPerEnd * 30,
    };
    final accessible = isAccessibleMode ? arrowsPerEnd * 10 : 0;
    final plusTen = plusTenPerArrow ? arrowsPerEnd * 10 : 0;
    return base + accessible + plusTen;
  }

  // Legacy alias
  int get totalSeconds => endTotalSeconds;

  TimerConfigModel copyWith({
    String? id,
    String? name,
    int? arrowsPerEnd,
    int? endsPerRound,
    int? rounds,
    bool? isABCD,
    bool? plusTenPerArrow,
    TimerMode? timerMode,
    bool? isAccessibleMode,
  }) {
    return TimerConfigModel(
      id: id ?? this.id,
      name: name ?? this.name,
      arrowsPerEnd: arrowsPerEnd ?? this.arrowsPerEnd,
      endsPerRound: endsPerRound ?? this.endsPerRound,
      rounds: rounds ?? this.rounds,
      isABCD: isABCD ?? this.isABCD,
      plusTenPerArrow: plusTenPerArrow ?? this.plusTenPerArrow,
      timerMode: timerMode ?? this.timerMode,
      isAccessibleMode: isAccessibleMode ?? this.isAccessibleMode,
    );
  }
}