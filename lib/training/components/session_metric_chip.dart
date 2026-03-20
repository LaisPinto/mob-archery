import 'package:flutter/material.dart';

class SessionMetricChip extends StatelessWidget {
  const SessionMetricChip({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.analytics_outlined, size: 18),
      label: Text('$label: $value'),
    );
  }
}
