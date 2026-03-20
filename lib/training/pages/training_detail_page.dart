import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mob_archery/training/components/session_metric_chip.dart';
import 'package:mob_archery/training/models/training_session_model.dart';
import 'package:mob_archery/training/stores/training_action.dart';
import 'package:mob_archery/training/stores/training_state.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class TrainingDetailPage extends StatefulWidget {
  const TrainingDetailPage({
    super.key,
    required this.session,
  });

  final TrainingSessionModel session;

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  late final TrainingAction trainingAction;
  late final TrainingState trainingState;

  @override
  void initState() {
    super.initState();
    trainingAction = Modular.get<TrainingAction>();
    trainingState = Modular.get<TrainingState>();
    trainingAction.watchEnds(widget.session);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd(context.locale.toString());

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.training_detail_title.tr())),
      body: SafeArea(
        child: Observer(
          builder: (_) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                dateFormat.format(widget.session.date),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SessionMetricChip(
                    label: LocaleKeys.training_average.tr(),
                    value: widget.session.averageScore.toStringAsFixed(2),
                  ),
                  SessionMetricChip(
                    label: LocaleKeys.training_total_arrows.tr(),
                    value: '${widget.session.totalArrows}',
                  ),
                  SessionMetricChip(
                    label: LocaleKeys.training_x_count.tr(),
                    value: '${widget.session.xCount}',
                  ),
                  SessionMetricChip(
                    label: LocaleKeys.training_ten_count.tr(),
                    value: '${widget.session.tenCount}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.training_ends.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              for (final end in trainingState.ends) ...[
                Card(
                  child: ListTile(
                    title: Text(end.arrows.join(' - ')),
                    subtitle: Text(
                      LocaleKeys.training_detail_end_summary.tr(
                        args: [
                          end.averageScore.toStringAsFixed(2),
                          end.distance.toStringAsFixed(0),
                          end.bowType,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
