import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/profile/pages/profile_page.dart';

class ProfileModule extends Module {
  @override
  void routes(RouteManager routeManager) {
    routeManager.child('/', child: (_) => const ProfilePage());
  }
}
