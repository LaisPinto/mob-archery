import 'package:flutter/material.dart';

class TimerControlBar extends StatelessWidget {
  const TimerControlBar({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.isRunning,
    required this.startLabel,
    required this.pauseLabel,
    required this.resetLabel,
  });

  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final bool isRunning;
  final String startLabel;
  final String pauseLabel;
  final String resetLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: isRunning ? null : onStart,
          icon: const Icon(Icons.play_arrow),
          label: Text(startLabel),
        ),
        OutlinedButton.icon(
          onPressed: isRunning ? onPause : null,
          icon: const Icon(Icons.pause),
          label: Text(pauseLabel),
        ),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.replay),
          label: Text(resetLabel),
        ),
      ],
    );
  }
}
