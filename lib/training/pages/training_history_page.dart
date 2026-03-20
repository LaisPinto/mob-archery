import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/training/stores/training_action.dart';
import 'package:mob_archery/training/stores/training_state.dart';

class TrainingHistoryPage extends StatefulWidget {
  const TrainingHistoryPage({super.key});

  @override
  State<TrainingHistoryPage> createState() => _TrainingHistoryPageState();
}

class _TrainingHistoryPageState extends State<TrainingHistoryPage> {
  late final TrainingAction trainingAction;
  late final TrainingState trainingState;

  @override
  void initState() {
    super.initState();
    trainingAction = Modular.get<TrainingAction>();
    trainingState = Modular.get<TrainingState>();
    trainingAction.watchSessions();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy · HH:mm');

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
      appBar: AppBar(
        leading: BackButton(onPressed: () => Modular.to.navigate('/home/')),
        title: const Text('Historico de Treinos'),
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar por data ou tipo...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: const Color(0xFFF2F5FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (trainingState.sessions.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE7EAF0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEFE6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.gps_fixed_rounded, color: Color(0xFFFF5C00)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Treino Outdoor - 70m',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  dateFormat.format(trainingState.sessions.first.date),
                                  style: const TextStyle(color: Color(0xFF6B7A99)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEFE6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'SPOTTER',
                              style: TextStyle(
                                color: Color(0xFFFF5C00),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryMetric(
                              label: 'TOTAL',
                              value: '${trainingState.sessions.first.totalArrows * 9 + 10}',
                              subtitle: '${trainingState.sessions.first.totalArrows} flechas',
                            ),
                          ),
                          Expanded(
                            child: _SummaryMetric(
                              label: 'MEDIA',
                              value: trainingState.sessions.first.averageScore.toStringAsFixed(2),
                              subtitle: 'p/ flecha',
                            ),
                          ),
                          Expanded(
                            child: _SummaryMetric(
                              label: 'X COUNT',
                              value: '${trainingState.sessions.first.xCount}',
                              subtitle: 'centro',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE7EAF0)),
                        ),
                        child: Column(
                          children: const [
                            _TableRow(title: 'End 1', total: '56', accumulated: '56'),
                            _TableRow(
                              title: 'End 2',
                              total: '58',
                              accumulated: '114',
                              highlighted: true,
                            ),
                            _TableRow(title: 'End 3', total: '54', accumulated: '168'),
                            Padding(
                              padding: EdgeInsets.all(14),
                              child: Text(
                                'VER TODAS AS 12 SERIES',
                                style: TextStyle(
                                  color: Color(0xFFFF5C00),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.share_outlined),
                              label: Text('Compartilhar'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: Color(0xFFFF5C00),
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(Icons.picture_as_pdf_outlined),
                              label: Text('Exportar PDF'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              ...trainingState.sessions.skip(1).map(
                (session) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.history_rounded, color: Color(0xFF6B7A99)),
                    ),
                    title: Text('Treino Livre - ${session.totalArrows}m'),
                    subtitle: Text(
                      '${dateFormat.format(session.date)}\nMedia: ${session.averageScore.toStringAsFixed(1)}',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    isThreeLine: true,
                    onTap: () => Modular.to.pushNamed(
                      '/training/detail',
                      arguments: session,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final String label;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF7C8AA5), fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Color(0xFF93A0B8))),
      ],
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.title,
    required this.total,
    required this.accumulated,
    this.highlighted = false,
  });

  final String title;
  final String total;
  final String accumulated;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlighted ? const Color(0xFFFFF4ED) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Expanded(
            child: Text(
              total,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: Text(
              accumulated,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Color(0xFF7C8AA5)),
            ),
          ),
        ],
      ),
    );
  }
}
