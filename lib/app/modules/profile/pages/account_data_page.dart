import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/app/modules/auth/stores/auth_state.dart';
import 'package:mob_archery/app/modules/core/component/app_snackbar.dart';
import 'package:mob_archery/app/modules/profile/enums/supported_language.dart';
import 'package:mob_archery/app/modules/profile/stores/profile_action.dart';
import 'package:mob_archery/app/modules/profile/stores/profile_state.dart';

class AccountDataPage extends StatefulWidget {
  const AccountDataPage({super.key});

  @override
  State<AccountDataPage> createState() => _AccountDataPageState();
}

class _AccountDataPageState extends State<AccountDataPage> {
  late final ProfileAction profileAction;
  late final ProfileState profileState;
  late final AuthState authState;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late SupportedLanguage _selectedLanguage;
  ReactionDisposer? _successReaction;
  ReactionDisposer? _errorReaction;

  @override
  void initState() {
    super.initState();
    profileAction = Modular.get<ProfileAction>();
    profileState = Modular.get<ProfileState>();
    authState = Modular.get<AuthState>();

    final profile = profileState.profile.value;
    nameController = TextEditingController(text: profile?.name ?? '');
    emailController = TextEditingController(text: authState.authUser?.email);
    passwordController = TextEditingController();
    _selectedLanguage = supportedLanguageFromLocaleCode(
      profile?.preferredLanguage ?? 'pt_BR',
    );

    _successReaction = reaction((_) => profileState.successMessage.value, (
      String? message,
    ) {
      if (message != null) {
        showSuccessSnackbar(message);
        profileAction.clearMessages();
      }
    });

    _errorReaction = reaction((_) => profileState.errorMessage.value, (
      String? message,
    ) {
      if (message != null) {
        showErrorSnackbar(message);
        profileAction.clearMessages();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _successReaction?.call();
    _errorReaction?.call();
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        leading: IconButton(
          onPressed: () => Modular.to.pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2238)),
        ),
        title: const Text(
          'Dados da conta',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A2238),
          ),
        ),
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final isLoading = profileState.isLoading.value;
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              children: [
                // ── Dados Pessoais ────────────────────────────────────────
                const Text(
                  'DADOS PESSOAIS',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  enabled: !isLoading,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration('Nome'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('E-mail'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  enabled: !isLoading,
                  obscureText: true,
                  decoration: _inputDecoration('Senha'),
                ),
                const SizedBox(height: 16),

                // ── Idioma ────────────────────────────────────────────────
                const Text(
                  'IDIOMA',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFBFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE4E9F2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SupportedLanguage>(
                      value: _selectedLanguage,
                      isExpanded: true,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() => _selectedLanguage = value);
                              }
                            },
                      items: SupportedLanguage.values.map((language) {
                        return DropdownMenuItem(
                          value: language,
                          child: Text(language.label(context)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Botão Salvar ──────────────────────────────────────────
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () => profileAction.updateAccountData(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          language: _selectedLanguage,
                        ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5C00),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(
                      0xFFFF5C00,
                    ).withValues(alpha: 0.5),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Salvar informações'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
