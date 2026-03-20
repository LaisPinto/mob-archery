import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/timer/enums/timer_mode.dart';
import 'package:mob_archery/timer/models/timer_config_model.dart';
import 'package:mob_archery/timer/stores/timer_action.dart';
import 'package:mob_archery/timer/stores/timer_state.dart';

class TimerConfigPage extends StatefulWidget {
  const TimerConfigPage({super.key});

  @override
  State<TimerConfigPage> createState() => _TimerConfigPageState();
}

class _TimerConfigPageState extends State<TimerConfigPage> {
  late TimerConfigModel config;
  int seriesPerRound = 6;
  bool alternatingShooters = true;

  @override
  void initState() {
    super.initState();
    config = Modular.get<TimerState>().config.value;
  }

  Widget _presetCard({
    required String title,
    required String subtitle,
    required String value,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFFF5C00) : const Color(0xFFF0E2D7),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.timer_outlined, color: Color(0xFFFF5C00)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF6B7A99)),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFFF5C00),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerAction = Modular.get<TimerAction>();
    final totalArrows = seriesPerRound * config.arrows;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Modular.to.pop,
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Configurar Temporizador'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.help_outline_rounded, color: Color(0xFFFF5C00)),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5C00),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33FF5C00),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL DE FLECHAS',
                    style: TextStyle(color: Colors.white, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: '$totalArrows',
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(
                          text: ' Flechas',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      Chip(
                        label: Text('$seriesPerRound Series'),
                        backgroundColor: const Color(0x26FFFFFF),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      Chip(
                        label: Text('${config.arrows} Flechas/Serie'),
                        backgroundColor: const Color(0x26FFFFFF),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Series por Rodada',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '$seriesPerRound',
                  style: const TextStyle(
                    color: Color(0xFFFF5C00),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [4, 6, 8, 12].map((value) {
                final selected = seriesPerRound == value;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: () => setState(() => seriesPerRound = value),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selected ? const Color(0xFFFFF1E8) : Colors.white,
                        side: BorderSide(
                          color: selected ? const Color(0xFFFF5C00) : const Color(0xFFE1E6EF),
                        ),
                      ),
                      child: Text(
                        '$value',
                        style: TextStyle(
                          color: selected ? const Color(0xFFFF5C00) : const Color(0xFF1A2238),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Flechas por Serie',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '${config.arrows}',
                  style: const TextStyle(
                    color: Color(0xFFFF5C00),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Slider(
              min: 1,
              max: 6,
              divisions: 5,
              value: config.arrows.toDouble(),
              activeColor: const Color(0xFFFF5C00),
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(arrows: value.round());
                });
              },
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alternar Atiradores (AB/CD)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Troca automatica entre duplas',
                          style: TextStyle(color: Color(0xFF6B7A99)),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: alternatingShooters,
                    onChanged: (value) {
                      setState(() => alternatingShooters = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Predefinicoes de Tempo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            _presetCard(
              title: 'Padrao WA',
              subtitle: '4 min / 2 min (Sinal 30s)',
              value: "4' / 2'",
              selected: config.timerMode == TimerMode.competition && config.arrows == 6,
              onTap: () {
                setState(() {
                  config = config.copyWith(
                    arrows: 6,
                    timerMode: TimerMode.competition,
                  );
                });
              },
            ),
            const SizedBox(height: 12),
            _presetCard(
              title: 'Indoor Rapido',
              subtitle: '2 min / 1 min',
              value: "2' / 1'",
              selected: config.timerMode == TimerMode.competition && config.arrows == 3,
              onTap: () {
                setState(() {
                  config = config.copyWith(
                    arrows: 3,
                    timerMode: TimerMode.competition,
                  );
                });
              },
            ),
            const SizedBox(height: 12),
            _presetCard(
              title: 'Treino Dinamico',
              subtitle: '30 segundos por flecha',
              value: '30s/fl',
              selected: config.timerMode == TimerMode.perArrowThirtySeconds,
              onTap: () {
                setState(() {
                  config = config.copyWith(
                    timerMode: TimerMode.perArrowThirtySeconds,
                  );
                });
              },
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () {
                timerAction.updateConfig(config);
                Modular.to.pushReplacementNamed('/timer/');
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF5C00),
                foregroundColor: Colors.white,
              ),
              child: const Text('INICIAR TEMPORIZADOR'),
            ),
          ],
        ),
      ),
    );
  }
}
