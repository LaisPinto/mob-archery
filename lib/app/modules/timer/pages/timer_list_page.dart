import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/app/modules/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/app/modules/timer/components/timer_card_component.dart';
import 'package:mob_archery/app/modules/timer/models/timer_config_model.dart';
import 'package:mob_archery/app/modules/timer/stores/timer_action.dart';
import 'package:mob_archery/app/modules/timer/stores/timer_state.dart';
import 'package:mobx/mobx.dart';

class TimerListPage extends StatefulWidget {
  const TimerListPage({super.key});

  @override
  State<TimerListPage> createState() => _TimerListPageState();
}

class _TimerListPageState extends State<TimerListPage> {
  late final TimerState _timerState;
  late final TimerAction _timerAction;
  final _searchController = TextEditingController();
  String _query = '';
  ReactionDisposer? _reaction;

  @override
  void initState() {
    super.initState();
    _timerState = Modular.get<TimerState>();
    _timerAction = Modular.get<TimerAction>();
    _searchController.addListener(
      () => setState(() => _query = _searchController.text),
    );
    _reaction = autorun((_) {
      _timerState.savedConfigs.length;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _reaction?.call();
    _searchController.dispose();
    super.dispose();
  }

  List<TimerConfigModel> _filter(List<TimerConfigModel> configs) {
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return configs;
    return configs.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;
    final configs = _timerState.savedConfigs.toList();
    final filtered = _filter(configs);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          'Temporizadores',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700),
        ),
      ),
      // O FloatingActionButton foi removido para alinhar ao Figma
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar por data ou tipo...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF94A3B8),
                  ),
                  fillColor: const Color(0xFFF1F5F9),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.brandPrimary, width: 1.5),
                  ),
                ),
              ),
            ),
            // ── Divider sutil ───────────────────────────────────────────
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // ── Content ─────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  Text(
                    'Histórico de temporizadores',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // O botão pontilhado "Novo Temporizador" fica sempre no topo da lista
                  _DashedNewTimerButton(
                    onTap: () => Modular.to.pushNamed('/timer/config'),
                  ),
                  const SizedBox(height: 24),

                  if (filtered.isEmpty && configs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(
                        child: Text(
                          'Nenhum temporizador encontrado para "$_query"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: c.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    ...filtered.map(
                      (config) => TimerCardComponent(
                        key: ValueKey(config.id),
                        config: config,
                        onStart: () {
                          _timerAction.startTimer(config);
                          Modular.to.pushNamed('/timer/run');
                        },
                        onEdit: () => Modular.to.pushNamed(
                          '/timer/config',
                          arguments: config,
                        ),
                        onDuplicate: () => _timerAction.duplicateConfig(config),
                        onDelete: () => _timerAction.deleteConfig(config.id),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Botão tracejado personalizado (Figma) ──────────────────────────────────
class _DashedNewTimerButton extends StatelessWidget {
  const _DashedNewTimerButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: const Color(0xFFE4E9F2), // Laranja super clarinho das bordas
          strokeWidth: 2,
          gap: 6,
          radius: 16,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: Color(0xFFBD3F00), // Laranja vibrante
                size: 36,
              ),
              const SizedBox(height: 12),
              Text(
                'Novo Temporizador',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFBD3F00),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Personalize o tempo, rounds\ne flechas para o seu treino.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1C1B1B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pintor de Borda Tracejada ──────────────────────────────────────────────
class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    // Converte o Path sólido em um Path tracejado
    final Path dashedPath = _createDashedPath(path, gap * 2, gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double dashGap) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashLength : dashGap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.radius != radius;
  }
}
