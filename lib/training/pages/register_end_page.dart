import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/timer/stores/timer_state.dart';
import 'package:mob_archery/training/enums/bow_type.dart';
import 'package:mob_archery/training/enums/registered_by.dart';
import 'package:mob_archery/training/stores/training_action.dart';
import 'package:mob_archery/training/stores/training_state.dart';

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
  final scoreOptions = const ['X', '10', '9', '8', '7', '6', '5', '4', '3', '2', '1', 'M'];

  late final TrainingAction trainingAction;
  late final TrainingState trainingState;
  late final TextEditingController distanceController;
  late final TextEditingController spotterController;
  late int arrows;
  late RegisteredBy registeredBy;
  String? localErrorMessage;

  BowType bowType = BowType.recurve;
  late List<String?> arrowSelections;

  @override
  void initState() {
    super.initState();
    trainingAction = Modular.get<TrainingAction>();
    trainingState = Modular.get<TrainingState>();
    final timerConfig = Modular.get<TimerState>().config.value;
    arrows = timerConfig.arrows;
    registeredBy = widget.registeredBy;
    arrowSelections = List<String?>.filled(arrows, null);
    distanceController = TextEditingController(text: '70');
    spotterController = TextEditingController(text: widget.spotterName ?? '');
  }

  @override
  void dispose() {
    distanceController.dispose();
    spotterController.dispose();
    super.dispose();
  }

  double get averageScore {
    final selectedScores = arrowSelections.whereType<String>().toList();
    if (selectedScores.isEmpty) {
      return 0;
    }

    int total = 0;
    for (final score in selectedScores) {
      if (score == 'X' || score == '10') {
        total += 10;
      } else if (score != 'M') {
        total += int.tryParse(score) ?? 0;
      }
    }
    return total / selectedScores.length;
  }

  int get xOrTenCount => arrowSelections
      .where((score) => score == 'X' || score == '10')
      .length;

  Widget _scoreCircle(int index) {
    final score = arrowSelections[index];
    final selected = score != null;

    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? const Color(0xFFFF5C00) : const Color(0xFFD8E1ED),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              score ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: selected ? const Color(0xFFFF5C00) : const Color(0xFFD8E1ED),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text('${index + 1}º', style: const TextStyle(color: Color(0xFF93A0B8))),
      ],
    );
  }

  Color _buttonColor(String score) {
    switch (score) {
      case '10':
      case '9':
        return const Color(0xFFFFCC15);
      case '8':
      case '7':
        return const Color(0xFFE32727);
      case '6':
      case '5':
        return const Color(0xFF4280E8);
      case '4':
      case '3':
      case 'X':
        return const Color(0xFF121B31);
      case 'M':
      case '2':
      case '1':
        return const Color(0xFFE7EDF5);
      default:
        return Colors.white;
    }
  }

  Color _buttonTextColor(String score) {
    return score == 'M' || score == '2' || score == '1'
        ? const Color(0xFF1A2238)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Modular.to.pop),
        title: const Text('Registrar End'),
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFF0E2D7)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEFE6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.gps_fixed_rounded, color: Color(0xFFFF5C00)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distancia: ${distanceController.text}m | Arco: Recurvo',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Editar contexto',
                            style: TextStyle(color: Color(0xFFFF5C00)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEFE6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'End 4/12',
                        style: TextStyle(color: Color(0xFFFF5C00), fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SCORES SELECIONADOS',
                style: TextStyle(
                  color: Color(0xFF7587A6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(arrows, _scoreCircle),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Media do End',
                      value: averageScore.toStringAsFixed(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'X / 10',
                      value: '$xOrTenCount / ${arrowSelections.whereType<String>().length}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4ED),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFD5BF)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.remove_red_eye_outlined, color: Color(0xFFFF5C00)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registro por Spotter',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Marque se outra pessoa estiver anotando',
                            style: TextStyle(color: Color(0xFF6B7A99)),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: registeredBy == RegisteredBy.spotter,
                      onChanged: (value) {
                        setState(() {
                          registeredBy =
                              value ? RegisteredBy.spotter : RegisteredBy.user;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (registeredBy == RegisteredBy.spotter) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: spotterController,
                  decoration: const InputDecoration(
                    hintText: 'Nome do spotter responsavel',
                  ),
                ),
              ],
              const SizedBox(height: 18),
              GridView.builder(
                itemCount: scoreOptions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final score = scoreOptions[index];
                  return FilledButton(
                    onPressed: () {
                      final emptyIndex =
                          arrowSelections.indexWhere((item) => item == null);
                      if (emptyIndex != -1) {
                        setState(() {
                          arrowSelections[emptyIndex] = score;
                        });
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _buttonColor(score),
                      foregroundColor: _buttonTextColor(score),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          score,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _buttonTextColor(score),
                          ),
                        ),
                        if (score == 'X')
                          Text('10 pts', style: TextStyle(fontSize: 11, color: _buttonTextColor(score))),
                        if (score == 'M')
                          const Text('Miss', style: TextStyle(fontSize: 11, color: Color(0xFF7C8AA5))),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      final lastIndex =
                          arrowSelections.lastIndexWhere((item) => item != null);
                      if (lastIndex != -1) {
                        setState(() {
                          arrowSelections[lastIndex] = null;
                        });
                      }
                    },
                    child: const Icon(Icons.undo_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: trainingState.isLoading.value
                          ? null
                          : () async {
                              final missingScores =
                                  arrowSelections.any((score) => score == null);
                              if (missingScores) {
                                setState(() {
                                  localErrorMessage = 'Every arrow must have a score.';
                                });
                                return;
                              }

                              final distance = double.tryParse(
                                distanceController.text.replaceAll(',', '.'),
                              );
                              if (distance == null || distance <= 0) {
                                setState(() {
                                  localErrorMessage = 'Enter a valid distance.';
                                });
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
                              );

                              if (trainingState.errorMessage.value == null && mounted) {
                                Modular.to.pop();
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5C00),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Salvar End'),
                    ),
                  ),
                ],
              ),
              if (localErrorMessage != null) ...[
                const SizedBox(height: 12),
                Text(localErrorMessage!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF7C8AA5))),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
