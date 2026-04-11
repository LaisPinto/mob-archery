import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/timer/enums/timer_mode.dart';
import 'package:mob_archery/app/modules/timer/models/timer_config_model.dart';
import 'package:mob_archery/app/modules/timer/stores/timer_action.dart';

class TimerConfigPage extends StatefulWidget {
  const TimerConfigPage({super.key});

  @override
  State<TimerConfigPage> createState() => _TimerConfigPageState();
}

class _TimerConfigPageState extends State<TimerConfigPage> {
  late TimerConfigModel _config;
  bool _isEditing = false;

  static const _brandOrange = Color(
    0xFFF05A1A,
  ); // Laranja base da marca (ajustado para o tom do figma)

  @override
  void initState() {
    super.initState();
    final args = Modular.args.data;
    if (args is TimerConfigModel) {
      _config = args;
      _isEditing = true;
    } else {
      _config = TimerConfigModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: '',
        arrowsPerEnd: 3,
        endsPerRound: 6,
        rounds: 1,
        isABCD: true,
        plusTenPerArrow: false,
        timerMode: TimerMode.competition,
        isAccessibleMode: false,
      );
    }
  }

  int get _totalArrows => _config.arrowsPerEnd * _config.endsPerRound;

  @override
  Widget build(BuildContext context) {
    final timerAction = Modular.get<TimerAction>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Fundo base do Figma
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: Modular.to.pop,
          icon: const Icon(Icons.close_rounded, color: Color(0xFF0F172A)),
        ),
        title: Text(
          _isEditing ? 'Editar Temporizador' : 'Configurar Temporizador',
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(timerAction),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            // ── Summary card ─────────────────────────────────────────────
            _buildSummaryCard(),
            const SizedBox(height: 32),

            // ── Séries por rodada ─────────────────────────────────────────
            _sectionHeader('Séries por Rodada', '${_config.endsPerRound}'),
            const SizedBox(height: 16),
            Row(
              children: [4, 6, 8, 12].map((v) {
                final sel = _config.endsPerRound == v;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: () => setState(
                        () => _config = _config.copyWith(endsPerRound: v),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: sel
                            ? const Color(0xFFFFF7ED) // Laranja super claro
                            : Colors.white,
                        side: BorderSide(
                          color: sel ? _brandOrange : const Color(0xFFE2E8F0),
                          width: sel ? 1.5 : 1.0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '$v',
                        style: TextStyle(
                          color: sel ? _brandOrange : const Color(0xFF0F172A),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // ── Flechas por série ─────────────────────────────────────────
            _sectionHeader('Flechas por Série', '${_config.arrowsPerEnd}'),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _brandOrange,
                inactiveTrackColor: const Color(0xFFFFEDD5),
                thumbColor: _brandOrange,
                overlayColor: _brandOrange.withOpacity(0.2),
                trackHeight: 6.0,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10.0,
                ),
              ),
              child: Slider(
                min: 1,
                max: 6,
                divisions: 5,
                value: _config.arrowsPerEnd.toDouble(),
                onChanged: (v) => setState(
                  () => _config = _config.copyWith(arrowsPerEnd: v.round()),
                ),
              ),
            ),
            // Legenda do Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '1',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '3',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '6',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── AB/CD toggle ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // Fundo cinza bem claro (Figma)
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Alternar Atiradores (AB/CD)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Troca automática entre duplas',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _config.isABCD,
                    activeColor: Colors.white,
                    activeTrackColor: _brandOrange,
                    inactiveTrackColor: const Color(0xFFCBD5E1),
                    onChanged: (v) =>
                        setState(() => _config = _config.copyWith(isABCD: v)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Predefinições ─────────────────────────────────────────────
            const Text(
              'Predefinições de Tempo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            _presetCard(
              title: 'Padrão WA',
              subtitle: '4 min / 2 min (Sinal 30s)',
              value: "4' / 2'",
              icon: Icons.timer_outlined,
              selected:
                  _config.timerMode == TimerMode.competition &&
                  _config.arrowsPerEnd == 6,
              onTap: () => setState(
                () => _config = _config.copyWith(
                  arrowsPerEnd: 6,
                  timerMode: TimerMode.competition,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _presetCard(
              title: 'Indoor Rápido',
              subtitle: '2 min / 1 min',
              value: "2' / 1'",
              icon: Icons.speed_rounded,
              selected:
                  _config.timerMode == TimerMode.competition &&
                  _config.arrowsPerEnd == 3,
              onTap: () => setState(
                () => _config = _config.copyWith(
                  arrowsPerEnd: 3,
                  timerMode: TimerMode.competition,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _presetCard(
              title: 'Treino Dinâmico',
              subtitle: '30 segundos por flecha',
              value: '30s/fl',
              icon: Icons.bolt_rounded,
              selected: _config.timerMode == TimerMode.perArrowThirtySeconds,
              onTap: () => setState(
                () => _config = _config.copyWith(
                  timerMode: TimerMode.perArrowThirtySeconds,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── CARTÃO LARANJA (RESUMO) ──────────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return Container(
      clipBehavior: Clip.antiAlias, // Necessário para cortar o ícone de fundo
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: _brandOrange,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _brandOrange.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ícone de fundo (Marca D'água do Figma)
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.track_changes_rounded,
              size: 140,
              color: Colors.white.withOpacity(0.15),
            ),
          ),

          // Conteúdo do Card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL DE FLECHAS',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1.0,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$_totalArrows',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      height: 1.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Flechas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_config.endsPerRound} Séries',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_config.arrowsPerEnd} Flechas/Série',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── CABEÇALHOS DAS SESSÕES ──────────────────────────────────────────────────
  Widget _sectionHeader(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _brandOrange,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ── CARDS DE PREDEFINIÇÕES ──────────────────────────────────────────────────
  Widget _presetCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? _brandOrange
                : const Color(0xFFF1F5F9), // Borda apenas se selecionado
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: _brandOrange, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: _brandOrange,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── BOTÃO FINAL FIXO NA BASE ──────────────────────────────────────────────────
  Widget _buildBottomButton(TimerAction timerAction) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFF8FAFC), // Fundo da base para cobrir o scroll
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ), // Linha sutil separando a base (opcional, como no Figma)
            ),
          ),
          padding: const EdgeInsets.only(top: 16),
          child: FilledButton.icon(
            onPressed: () {
              // Salvar config sem perguntar nome explicitamente (se vazio usa predefinição)
              final finalName = _config.name.isEmpty
                  ? '${_config.endsPerRound}x${_config.arrowsPerEnd} - ${_config.timerMode.name}'
                  : _config.name;

              final finalConfig = _config.copyWith(name: finalName);
              timerAction.saveConfig(finalConfig);

              if (_isEditing) {
                Modular.to.pop();
              } else {
                timerAction.startTimer(finalConfig);
                Modular.to.pushReplacementNamed('/timer/run');
              }
            },
            icon: const Icon(
              Icons.play_arrow_rounded,
              size: 24,
              color: Colors.white,
            ),
            label: Text(
              _isEditing ? 'SALVAR TEMPORIZADOR' : 'INICIAR TEMPORIZADOR',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: _brandOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ), // Canto mais quadrado (Figma)
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
