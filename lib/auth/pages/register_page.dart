import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/components/auth_form_card.dart';
import 'package:mob_archery/auth/components/auth_header.dart';
import 'package:mob_archery/auth/services/auth_form_service.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/component/app_snackbar.dart';
import 'package:mob_archery/profile/enums/supported_language.dart';

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

    _errorReaction = reaction(
      (_) => authState.errorMessage.value,
      (String? message) {
        if (message != null) showErrorSnackbar(message);
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: Modular.to.pop)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Observer(
            builder: (_) {
              final isLoading = authState.isLoading.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: 'Junte-se a Mob Archery',
                    subtitle: 'Preencha os dados abaixo para comecar sua jornada no tiro com arco.',
                  ),
                  AuthFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(hintText: 'Nome'),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(hintText: 'E-mail'),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: disciplineController,
                          decoration: const InputDecoration(hintText: 'Arquearia'),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(hintText: 'Senha'),
                        ),
                        const SizedBox(height: 14),
                        LinearProgressIndicator(
                          value: (passwordController.text.length / 12).clamp(0, 1),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(999),
                          backgroundColor: const Color(0xFFF4D9CC),
                          color: const Color(0xFFFF5C00),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use pelo menos 8 caracteres com letras e numeros',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF7C8AA5),
                              ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<SupportedLanguage>(
                          value: supportedLanguage,
                          decoration: const InputDecoration(
                            labelText: 'Idioma preferido',
                          ),
                          items: SupportedLanguage.values
                              .map(
                                (language) => DropdownMenuItem(
                                  value: language,
                                  child: Text(language.label(context)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => supportedLanguage = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          value: acceptedTerms,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() => acceptedTerms = value ?? false);
                          },
                          title: const Text(
                            'Eu aceito os Termos de Uso e a Politica de Privacidade.',
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  final validationMessage = Modular
                                      .get<AuthFormService>()
                                      .validatePassword(passwordController.text);

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
                              : const Text('Criar minha conta'),
                        ),
                        if (localErrorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            localErrorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
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
