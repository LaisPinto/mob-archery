import 'package:flutter/material.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';

class SwitchCardComponent extends StatelessWidget {
  const SwitchCardComponent({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.isDisabled = false,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;
    final effectiveOpacity = isDisabled ? 0.4 : 1.0;

    return Opacity(
      opacity: effectiveOpacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: c.iconPrimary, size: 24),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 13, color: c.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: isDisabled ? null : onChanged,
              activeThumbColor: c.buttonPrimaryForeground,
              activeTrackColor: c.switchActive,
              inactiveThumbColor: c.buttonPrimaryForeground,
              inactiveTrackColor: c.switchInactive,
            ),
          ],
        ),
      ),
    );
  }
}