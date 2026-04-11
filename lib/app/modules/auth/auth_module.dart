import 'package:flutter_modular/flutter_modular.dart';

import 'pages/email_verification_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/reset_password_page.dart';

/// [AuthModule] is a module that sets up the dependency injection and routes.
class AuthModule extends Module {
  @override
  void routes(RouteManager r) => r
    ..child('/login', child: (final _) => const LoginPage())
    ..child('/register', child: (final _) => const RegisterPage())
    ..child('/forgot-password', child: (final _) => const ForgotPasswordPage())
    ..child(
      '/email-verification',
      child: (final _) => const EmailVerificationPage(),
    )
    ..child(
      '/reset-password',
      child: (final _) {
        final data = Modular.args.data;
        final actionCode = data is Map ? data['actionCode'] as String? : null;
        return ResetPasswordPage(actionCode: actionCode);
      },
    );
}
