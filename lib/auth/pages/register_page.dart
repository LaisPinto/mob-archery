import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'package:mob_archery/auth/services/auth_form_service.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart';
import 'package:mob_archery/profile/enums/supported_language.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthAction authAction;
  late final AuthState authState;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController disciplineController;
  late final TextEditingController passwordController;
  String? localErrorMessage;
  bool acceptedTerms = false;
  SupportedLanguage supportedLanguage = SupportedLanguage.portugueseBrazil;
  ReactionDisposer? _errorReaction;

  @override
  void initState() {
    super.initState();
    authAction = Modular.get<AuthAction>();
    authState = Modular.get<AuthState>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    disciplineController = TextEditingController(text: 'Arquearia');
    passwordController = TextEditingController();

    _errorReaction = reaction((_) => authState.errorMessage.value, (
      String? message,
    ) {
      if (message != null) showErrorSnackbar(message);
    });
  }

  @override
  void dispose() {
    _errorReaction?.call();
    nameController.dispose();
    emailController.dispose();
    disciplineController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB4BBCC), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFFAFBFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE4E9F2), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF5C00), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Modular.to.pop),
        title: const Text(
          'Criar conta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A2030),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Observer(
            builder: (_) {
              final isLoading = authState.isLoading.value;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Junte-se à Mob Archery',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Preencha os dados abaixo para começar sua jornada no tiro com arco.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFEC5B13),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: _inputDecoration('Nome'),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('E-mail'),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: disciplineController,
                      decoration: _inputDecoration('Modalidade'),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration('Senha'),
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(
                      value: (passwordController.text.length / 12).clamp(0, 1),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(9999),
                      backgroundColor: const Color(0xFFF0E6E0),
                      color: const Color(0xFFFF5C00),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF64748B),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            LocaleKeys.modules_auth_register_password_hint.tr(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: const Color(0xFF64748B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: acceptedTerms,
                            onChanged: (value) =>
                                setState(() => acceptedTerms = value ?? false),
                            activeColor: const Color(0xFFFF5C00),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: const Color(0xFF6B7A99),
                                    height: 1.5,
                                    fontSize: 14,
                                  ),
                              children: const [
                                TextSpan(text: 'Li e aceito os '),
                                TextSpan(
                                  text: 'Termos de Uso',
                                  style: TextStyle(
                                    color: Color(0xFFFF5C00),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' e a '),
                                TextSpan(
                                  text: 'Política de Privacidade',
                                  style: TextStyle(
                                    color: Color(0xFFFF5C00),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final validationMessage =
                                  Modular.get<AuthFormService>()
                                      .validatePassword(
                                        passwordController.text,
                                      );

                              if (!acceptedTerms) {
                                setState(() {
                                  localErrorMessage =
                                      'Aceite os termos para continuar.';
                                });
                                return;
                              }

                              if (validationMessage != null) {
                                setState(() {
                                  localErrorMessage = validationMessage;
                                });
                                return;
                              }

                              setState(() => localErrorMessage = null);
                              authAction.register(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                preferredLanguage: supportedLanguage.localeCode,
                              );
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5C00),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              LocaleKeys.modules_auth_register_create_button
                                  .tr(),
                            ),
                    ),
                    if (localErrorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        localErrorMessage!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
