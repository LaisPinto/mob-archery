import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/training/pages/register_end_page.dart';
import 'package:mob_archery/app/modules/training/pages/training_page.dart';

class TrainingModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (_) => const TrainingPage())
      ..child('/training_page', child: (_) => const TrainingPage())
      ..child('/history', child: (_) => const TrainingPage())
      ..child('/register-end', child: (_) => const RegisterEndPage());
  }
}
