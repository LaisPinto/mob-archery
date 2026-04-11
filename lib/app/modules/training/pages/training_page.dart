import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/app/modules/core/theme/custom_color_scheme.dart';
import 'package:mobx/mobx.dart';

import '../_export_training.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late final TrainingAction trainingAction;
  late final TrainingState trainingState;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ReactionDisposer? _featuredEndsReaction;

  @override
  void initState() {
    super.initState();
    trainingAction = Modular.get<TrainingAction>();
    trainingState = Modular.get<TrainingState>();
    trainingAction.watchSessions();
    _searchController.addListener(
      () => setState(() => _searchQuery = _searchController.text),
    );

    _featuredEndsReaction = reaction(
      (_) => trainingState.sessions.isNotEmpty
          ? trainingState.sessions.first.sessionId
          : null,
      (sessionId) {
        if (sessionId != null) {
          trainingAction.watchEnds(trainingState.sessions.first);
        }
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _featuredEndsReaction?.call();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          'Treinos',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar fixa no topo ────────────────────────────────
            Observer(
              builder: (_) {
                final isEmpty = trainingState.sessions.isEmpty;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: TextField(
                    controller: _searchController,
                    enabled: !isEmpty, // Desabilita se a lista estiver vazia
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
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: c.brandPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Conteúdo (Lista ou Vazio) ──────────────────────────────
            // Usamos Expanded para garantir que a ListView ou o EmptyState ocupem o resto da tela sem dar Overflow
            Expanded(
              child: Observer(
                builder: (_) {
                  if (trainingState.sessions.isEmpty) {
                    return const EmptyTrainingComponent();
                  }
                  return TrainingListComponent(
                    trainingState: trainingState,
                    searchQuery: _searchQuery,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
