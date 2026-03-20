import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/timer/stores/timer_action.dart';
import 'package:mob_archery/timer/stores/timer_state.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  String _formatSeconds(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final timerState = Modular.get<TimerState>();
    final timerAction = Modular.get<TimerAction>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
      appBar: AppBar(
        leading: BackButton(onPressed: () => Modular.to.navigate('/home/')),
        title: const Text('Elite Archery'),
        actions: [
          IconButton(
            onPressed: () => Modular.to.pushNamed('/timer/config'),
            icon: const Icon(Icons.info_outline_rounded, color: Color(0xFFFF5C00)),
          ),
        ],
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final remaining = timerState.remainingSeconds.value;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFE6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'ROUND 1  |  END 3/6',
                      style: TextStyle(
                        color: Color(0xFFFF5C00),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Shooting Phase: AB',
                    style: TextStyle(color: Color(0xFF6B7A99), fontSize: 18),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFA000),
                        width: 10,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatSeconds(remaining),
                          style: const TextStyle(
                            fontSize: 74,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFA000),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'AMBER WARNING',
                          style: TextStyle(
                            color: Color(0xFFFFA000),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _SignalButton(
                        icon: Icons.volume_up_outlined,
                        label: 'SOUND',
                        active: true,
                      ),
                      SizedBox(width: 18),
                      _SignalButton(
                        icon: Icons.vibration_rounded,
                        label: 'VIBE',
                        active: true,
                      ),
                      SizedBox(width: 18),
                      _SignalButton(
                        icon: Icons.flash_off_outlined,
                        label: 'FLASH',
                        active: false,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: timerState.isRunning.value
                              ? timerAction.pause
                              : timerAction.start,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE3EAF4),
                            foregroundColor: const Color(0xFF1A2238),
                          ),
                          icon: Icon(
                            timerState.isRunning.value
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(timerState.isRunning.value ? 'Pause' : 'Start'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: timerAction.reset,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5C00),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.skip_next_rounded),
                          label: const Text('Next End'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignalButton extends StatelessWidget {
  const _SignalButton({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFF5C00) : const Color(0xFFE6EBF2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: active ? Colors.white : const Color(0xFF8E9CB4)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7A99),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
