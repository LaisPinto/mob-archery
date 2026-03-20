import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/training/enums/registered_by.dart';
import 'package:mob_archery/training/models/training_session_model.dart';
import 'package:mob_archery/training/pages/register_end_page.dart';
import 'package:mob_archery/training/pages/spotter_page.dart';
import 'package:mob_archery/training/pages/training_detail_page.dart';
import 'package:mob_archery/training/pages/training_history_page.dart';

class TrainingModule extends Module {
  @override
  void routes(RouteManager routeManager) {
    routeManager
      ..child(
        '/register-end',
        child: (_) {
          final data = Modular.args.data as Map?;
          final registeredByValue = data?['registeredBy'] as String?;
          final registeredBy = RegisteredBy.values.firstWhere(
            (value) => value.name == registeredByValue,
            orElse: () => RegisteredBy.user,
          );

          return RegisterEndPage(
            registeredBy: registeredBy,
            spotterName: data?['spotterName'] as String?,
          );
        },
      )
      ..child('/spotter', child: (_) => const SpotterPage())
      ..child('/history', child: (_) => const TrainingHistoryPage())
      ..child(
        '/detail',
        child: (_) => TrainingDetailPage(
          session: Modular.args.data as TrainingSessionModel,
        ),
      );
  }
}
