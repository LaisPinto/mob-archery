import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'package:mob_archery/auth/enums/auth_status.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthState authState;
  late final AuthAction authAction;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final ReactionDisposer authReaction;
  ReactionDisposer? _errorReaction;

  @override
  void initState() {
    super.initState();
    authState = Modular.get<AuthState>();
    authAction = Modular.get<AuthAction>();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    authReaction = reaction((_) => authState.authStatus.value, (
      AuthStatus authStatus,
    ) {
      if (authStatus == AuthStatus.authenticated) {
        Modular.to.navigate('/home/');
      } else if (authStatus == AuthStatus.emailVerificationPending) {
        Modular.to.navigate('/auth/email-verification');
      }
    });

    _errorReaction = reaction((_) => authState.errorMessage.value, (
      String? message,
    ) {
      if (message != null) showErrorSnackbar(message);
    });
  }

  @override
  void dispose() {
    authReaction();
    _errorReaction?.call();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final isLoading = authState.isLoading.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo_archery.png',
                          width: 100.86,
                          height: 100.63,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Mob Archery',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Treino de elite para arqueiros',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: c.brandPrimaryDark,
                                fontSize: 16,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.modules_auth_login_email_label
                            .tr(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.modules_auth_login_password_label
                            .tr(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () =>
                                  Modular.to.pushNamed('/auth/forgot-password'),
                        child: Text(
                          LocaleKeys.modules_auth_forgot_password_button.tr(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : () => authAction.signIn(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: c.buttonPrimaryForeground,
                              ),
                            )
                          : Text(LocaleKeys.modules_auth_login_button.tr()),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta?',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: c.textSecondary),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Modular.to.pushNamed('/auth/register'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 4),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Criar conta'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: c.divider)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'ou continue com',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: c.textSecondary),
                          ),
                        ),
                        Expanded(child: Divider(color: c.divider)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo_google.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text('Google'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo_apple.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text('Apple'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c.info,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.brandPrimaryLight),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.accessibility_new_rounded,
                            color: c.iconPrimary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: c.textSecondary,
                                      height: 1.5,
                                    ),
                                children: [
                                  TextSpan(
                                    text: 'Acessibilidade: ',
                                    style: TextStyle(
                                      color: c.brandPrimaryDark,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'ative o modo acessível a qualquer momento nas configurações.',
                                    style: TextStyle(
                                      color: c.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
