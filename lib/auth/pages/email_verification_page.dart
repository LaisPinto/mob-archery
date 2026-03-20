import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/enums/auth_status.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart';

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

    _statusReaction = reaction(
      (_) => authState.authStatus.value,
      (AuthStatus status) {
        if (status == AuthStatus.authenticated) {
          _verificationTimer?.cancel();
          Modular.to.navigate('/home/');
        }
      },
    );

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
      appBar: AppBar(leading: BackButton(onPressed: () => Modular.to.navigate('/auth/login'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 168,
                    height: 168,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEE5),
                      borderRadius: BorderRadius.circular(84),
                    ),
                    child: Center(
                      child: Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5C00),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33FF5C00),
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Verifique seu e-mail',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Enviamos um link de verificacao para o seu endereco de e-mail cadastrado. Por favor, verifique sua caixa de entrada.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6B7A99),
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F5FA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'E-mail enviado para ${authState.authUser.value?.email ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: authState.isLoading.value
                      ? null
                      : () => Modular.to.navigate('/auth/login'),
                  child: const Text('Voltar ao login'),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Nao recebeu o e-mail?',
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
                        ),
                        child: const Text('Reenviar link'),
                      ),
                    ],
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