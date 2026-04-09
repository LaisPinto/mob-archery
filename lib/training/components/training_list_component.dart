import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/training/components/empty_training_component.dart';
import 'package:mob_archery/training/components/training_card_component.dart';
import 'package:mob_archery/training/models/training_session_model.dart';
import 'package:mob_archery/training/stores/training_action.dart';
import 'package:mob_archery/training/stores/training_state.dart';
import 'package:mobx/mobx.dart';

class TrainingListComponent extends StatefulWidget {
  const TrainingListComponent({
    super.key,
    required this.trainingState,
    this.searchQuery = '',
  });

  final TrainingState trainingState;
  final String searchQuery;

  @override
  State<TrainingListComponent> createState() => _TrainingListComponentState();
}

class _TrainingListComponentState extends State<TrainingListComponent> {
  static final _dateFormat = DateFormat('dd/MM/yyyy');

  String? _expandedSessionId;
  String? _loadedSessionId;
  ReactionDisposer? _reaction;

  @override
  void initState() {
    super.initState();
    _reaction = autorun((_) {
      // Track sessions and ends so setState fires when either changes
      widget.trainingState.sessions.length;
      widget.trainingState.ends.length;
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(TrainingListComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _reaction?.call();
    super.dispose();
  }

  void _handleCardTap(TrainingSessionModel session) {
    if (_expandedSessionId == session.sessionId) return;

    setState(() => _expandedSessionId = session.sessionId);
    Modular.get<TrainingAction>().watchEnds(session);
  }

  List<TrainingSessionModel> _filter(List<TrainingSessionModel> sessions) {
    final query = widget.searchQuery.toLowerCase().trim();
    if (query.isEmpty) return sessions.toList();

    return sessions.where((s) {
      // 1. Recria o título exato que o TrainingCardComponent renderiza
      final displayTitle = s.name.isNotEmpty
          ? s.name
          : 'Treino — ${s.totalArrows} flechas';

      // 2. Formata a data usando o mesmo padrão que aparece no card
      final displayDate = DateFormat('dd MMM yyyy').format(s.date);

      // 3. Compara a query com os textos reais que estão na tela
      return displayTitle.toLowerCase().contains(query) ||
          displayDate.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    final allSessions = widget.trainingState.sessions;

    if (allSessions.isEmpty) {
      return const EmptyTrainingComponent();
    }

    // Auto-carrega ends da primeira sessão na abertura
    if (_loadedSessionId != allSessions.first.sessionId &&
        _expandedSessionId == null) {
      _loadedSessionId = allSessions.first.sessionId;
      _expandedSessionId = allSessions.first.sessionId;
      Future.microtask(
        () => Modular.get<TrainingAction>().watchEnds(allSessions.first),
      );
    }

    final filtered = _filter(allSessions);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        // ── CTA card (Iniciar treino) ─────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Iniciar treino',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Comece uma nova sessão de treino agora',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () =>
                      Modular.to.pushNamed('/training/register-end'),
                  style: FilledButton.styleFrom(
                    backgroundColor: c.brandPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Iniciar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // ── Section header ────────────────────────────────────────────
        Text(
          'Histórico de treinos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        // ── Empty search result ───────────────────────────────────────
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Center(
              child: Text(
                'Nenhum treino encontrado para "${widget.searchQuery}"',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textSecondary, fontSize: 14),
              ),
            ),
          )
        else
          // ── Session cards ───────────────────────────────────────────
          ...filtered.map((session) {
            final isExpanded = session.sessionId == _expandedSessionId;
            return TrainingCardComponent(
              key: ValueKey(session.sessionId),
              session: session,
              isHighlighted: isExpanded,
              ends: isExpanded ? widget.trainingState.ends.toList() : const [],
              onTap: () => _handleCardTap(session),
            );
          }),
      ],
    );
  }
}
