import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/profile/pages/account_data_page.dart';
import 'package:mob_archery/app/modules/profile/pages/profile_page.dart';

class ProfileModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (_) => const ProfilePage())
      ..child('/account-data', child: (_) => const AccountDataPage());
  }
}
