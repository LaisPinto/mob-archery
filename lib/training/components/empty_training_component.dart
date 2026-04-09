import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';

class EmptyTrainingComponent extends StatelessWidget {
  const EmptyTrainingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ), // Padding superior reduzido
      children: [
        // ── Ilustração ────────────────────────────────────────────────────
        Center(
          child: SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: c.brandPrimaryLight,
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  Icons.gps_fixed_rounded,
                  size: 90,
                  color: c.brandPrimary.withValues(alpha: 0.35),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_chart_rounded,
                      color: c.brandPrimaryDark,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Título e descrição ────────────────────────────────────────────
        Text(
          'Nenhum treino registrado ainda',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: c.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Que tal começar agora? Organize suas sessões de tiro com arco e acompanhe sua evolução técnica.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: c.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 32),

        // ── Card CTA ─────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: c.brandPrimaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.add_rounded, color: c.iconPrimary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Iniciar treino',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Comece uma nova sessão de treino agora',
                      style: TextStyle(fontSize: 13, color: c.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () => Modular.to.pushNamed('/training/register-end'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(72, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Iniciar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
