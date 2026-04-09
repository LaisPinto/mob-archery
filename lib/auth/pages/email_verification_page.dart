import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/enums/auth_status.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late final AuthAction authAction;
  late final AuthState authState;
  ReactionDisposer? _statusReaction;
  ReactionDisposer? _feedbackReaction;
  Timer? _verificationTimer;

  @override
  void initState() {
    super.initState();
    authAction = Modular.get<AuthAction>();
    authState = Modular.get<AuthState>();

    _statusReaction = reaction((_) => authState.authStatus.value, (
      AuthStatus status,
    ) {
      if (status == AuthStatus.authenticated) {
        _verificationTimer?.cancel();
        Modular.to.navigate('/home/');
      }
    });

    _feedbackReaction = reaction(
      (_) => (authState.errorMessage.value, authState.infoMessage.value),
      ((String?, String?) messages) {
        final (error, info) = messages;
        if (error != null) showErrorSnackbar(error);
        if (info != null) showSuccessSnackbar(info);
      },
    );

    _verificationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => authAction.reloadCurrentUser(),
    );
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _statusReaction?.call();
    _feedbackReaction?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Modular.to.navigate('/auth/login'),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                Center(
                  child: Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEE5),
                      borderRadius: BorderRadius.circular(96),
                    ),
                    child: Center(
                      child: Container(
                        width: 98,
                        height: 88,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5C00),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x26FF5C00),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white,
                          size: 55,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  LocaleKeys.modules_auth_verification_title.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    LocaleKeys.modules_auth_verification_sent_message.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ),
                if (authState.authUser.value?.email
                    case final String email) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F5FA),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'E-mail enviado para $email',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF4A5568),
                        ),
                      ),
                    ),
                  ),
                ],
                const Spacer(flex: 40),
                ElevatedButton(
                  onPressed: authState.isLoading.value
                      ? null
                      : () => launchUrl(
                          Uri.parse('mailto:'),
                          mode: LaunchMode.externalApplication,
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5C00),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(
                      0xFFFF5C00,
                    ).withValues(alpha: 0.5),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Abrir app de e-mail'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: authState.isLoading.value
                      ? null
                      : () => Modular.to.navigate('/auth/login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4A5568),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.modules_auth_verification_back_to_login.tr(),
                  ),
                ),
                const SizedBox(height: 48),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.modules_auth_verification_not_received.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF7C8AA5),
                        ),
                      ),
                      TextButton(
                        onPressed: authState.isLoading.value
                            ? null
                            : authAction.resendEmailVerification,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFF5C00),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        child: Text(
                          LocaleKeys.modules_auth_verification_resend_link.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
