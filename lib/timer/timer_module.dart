import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/timer/pages/timer_config_page.dart';
import 'package:mob_archery/timer/pages/timer_page.dart';

class TimerModule extends Module {
  @override
  void routes(RouteManager routeManager) {
    routeManager
      ..child('/', child: (_) => const TimerPage())
      ..child('/config', child: (_) => const TimerConfigPage());
  }
}
