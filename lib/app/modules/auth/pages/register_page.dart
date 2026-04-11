import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../_export_auth.dart';
import 'package:mob_archery/app/modules/core/component/app_snackbar.dart';
import 'package:mob_archery/app/modules/profile/enums/supported_language.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthAction _authAction;
  late final AuthState _authState;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _disciplineController;
  late final TextEditingController _passwordController;
  late final ReactionDisposer _errorReactionDisposer;

  String? _localErrorMessage;
  bool _acceptedTerms = false;
  SupportedLanguage _supportedLanguage = SupportedLanguage.portugueseBrazil;

  @override
  void initState() {
    super.initState();

    // add normal methods (not async)
    _authAction = Modular.get<AuthAction>();
    _authState = Modular.get<AuthState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _disciplineController = TextEditingController(text: 'Arquearia');
    _passwordController = TextEditingController();

    _errorReactionDisposer = reaction((_) => _authState.errorMessage, (
      String? message,
    ) {
      if (message != null) showErrorSnackbar(message);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // add async methods
    });
  }

  @override
  void didUpdateWidget(covariant RegisterPage oldWidget) {
    // Only if necessary
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _errorReactionDisposer();
    _nameController.dispose();
    _emailController.dispose();
    _disciplineController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB4BBCC), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFFF5C00), width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _navigateBack),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Observer(
            builder: (_) {
              final isLoading = _authState.isLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Junte-se à Mob Archery',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: const Color(0xFF0F172A),
                            ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preencha os dados abaixo para começar sua jornada no tiro com arco.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDecoration('Nome'),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('E-mail'),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _disciplineController,
                    decoration: _inputDecoration('Modalidade'),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                    decoration: _inputDecoration('Senha'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: List.generate(4, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
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
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _acceptedTerms,
                          onChanged: (value) =>
                              setState(() => _acceptedTerms = value ?? false),
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
                  const SizedBox(height: 24),

                  FilledButton(
                    onPressed: isLoading ? null : _handleRegister,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5C00),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.1),
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
                            LocaleKeys.modules_auth_register_create_button.tr(),
                          ),
                  ),
                  if (_localErrorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _localErrorMessage!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.red),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // handler methods
  void _handleRegister() {
    final validationMessage = Modular.get<AuthService>().validatePassword(
      _passwordController.text,
    );

    if (!_acceptedTerms) {
      setState(() {
        _localErrorMessage = 'Aceite os termos para continuar.';
      });
      return;
    }

    if (validationMessage != null) {
      setState(() {
        _localErrorMessage = validationMessage;
      });
      return;
    }

    setState(() => _localErrorMessage = null);
    _authAction.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      preferredLanguage: _supportedLanguage.localeCode,
    );
  }

  // nav methods
  void _navigateBack() => Modular.to.pop();
}
