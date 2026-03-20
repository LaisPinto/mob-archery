import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/home/pages/home_page.dart';

class HomeModule extends Module {
  @override
  void routes(RouteManager routeManager) {
    routeManager.child('/', child: (_) => const HomePage());
  }
}
