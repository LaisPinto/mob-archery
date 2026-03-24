import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/components/auth_form_card.dart';
import 'package:mob_archery/auth/components/auth_header.dart';
import 'package:mob_archery/auth/enums/auth_status.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart';
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

    authReaction = reaction(
      (_) => authState.authStatus.value,
      (AuthStatus authStatus) {
        if (authStatus == AuthStatus.authenticated) {
          Modular.to.navigate('/home/');
        } else if (authStatus == AuthStatus.emailVerificationPending) {
          Modular.to.navigate('/auth/email-verification');
        }
      },
    );

    _errorReaction = reaction(
      (_) => authState.errorMessage.value,
      (String? message) {
        if (message != null) showErrorSnackbar(message);
      },
    );
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Observer(
            builder: (_) {
              final isLoading = authState.isLoading.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const AuthHeader(
                    centered: true,
                    title: 'Mob Archery',
                    subtitle: 'Treino de elite para arqueiros',
                  ),
                  const SizedBox(height: 20),
                  AuthFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.modules_auth_login_email_label.tr(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.modules_auth_login_password_label.tr(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () => Modular.to.pushNamed('/auth/forgot-password'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFF5C00),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(LocaleKeys.modules_auth_forgot_password_button.tr()),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FilledButton(
                          onPressed: isLoading
                              ? null
                              : () => authAction.signIn(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5C00),
                            foregroundColor: Colors.white,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(LocaleKeys.modules_auth_login_button.tr()),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nao tem uma conta?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF6B7A99),
                                  ),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Modular.to.pushNamed('/auth/register'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFFF5C00),
                              ),
                              child: const Text('Criar conta'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'ou continue com',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF93A0B8),
                                    ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: null,
                          child: const Text('Google'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: null,
                          child: const Text('Apple'),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4ED),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFFFDCC9)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.accessibility_new_rounded,
                                color: Color(0xFFFF5C00),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Acessibilidade: ative o modo acessivel a qualquer momento nas configuracoes.',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF5C657A),
                                        height: 1.4,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
