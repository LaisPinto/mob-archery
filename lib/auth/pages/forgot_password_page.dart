import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart'
    show showErrorSnackbar, showSuccessSnackbar;
import 'package:mob_archery/translations/locale_keys.g.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final AuthAction authAction;
  late final AuthState authState;
  late final TextEditingController emailController;
  ReactionDisposer? _feedbackReaction;

  @override
  void initState() {
    super.initState();
    authAction = Modular.get<AuthAction>();
    authState = Modular.get<AuthState>();
    emailController = TextEditingController();

    _feedbackReaction = reaction(
      (_) => (authState.errorMessage.value, authState.infoMessage.value),
      ((String?, String?) messages) {
        final (error, info) = messages;
        if (error != null) showErrorSnackbar(error);
        if (info != null) {
          showSuccessSnackbar(info);
          Modular.to.navigate('/auth/email-verification');
        }
      },
    );
  }

  @override
  void dispose() {
    _feedbackReaction?.call();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Modular.to.pop),
        title: const Text(
          'Recuperação de Conta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A2030),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.modules_auth_forgot_password_page_title.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.modules_auth_forgot_password_description.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 31),
                Text(
                  LocaleKeys.modules_auth_forgot_password_email_section_label
                      .tr(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFFEC5B13),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'E-mail'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: authState.isLoading.value
                      ? null
                      : () =>
                            authAction.sendPasswordReset(emailController.text),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEC5B13),
                    foregroundColor: Colors.white,
                  ),
                  child: authState.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                    LocaleKeys.modules_auth_forgot_password_send_link_button
                        .tr(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
