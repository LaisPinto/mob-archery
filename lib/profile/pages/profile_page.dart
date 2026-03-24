import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/profile/enums/measurement_unit.dart';
import 'package:mob_archery/profile/enums/supported_language.dart';
import 'package:mob_archery/profile/stores/profile_action.dart';
import 'package:mob_archery/profile/stores/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileAction profileAction;
  late final ProfileState profileState;
  late final AuthAction authAction;
  late final TextEditingController nameController;

  SupportedLanguage supportedLanguage = SupportedLanguage.portugueseBrazil;
  MeasurementUnit measurementUnit = MeasurementUnit.meters;

  @override
  void initState() {
    super.initState();
    profileAction = Modular.get<ProfileAction>();
    profileState = Modular.get<ProfileState>();
    authAction = Modular.get<AuthAction>();
    nameController = TextEditingController();
    profileAction.loadProfile().then((_) {
      final profile = profileState.profile.value;
      if (profile != null) {
        nameController.text = profile.name;
        supportedLanguage = supportedLanguageFromLocaleCode(profile.preferredLanguage);
        measurementUnit = MeasurementUnit.values.firstWhere(
          (unit) => unit.firestoreValue == profile.unit,
          orElse: () => MeasurementUnit.meters,
        );
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFE6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFFFF5C00)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF6B7A99), height: 1.35),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA7BC)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
      appBar: AppBar(
        leading: BackButton(onPressed: () => Modular.to.navigate('/home/')),
        title: Text(LocaleKeys.modules_profile_title.tr()),
        actions: [
          IconButton(
            onPressed: () => Modular.to.pushNamed('/accessibility/'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final profile = profileState.profile.value;
            if (profile == null) {
              return Center(child: Text(LocaleKeys.modules_profile_errors_not_found.tr()));
            }

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0E2D7)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 118,
                        height: 118,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(59),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        LocaleKeys.modules_profile_level_label.tr(),
                        style: const TextStyle(
                          color: Color(0xFFFF5C00),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  LocaleKeys.modules_profile_app_settings_section.tr(),
                  style: const TextStyle(
                    color: Color(0xFF7587A6),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                _menuTile(
                  icon: Icons.language_rounded,
                  title: 'Preferencias',
                  subtitle: 'Idioma: ${profile.preferredLanguage} · Unidade: ${profile.unit}',
                ),
                const SizedBox(height: 12),
                _menuTile(
                  icon: Icons.architecture_rounded,
                  title: 'Equipamento',
                  subtitle: 'Gerenciar Arcos e Flechas',
                ),
                const SizedBox(height: 12),
                _menuTile(
                  icon: Icons.accessibility_new_rounded,
                  title: 'Acessibilidade',
                  subtitle: 'Ajustes visuais e temporais',
                  onTap: () => Modular.to.pushNamed('/accessibility/'),
                ),
                const SizedBox(height: 12),
                _menuTile(
                  icon: Icons.palette_outlined,
                  title: 'Tema',
                  subtitle: 'Sistema (Automatico)',
                ),
                const SizedBox(height: 12),
                _menuTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacidade e Seguranca',
                  subtitle: 'Dados e permissoes',
                ),
                const SizedBox(height: 18),
                const Divider(),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<SupportedLanguage>(
                  value: supportedLanguage,
                  decoration: const InputDecoration(labelText: 'Idioma'),
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
                DropdownButtonFormField<MeasurementUnit>(
                  value: measurementUnit,
                  decoration: const InputDecoration(labelText: 'Unidade'),
                  items: MeasurementUnit.values
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit.label(context)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => measurementUnit = value);
                    }
                  },
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: profileState.isLoading.value
                      ? null
                      : () async {
                          await profileAction.saveProfile(
                            name: nameController.text,
                            supportedLanguage: supportedLanguage,
                            measurementUnit: measurementUnit,
                          );
                          if (mounted) {
                            await context.setLocale(supportedLanguage.locale);
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5C00),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(LocaleKeys.modules_profile_save_changes_button.tr()),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () async {
                    await authAction.signOut();
                    Modular.to.navigate('/auth/login');
                  },
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFFF4B4B)),
                  label: Text(
                    LocaleKeys.modules_profile_sign_out_button.tr(),
                    style: const TextStyle(
                      color: Color(0xFFFF4B4B),
                      fontWeight: FontWeight.w700,
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
