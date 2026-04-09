import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/training/models/training_end_model.dart';
import 'package:mob_archery/training/models/training_session_model.dart';
import 'package:mob_archery/training/stores/training_action.dart';
import 'package:mob_archery/training/stores/training_state.dart';

class TrainingCardComponent extends StatelessWidget {
  const TrainingCardComponent({
    super.key,
    required this.session,
    this.isHighlighted = false,
    this.ends = const [],
    required this.onTap,
  });

  final TrainingSessionModel session;
  final bool isHighlighted;
  final List<TrainingEndModel> ends;
  final VoidCallback onTap;

  static final _dateFormat = DateFormat('dd MMM yyyy • HH:mm');
  static final _shortDateFormat = DateFormat('dd MMM yyyy');

  String get _title {
    if (session.name.isNotEmpty) return session.name;
    return 'Treino — ${session.totalArrows} flechas';
  }

  int get _totalScore => (session.averageScore * session.totalArrows).round();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    if (isHighlighted) {
      final trainingState = Modular.get<TrainingState>();
      return Observer(
        builder: (_) => _FeaturedCard(
          session: session,
          title: _title,
          totalScore: _totalScore,
          dateText: _dateFormat.format(session.date),
          ends: ends,
          isLoading: trainingState.isLoading.value,
          c: c,
        ),
      );
    }

    return _SecondaryItem(
      session: session,
      title: _title,
      dateText: _shortDateFormat.format(session.date),
      onTap: onTap,
      c: c,
    );
  }
}

// ── Featured (highlighted) card ────────────────────────────────────────────

int _scoreValue(String s) {
  if (s == 'X' || s == '10') return 10;
  if (s == 'M') return 0;
  return int.tryParse(s) ?? 0;
}

int _endTotal(TrainingEndModel end) =>
    end.arrows.fold(0, (sum, s) => sum + _scoreValue(s));

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.session,
    required this.title,
    required this.totalScore,
    required this.dateText,
    required this.ends,
    required this.isLoading,
    required this.c,
  });

  final TrainingSessionModel session;
  final String title;
  final int totalScore;
  final String dateText;
  final List<TrainingEndModel> ends;
  final bool isLoading;
  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.track_changes_rounded,
                    color: c.brandPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                          if (session.isSpotter) ...[
                            const SizedBox(width: 8),
                            _Badge(label: 'SPOTTER', c: c),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateText,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Metrics Grid ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricItem(
                      label: 'TOTAL',
                      value: '$totalScore',
                      subtitle: '${session.totalArrows} flechas',
                      valueColor: c.brandPrimary,
                      c: c,
                    ),
                  ),
                  _VerticalDivider(c: c),
                  Expanded(
                    child: _MetricItem(
                      label: 'MÉDIA',
                      value: session.averageScore.toStringAsFixed(2),
                      subtitle: 'p/ flecha',
                      valueColor: c.textPrimary,
                      c: c,
                    ),
                  ),
                  _VerticalDivider(c: c),
                  Expanded(
                    child: _MetricItem(
                      label: 'X COUNT',
                      value: '${session.xCount}',
                      subtitle: 'centro',
                      valueColor: c.textPrimary,
                      c: c,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Table Box ───────────────────────────────────────────────────
            if (ends.isNotEmpty) ...[
              Builder(
                builder: (_) {
                  int acc = 0;
                  final rows = ends.asMap().entries.map((e) {
                    final sum = _endTotal(e.value);
                    acc += sum;
                    return (
                      label: 'End ${e.key + 1}',
                      sum: sum,
                      acc: acc,
                      isOdd: e.key.isOdd,
                    );
                  }).toList();

                  // Limitando a pré-visualização para as 3 primeiras séries
                  const previewCount = 3;
                  final preview = rows.take(previewCount).toList();

                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom: 12,
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'SÉRIE (END)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'SOMA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'ACUMULADO',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F5F9),
                        ),
                        ...preview.map(
                          (row) => _EndTableRow(
                            label: row.label,
                            sum: '${row.sum}',
                            acc: '${row.acc}',
                            backgroundColor: row.isOdd
                                ? const Color(0xFFFFF7ED)
                                : null,
                            c: c,
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE2E8F0),
                        ),
                        InkWell(
                          onTap: () {
                            Modular.get<TrainingAction>().watchEnds(session);
                            Modular.to.pushNamed('/training/register-end');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Text(
                                rows.length > previewCount
                                    ? 'VER TODAS AS ${rows.length} SÉRIES'
                                    : 'VER TODAS AS SÉRIES',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: c.brandPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],

            // ── Actions ──────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => Modular.get<TrainingAction>()
                            .shareSession(session),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      side: BorderSide(color: c.brandPrimary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundColor: c.brandPrimary,
                    ),
                    icon: const Icon(Icons.share_outlined, size: 20),
                    label: const Text(
                      'Compartilhar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => Modular.get<TrainingAction>()
                            .exportSessionPdf(session),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      backgroundColor: c.brandPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: c.buttonPrimaryForeground,
                            ),
                          )
                        : const Icon(Icons.picture_as_pdf_outlined, size: 20),
                    label: const Text(
                      'Exportar PDF',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tabela Row Helper ──────────────────────────────────────────────────────

class _EndTableRow extends StatelessWidget {
  const _EndTableRow({
    required this.label,
    required this.sum,
    required this.acc,
    this.backgroundColor,
    required this.c,
  });

  final String label;
  final String sum;
  final String acc;
  final Color? backgroundColor;
  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              sum,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: c.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              acc,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Secondary (compact) list item ──────────────────────────────────────────

class _SecondaryItem extends StatelessWidget {
  const _SecondaryItem({
    required this.session,
    required this.title,
    required this.dateText,
    required this.onTap,
    required this.c,
  });

  final TrainingSessionModel session;
  final String title;
  final String dateText;
  final VoidCallback onTap;
  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Dispara a animação de sanfona!
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Color(0xFF64748B),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dateText • ${session.totalArrows} Flechas • X: ${session.xCount}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Média: ${session.averageScore.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: c.brandPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared sub-widgets ─────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.c});

  final String label;
  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDD5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: c.brandPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 10,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.valueColor,
    required this.c,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color valueColor;
  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.c});

  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    // Altura reduzida para ficar idêntico aos pequenos riscos do Figma
    return Container(width: 1, height: 32, color: const Color(0xFFE2E8F0));
  }
}
