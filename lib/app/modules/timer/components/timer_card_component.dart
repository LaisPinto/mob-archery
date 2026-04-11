import 'package:flutter/material.dart';
import 'package:mob_archery/app/modules/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/app/modules/timer/models/timer_config_model.dart';

class TimerCardComponent extends StatelessWidget {
  const TimerCardComponent({
    super.key,
    required this.config,
    required this.onStart,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  final TimerConfigModel config;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  String _subtitle() {
    if (config.rounds > 1) {
      return '${config.rounds} rounds • ${config.endsPerRound} ends • ${config.arrowsPerEnd} flechas';
    }
    final mins = config.endTotalSeconds ~/ 60;
    return '${config.arrowsPerEnd} flechas • $mins min';
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Badges ─────────────────────────────────────────────────
            if (config.isABCD || config.plusTenPerArrow)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (config.isABCD)
                      _Badge(label: 'AB/CD ATIVO', color: c.brandPrimary),
                    if (config.plusTenPerArrow)
                      const _Badge(
                        label: '+10s/FLECHA',
                        color: Color(0xFF1D4ED8),
                      ),
                  ],
                ),
              ),
            // ── Name + subtitle ─────────────────────────────────────────
            Text(
              config.name.isNotEmpty ? config.name : 'Temporizador',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _subtitle(),
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            // ── Footer ──────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onStart,
                    style: FilledButton.styleFrom(
                      backgroundColor: c.brandPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Iniciar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _MenuButton(
                  onEdit: onEdit,
                  onDuplicate: onDuplicate,
                  onDelete: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
          case 'duplicate':
            onDuplicate();
          case 'delete':
            onDelete();
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'edit', child: Text('Editar')),
        PopupMenuItem(value: 'duplicate', child: Text('Duplicar')),
        PopupMenuItem(
          value: 'delete',
          child: Text('Excluir', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}