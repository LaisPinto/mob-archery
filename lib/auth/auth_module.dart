import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/auth/pages/email_verification_page.dart';
import 'package:mob_archery/auth/pages/forgot_password_page.dart';
import 'package:mob_archery/auth/pages/login_page.dart';
import 'package:mob_archery/auth/pages/register_page.dart';
import 'package:mob_archery/auth/pages/reset_password_page.dart';

class AuthModule extends Module {
  @override
  void routes(RouteManager routeManager) {
    routeManager
      ..child('/login', child: (_) => const LoginPage())
      ..child('/register', child: (_) => const RegisterPage())
      ..child('/forgot-password', child: (_) => const ForgotPasswordPage())
      ..child(
        '/email-verification',
        child: (_) => const EmailVerificationPage(),
      )
      ..child(
        '/reset-password',
        child: (_) {
          final data = Modular.args.data;
          final actionCode =
              data is Map ? data['actionCode'] as String? : null;
          return ResetPasswordPage(actionCode: actionCode);
        },
      );
  }
}
