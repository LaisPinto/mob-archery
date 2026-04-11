import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../_export_auth.dart';
import 'package:mob_archery/app/modules/core/component/app_snackbar.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late final AuthAction _authAction;
  late final AuthState _authState;

  late final ReactionDisposer _statusReactionDisposer;
  late final ReactionDisposer _feedbackReactionDisposer;
  Timer? _verificationTimer;

  @override
  void initState() {
    super.initState();

    // add normal methods (not async)
    _authAction = Modular.get<AuthAction>();
    _authState = Modular.get<AuthState>();

    _statusReactionDisposer = reaction((_) => _authState.authStatus, (
      AuthStatus status,
    ) {
      if (status == AuthStatus.authenticated) {
        _verificationTimer?.cancel();
        Modular.to.navigate('/home/');
      }
    });

    _feedbackReactionDisposer = reaction(
      (_) => (_authState.errorMessage, _authState.infoMessage),
      ((String?, String?) messages) {
        final (error, info) = messages;
        if (error != null) showErrorSnackbar(error);
        if (info != null) showSuccessSnackbar(info);
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // add async methods
      _verificationTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _authAction.reloadCurrentUser(),
      );
    });
  }

  @override
  void didUpdateWidget(covariant EmailVerificationPage oldWidget) {
    // Only if necessary
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _statusReactionDisposer();
    _feedbackReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        leading: BackButton(
          onPressed: _navigateToLogin,
          color: const Color(0xFF0F172A),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 1),
                      Center(
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEFE6),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5C00),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF5C00,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mail_outline_rounded,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        LocaleKeys.modules_auth_verification_title.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          LocaleKeys.modules_auth_verification_sent_message
                              .tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          final authEmail = _authState.authUser?.email;
                          final email =
                              (authEmail != null && authEmail.isNotEmpty)
                              ? authEmail
                              : _authState.userProfile?.email;

                          if (email == null || email.isEmpty) {
                            return const SizedBox(height: 24);
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.modules_auth_verification_email_sent_to.tr(args: [email]),
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      const Spacer(flex: 2),
                      Observer(
                        builder: (_) => ElevatedButton(
                          onPressed: _authState.isLoading
                              ? null
                              : _openEmailApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5C00),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(
                              0xFFFF5C00,
                            ).withValues(alpha: 0.5),
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            LocaleKeys.modules_auth_verification_open_email_app.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Observer(
                        builder: (_) => OutlinedButton(
                          onPressed: _authState.isLoading
                              ? null
                              : _navigateToLogin,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F172A),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            LocaleKeys.modules_auth_verification_back_to_login
                                .tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Observer(
                        builder: (_) => Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                LocaleKeys
                                    .modules_auth_verification_not_received
                                    .tr(),
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: _authState.isLoading
                                    ? null
                                    : _authAction.resendEmailVerification,
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFFF5C00),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys
                                      .modules_auth_verification_resend_link
                                      .tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEmailApp() async {
    final candidates = defaultTargetPlatform == TargetPlatform.iOS
        ? [Uri.parse('message://')]
        : [
            Uri.parse('googlegmail://'),
            Uri.parse('com.microsoft.office.outlook://'),
            Uri.parse('mailto:'),
          ];
    for (final uri in candidates) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } catch (_) {}
    }
  }

  void _navigateToLogin() => Modular.to.navigate('/auth/login');
}
