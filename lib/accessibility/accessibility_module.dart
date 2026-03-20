import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/accessibility/pages/accessibility_page.dart';

class AccessibilityModule extends Module {
  @override
  void routes(RouteManager routeManager) {
    routeManager.child('/', child: (_) => const AccessibilityPage());
  }
}
