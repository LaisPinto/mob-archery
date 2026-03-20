import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    this.actionCode,
  });

  final String? actionCode;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final AuthAction authAction;
  late final AuthState authState;
  late final TextEditingController actionCodeController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  String? localErrorMessage;

  double get passwordStrength {
    final password = passwordController.text;
    double score = 0;
    if (password.length >= 8) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.25;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score += 0.25;
    return score;
  }

  @override
  void initState() {
    super.initState();
    authAction = Modular.get<AuthAction>();
    authState = Modular.get<AuthState>();
    actionCodeController = TextEditingController(text: widget.actionCode ?? '');
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    actionCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _requirement(bool enabled, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            size: 18,
            color: enabled ? Colors.green : const Color(0xFF8A96AD),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6B7A99)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = passwordController.text;

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: Modular.to.pop)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Nova Senha',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sua nova senha deve ser unica para proteger sua conta de arqueiro.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6B7A99),
                      ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: actionCodeController,
                  decoration: const InputDecoration(hintText: 'Codigo de acao'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(hintText: 'Nova senha'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Confirme a nova senha'),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Forca da senha',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            '${(passwordStrength * 100).round()}%',
                            style: const TextStyle(
                              color: Color(0xFFFF5C00),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: passwordStrength,
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(999),
                        backgroundColor: const Color(0xFFDCE5F2),
                        color: const Color(0xFFFF5C00),
                      ),
                      const SizedBox(height: 14),
                      _requirement(password.length >= 8, 'Minimo de 8 caracteres'),
                      _requirement(RegExp(r'[A-Z]').hasMatch(password), 'Pelo menos uma letra maiuscula'),
                      _requirement(
                        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password),
                        'Um caractere especial (@, #, !, %)',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: authState.isLoading.value
                      ? null
                      : () async {
                          if (passwordController.text != confirmPasswordController.text) {
                            setState(() {
                              localErrorMessage = 'As senhas nao coincidem.';
                            });
                            return;
                          }
                          setState(() => localErrorMessage = null);
                          await authAction.confirmPasswordReset(
                            actionCode: actionCodeController.text.trim(),
                            newPassword: passwordController.text,
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5C00),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('REDEFINIR SENHA'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Modular.to.navigate('/auth/login'),
                  child: const Text('Cancelar e voltar ao login'),
                ),
                if (localErrorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(localErrorMessage!, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
