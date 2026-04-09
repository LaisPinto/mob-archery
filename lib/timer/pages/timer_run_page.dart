import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/timer/stores/timer_action.dart';
import 'package:mob_archery/timer/stores/timer_state.dart';

class TimerRunPage extends StatelessWidget {
  const TimerRunPage({super.key});

  static String _fmt(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final timerState = Modular.get<TimerState>();
    final timerAction = Modular.get<TimerAction>();
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return Observer(
      builder: (_) {
        final config = timerState.activeConfig.value;
        final remaining = timerState.remainingSeconds.value;
        final isRunning = timerState.isRunning.value;
        final isFinished = timerState.isEndFinished.value;
        final round = timerState.currentRound.value;
        final end = timerState.currentEnd.value;
        final endsPerRound = config?.endsPerRound ?? 6;
        final rounds = config?.rounds ?? 1;
        final isABCD = config?.isABCD ?? false;
        final isABPhase = timerState.isABPhase.value;
        final plusTen = config?.plusTenPerArrow ?? false;
        final infoMessage = timerState.infoMessage.value;

        // ── Color state ────────────────────────────────────────────────
        final timerColor = isFinished
            ? const Color(0xFFEF4444)
            : remaining <= 30
            ? const Color(0xFFFFA000)
            : c.textPrimary;

        final circleColor = isFinished
            ? const Color(0xFFEF4444)
            : remaining <= 30
            ? const Color(0xFFFFA000)
            : const Color(0xFFE2E8F0);

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8FAFC),
            elevation: 0,
            leading: BackButton(
              onPressed: () {
                timerAction.pause();
                Modular.to.navigate('/timer/');
              },
            ),
            title: Text(
              'Elite Archery',
              style: TextStyle(
                color: c.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ── Round / End badge ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFE6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      rounds > 1
                          ? 'ROUND $round/$rounds  |  END $end/$endsPerRound'
                          : 'END $end/$endsPerRound',
                      style: const TextStyle(
                        color: Color(0xFFFF5C00),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Shooting phase ───────────────────────────────────
                  if (isABCD)
                    Text(
                      'Shooting Phase: ${isABPhase ? 'AB' : 'CD'}',
                      style: const TextStyle(
                        color: Color(0xFF6B7A99),
                        fontSize: 17,
                      ),
                    ),

                  // ── +10s badge ───────────────────────────────────────
                  if (plusTen) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '+10s Adicionados/Flecha',
                        style: TextStyle(
                          color: Color(0xFF1D4ED8),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Timer circle ─────────────────────────────────────
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: circleColor, width: 8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isFinished) ...[
                          Icon(
                            Icons.timer_off_outlined,
                            color: timerColor,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            infoMessage ?? 'End finalizado',
                            style: TextStyle(
                              color: timerColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ] else ...[
                          Text(
                            _fmt(remaining),
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w900,
                              color: timerColor,
                            ),
                          ),
                          if (remaining <= 30 && remaining > 0) ...[
                            const SizedBox(height: 6),
                            Text(
                              'AMBER WARNING',
                              style: TextStyle(
                                color: timerColor,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Signal buttons ───────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SignalButton(
                        icon: Icons.volume_up_outlined,
                        label: 'SOUND',
                        active: timerState.soundEnabled.value,
                        onTap: timerAction.toggleSound,
                      ),
                      const SizedBox(width: 18),
                      _SignalButton(
                        icon: Icons.vibration_rounded,
                        label: 'VIBE',
                        active: timerState.vibeEnabled.value,
                        onTap: timerAction.toggleVibe,
                      ),
                      const SizedBox(width: 18),
                      _SignalButton(
                        icon: Icons.flash_on_rounded,
                        label: 'FLASH',
                        active: timerState.flashEnabled.value,
                        onTap: timerAction.toggleFlash,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ── Action buttons ───────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: isFinished
                              ? null
                              : (isRunning
                                    ? timerAction.pause
                                    : timerAction.start),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE3EAF4),
                            foregroundColor: const Color(0xFF1A2238),
                            disabledBackgroundColor: const Color(
                              0xFFE3EAF4,
                            ).withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(
                            isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(isRunning ? 'Pausar' : 'Iniciar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: timerAction.nextEnd,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5C00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.skip_next_rounded),
                          label: const Text('Próximo End'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignalButton extends StatelessWidget {
  const _SignalButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: active ? const Color(0xFFFF5C00) : const Color(0xFFE6EBF2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : const Color(0xFF8E9CB4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7A99),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
