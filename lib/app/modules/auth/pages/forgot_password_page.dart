import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../_export_auth.dart';
import 'package:mob_archery/app/modules/core/component/app_snackbar.dart'
    show showErrorSnackbar, showSuccessSnackbar;
import 'package:mob_archery/translations/locale_keys.g.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final AuthAction _authAction;
  late final AuthState _authState;
  late final TextEditingController _emailController;
  late final ReactionDisposer _feedbackReactionDisposer;

  @override
  void initState() {
    super.initState();

    // add normal methods (not async)
    _authAction = Modular.get<AuthAction>();
    _authState = Modular.get<AuthState>();
    _emailController = TextEditingController();

    _feedbackReactionDisposer = reaction(
      (_) => (_authState.errorMessage, _authState.infoMessage),
      ((String?, String?) messages) {
        final (error, info) = messages;
        if (error != null) showErrorSnackbar(error);
        if (info != null) {
          showSuccessSnackbar(info);
          _navigateToEmailVerification();
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // add async methods
    });
  }

  @override
  void didUpdateWidget(covariant ForgotPasswordPage oldWidget) {
    // Only if necessary
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _feedbackReactionDisposer();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _navigateBack),
        title: Text(
          LocaleKeys.modules_auth_forgot_password_account_recovery_title.tr(),
          style: const TextStyle(
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
                  controller: _emailController,
                  decoration: InputDecoration(hintText: LocaleKeys.modules_auth_login_email_label.tr()),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _authState.isLoading
                      ? null
                      : () => _authAction.sendPasswordReset(
                          _emailController.text,
                        ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEC5B13),
                    foregroundColor: Colors.white,
                  ),
                  child: _authState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          LocaleKeys
                              .modules_auth_forgot_password_send_link_button
                              .tr(),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
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

  void _navigateToEmailVerification() =>
      Modular.to.navigate('/auth/email-verification');
  void _navigateBack() => Modular.to.pop();
}
