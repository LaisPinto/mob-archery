import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/components/auth_form_card.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart' show showErrorSnackbar, showSuccessSnackbar;

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
        if (info != null) showSuccessSnackbar(info);
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
      appBar: AppBar(leading: BackButton(onPressed: Modular.to.pop)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: AuthFormCard(
            child: Observer(
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Esqueceu sua senha?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nao se preocupe, acontece com os melhores arqueiros. Insira seu e-mail abaixo e enviaremos as instrucoes para redefinir sua senha.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF6B7A99),
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'E-MAIL CADASTRADO',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFFFF5C00),
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: authState.isLoading.value
                        ? null
                        : () => authAction.sendPasswordReset(emailController.text),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5C00),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Enviar Link de Recuperacao'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
