import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/core/component/app_snackbar.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/profile/enums/supported_language.dart';
import 'package:mob_archery/profile/stores/profile_action.dart';
import 'package:mob_archery/profile/stores/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileAction profileAction;
  late final ProfileState profileState;
  late final AuthAction authAction;

  static const _imagePathKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    profileAction = Modular.get<ProfileAction>();
    profileState = Modular.get<ProfileState>();
    authAction = Modular.get<AuthAction>();
    profileAction.loadProfile();
    _restoreImagePath();
  }

  Future<void> _restoreImagePath() async {
    if (profileState.localProfileImagePath.value != null) return;
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_imagePathKey);
    if (savedPath != null && File(savedPath).existsSync()) {
      runInAction(() => profileState.localProfileImagePath.value = savedPath);
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_imagePathKey, picked.path);
      runInAction(() => profileState.localProfileImagePath.value = picked.path);
      showSuccessSnackbar('Sua foto de perfil foi atualizada com sucesso!');
    } catch (_) {
      showErrorSnackbar('Não foi possível atualizar a foto');
    }
  }

  Widget _menuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: c.brandPrimaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c.iconPrimary, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: c.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: c.textSecondary),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final profile = profileState.profile.value;
            final userName = profile?.name ?? 'Júlia';

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Modular.to.navigate('/home/'),
                      icon: Icon(Icons.arrow_back, color: c.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Perfil',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: c.brandPrimaryLight,
                                shape: BoxShape.circle,
                                image: profileState.localProfileImagePath.value != null
                                    ? DecorationImage(
                                        image: FileImage(
                                          File(profileState.localProfileImagePath.value!),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: profileState.localProfileImagePath.value == null
                                  ? Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 44,
                                      color: c.brandPrimaryDark,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: c.brandPrimary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: c.surface,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: c.buttonPrimaryForeground,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                Text(
                  'CONFIGURAÇÕES DO APP',
                  style: TextStyle(
                    color: c.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                _menuTile(
                  context: context,
                  icon: Icons.person_rounded,
                  title: 'Dados da conta',
                  subtitle: 'Idioma: ${supportedLanguageFromLocaleCode(profile?.preferredLanguage ?? 'en_US').label(context)}',
                  onTap: () => Modular.to.pushNamed('/profile/account-data'),
                ),
                _menuTile(
                  context: context,
                  icon: Icons.architecture_rounded,
                  title: 'Acessibilidade',
                  subtitle: 'Configurações acessíveis',
                  onTap: () => Modular.to.pushNamed('/accessibility/'),
                ),
                _menuTile(
                  context: context,
                  icon: Icons.security,
                  title: 'Privacidade e Segurança',
                  subtitle: 'Dados e permissões',
                  onTap: () {},
                ),

                const SizedBox(height: 12),
                Divider(color: c.divider),
                const SizedBox(height: 24),

                InkWell(
                  onTap: () async {
                    await authAction.signOut();
                    Modular.to.navigate('/auth/login');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, color: c.error, size: 28),
                        const SizedBox(width: 32),
                        Text(
                          'Sair da conta',
                          style: TextStyle(
                            color: c.error,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}