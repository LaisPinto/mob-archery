import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/timer/stores/timer_state.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

import '../_export_training.dart';

class RegisterEndPage extends StatefulWidget {
  const RegisterEndPage({
    super.key,
    this.registeredBy = RegisteredBy.user,
    this.spotterName,
  });

  final RegisteredBy registeredBy;
  final String? spotterName;

  @override
  State<RegisterEndPage> createState() => _RegisterEndPageState();
}

class _RegisterEndPageState extends State<RegisterEndPage> {
  static const _bowTypeLabels = {
    BowType.recurve: 'Recurvo',
    BowType.compound: 'Composto',
    BowType.barebow: 'Barebow',
    BowType.traditional: 'Tradicional',
  };

  late final TrainingAction trainingAction;
  late final TrainingState trainingState;
  late final TextEditingController nameController;
  late final TextEditingController distanceController;
  late final TextEditingController notesController;
  late final TextEditingController spotterController;

  late int arrows;
  late RegisteredBy registeredBy;
  late List<String?> arrowSelections;

  BowType bowType = BowType.recurve;
  String? localErrorMessage;
  int? _editingIndex;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    trainingAction = Modular.get<TrainingAction>();
    trainingState = Modular.get<TrainingState>();
    final timerConfig = Modular.get<TimerState>().config.value;
    arrows = timerConfig.arrows;
    registeredBy = widget.registeredBy;
    arrowSelections = List<String?>.filled(arrows, null);
    nameController = TextEditingController();
    distanceController = TextEditingController(text: '70');
    notesController = TextEditingController();
    spotterController = TextEditingController(text: widget.spotterName ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    distanceController.dispose();
    notesController.dispose();
    spotterController.dispose();
    super.dispose();
  }

  // ── Computed ───────────────────────────────────────────────────────────────

  double get _averageScore {
    final selected = arrowSelections.whereType<String>().toList();
    if (selected.isEmpty) return 0;
    int total = 0;
    for (final s in selected) {
      if (s == 'X' || s == '10') {
        total += 10;
      } else if (s != 'M') {
        total += int.tryParse(s) ?? 0;
      }
    }
    return total / selected.length;
  }

  int get _xOrTenCount =>
      arrowSelections.where((s) => s == 'X' || s == '10').length;

  // ── Actions ────────────────────────────────────────────────────────────────

  void _onScoreSelected(String score) {
    if (_editingIndex != null) {
      setState(() {
        arrowSelections[_editingIndex!] = score;
        _editingIndex = null;
      });
      return;
    }
    final emptyIndex = arrowSelections.indexWhere((s) => s == null);
    if (emptyIndex != -1) {
      setState(() => arrowSelections[emptyIndex] = score);
    }
  }

  Future<void> _save() async {
    if (arrowSelections.any((s) => s == null)) {
      setState(
        () => localErrorMessage = 'Selecione uma pontuação para cada flecha.',
      );
      return;
    }
    final distance = double.tryParse(
      distanceController.text.replaceAll(',', '.'),
    );
    if (distance == null || distance <= 0) {
      setState(() => localErrorMessage = 'Informe uma distância válida.');
      return;
    }
    setState(() => localErrorMessage = null);

    await trainingAction.registerEnd(
      arrows: arrowSelections.whereType<String>().toList(),
      distance: distance,
      bowType: bowType,
      registeredBy: registeredBy,
      spotterName: registeredBy == RegisteredBy.spotter
          ? spotterController.text
          : null,
      name: nameController.text.trim(),
    );

    if (trainingState.errorMessage.value == null && mounted) {
      Modular.to.pop();
    }
  }

  // ── Color helpers ──────────────────────────────────────────────────────────

  Color _circleZoneColor(String? score) {
    switch (score) {
      case 'X':
        return const Color(0xFF3B82F6);
      case '10':
      case '9':
        return const Color(0xFFF97316);
      case '8':
      case '7':
        return const Color(0xFFDC2626);
      case '6':
      case '5':
        return const Color(0xFF3B82F6);
      case '4':
      case '3':
      case '2':
      case '1':
        return const Color(0xFF0F172A);
      case 'M':
        return const Color(0xFF94A3B8);
      default:
        return const Color(0xFFCBD5E1);
    }
  }

  // ── Score circle ───────────────────────────────────────────────────────────

  Widget _buildScoreCircle(int index, CustomColorScheme c) {
    final score = arrowSelections[index];
    final selected = score != null;
    final isEditing = _editingIndex == index;
    final zoneColor = _circleZoneColor(score);
    final isLightZone = score == '2' || score == '1';

    final circle = selected
        ? Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEditing
                  ? c.brandPrimary.withValues(alpha: 0.15)
                  : zoneColor.withValues(alpha: 0.10),
              border: Border.all(
                color: isEditing ? c.brandPrimary : zoneColor,
                width: isEditing ? 3.0 : 2.5,
              ),
            ),
            child: Center(
              child: Text(
                score,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isEditing
                      ? c.brandPrimary
                      : (isLightZone ? c.textSecondary : zoneColor),
                ),
              ),
            ),
          )
        : SizedBox(
            width: 56,
            height: 56,
            child: CustomPaint(
              painter: _DashedCirclePainter(
                color: isEditing ? c.brandPrimary : c.border,
              ),
            ),
          );

    return GestureDetector(
      onTap: () => setState(() {
        _editingIndex = _editingIndex == index ? null : index;
      }),
      child: Column(
        children: [
          circle,
          const SizedBox(height: 5),
          Text(
            '${index + 1}ª',
            style: TextStyle(color: c.textTertiary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: c.textPrimary),
        title: Text(
          LocaleKeys.modules_training_register_title.tr(),
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // ── 1. Informações do treino ──────────────────────────────
              _SectionLabel(label: 'INFORMAÇÕES DO TREINO', c: c),
              const SizedBox(height: 12),
              _OutlineInput(
                controller: nameController,
                hint: 'Nome',
                textCapitalization: TextCapitalization.sentences,
                c: c,
              ),
              const SizedBox(height: 8),
              _OutlineInput(
                controller: distanceController,
                hint: 'Distância de disparo',
                keyboardType: TextInputType.number,
                c: c,
              ),
              const SizedBox(height: 8),
              _BowTypeDropdown(
                value: bowType,
                labels: _bowTypeLabels,
                onChanged: (v) {
                  if (v != null) setState(() => bowType = v);
                },
                c: c,
              ),
              const SizedBox(height: 24),

              // ── 2. Scores selecionados ────────────────────────────────
              _SectionLabel(label: 'SCORES SELECIONADOS', c: c),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                child: Row(
                  children: List.generate(
                    arrows,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        right: index < arrows - 1 ? 12.0 : 0,
                      ),
                      child: _buildScoreCircle(index, c),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── 3. Teclado de pontuação ─────────────────────────────────
              ScoreKeyboardComponent(onScoreSelected: _onScoreSelected),
              const SizedBox(height: 24),

              // ── 4. Métricas do end ──────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: MetricCardComponent(
                      label: 'Média do End',
                      value: _averageScore.toStringAsFixed(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCardComponent(
                      label: 'X / 10',
                      value:
                          '$_xOrTenCount / ${arrowSelections.whereType<String>().length}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── 5. Anotações ──────────────────────────────────────────
              _SectionLabel(label: 'ANOTAÇÕES', c: c),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Observações sobre este end...',
                  hintStyle: TextStyle(color: c.inputHint),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: c.inputBackground,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: c.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: c.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: c.brandPrimary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ── 6. Registro por Spotter ───────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.info,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.brandPrimaryLight),
                ),
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, color: c.brandPrimary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys
                                .modules_training_register_spotter_toggle_title
                                .tr(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            LocaleKeys
                                .modules_training_register_spotter_toggle_desc
                                .tr(),
                            style: TextStyle(
                              color: c.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: registeredBy == RegisteredBy.spotter,
                      onChanged: (value) => setState(() {
                        registeredBy = value
                            ? RegisteredBy.spotter
                            : RegisteredBy.user;
                      }),
                    ),
                  ],
                ),
              ),
              if (registeredBy == RegisteredBy.spotter) ...[
                const SizedBox(height: 12),
                _OutlineInput(
                  controller: spotterController,
                  hint: 'Nome do spotter responsável',
                  textCapitalization: TextCapitalization.words,
                  c: c,
                ),
              ],
              const SizedBox(height: 24),

              // ── 7. Desfazer + Salvar ──────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: trainingState.isLoading.value ? null : _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: trainingState.isLoading.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: c.buttonPrimaryForeground,
                              ),
                            )
                          : Text(
                              LocaleKeys.modules_training_register_save_button
                                  .tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              // ── Erros ─────────────────────────────────────────────────
              if (localErrorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  localErrorMessage!,
                  style: TextStyle(color: c.error, fontSize: 13),
                ),
              ],
              if (trainingState.errorMessage.value != null) ...[
                const SizedBox(height: 12),
                Text(
                  trainingState.errorMessage.value!,
                  style: TextStyle(color: c.error, fontSize: 13),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dashed circle painter ──────────────────────────────────────────────────

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});

  final Color color;

  static const double _strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - _strokeWidth / 2;
    const dashCount = 16;
    const segmentAngle = (2 * math.pi) / dashCount;
    const dashFraction = 0.55;
    const dashAngle = segmentAngle * dashFraction;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * segmentAngle - math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => old.color != color;
}

// ── Shared sub-widgets ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.c});

  final String label;
  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: c.textTertiary,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _OutlineInput extends StatelessWidget {
  const _OutlineInput({
    required this.controller,
    required this.hint,
    required this.c,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hint;
  final CustomColorScheme c;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: TextStyle(color: c.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.inputHint),
        filled: true,
        fillColor: c.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.brandPrimary, width: 1.5),
        ),
      ),
    );
  }
}

class _BowTypeDropdown extends StatelessWidget {
  const _BowTypeDropdown({
    required this.value,
    required this.labels,
    required this.onChanged,
    required this.c,
  });

  final BowType value;
  final Map<BowType, String> labels;
  final ValueChanged<BowType?> onChanged;
  final CustomColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: c.inputBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.inputBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BowType>(
          value: value,
          dropdownColor: c.surface,
          icon: Icon(Icons.expand_more_rounded, color: c.textSecondary),
          isExpanded: true,
          items: BowType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(
                    labels[type] ?? type.name,
                    style: TextStyle(color: c.textPrimary),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
