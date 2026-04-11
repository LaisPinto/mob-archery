import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/timer/pages/timer_config_page.dart';
import 'package:mob_archery/app/modules/timer/pages/timer_list_page.dart';
import 'package:mob_archery/app/modules/timer/pages/timer_run_page.dart';

class TimerModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (_) => const TimerListPage())
      ..child('/config', child: (_) => const TimerConfigPage())
      ..child('/run', child: (_) => const TimerRunPage());
  }
}