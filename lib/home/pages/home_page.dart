import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'dart:io';

import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/home/services/home_summary_service.dart';
import 'package:mob_archery/profile/stores/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mob_archery/training/stores/training_action.dart';
import 'package:mob_archery/training/stores/training_state.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthAction authAction;
  late final AuthState authState;
  late final TrainingAction trainingAction;
  late final TrainingState trainingState;
  late final HomeSummaryService homeSummaryService;
  late final ProfileState profileState;

  static const _imagePathKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    authAction = Modular.get<AuthAction>();
    authState = Modular.get<AuthState>();
    trainingAction = Modular.get<TrainingAction>();
    trainingState = Modular.get<TrainingState>();
    homeSummaryService = Modular.get<HomeSummaryService>();
    profileState = Modular.get<ProfileState>();
    trainingAction.watchSessions();
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

  Widget _quickAction({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool highlighted = false,
    bool disabled = false,
  }) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    final cardColor = disabled
        ? c.surfaceVariant
        : highlighted
        ? c.brandPrimary
        : c.surface;

    final iconBoxColor = disabled
        ? c.border
        : highlighted
        ? c.buttonPrimaryForeground.withValues(alpha: 0.2)
        : c.brandPrimaryLight;

    final titleColor = disabled
        ? c.textTertiary
        : highlighted
        ? c.buttonPrimaryForeground
        : c.textPrimary;

    final subtitleColor = highlighted
        ? c.buttonPrimaryForeground.withValues(alpha: 0.8)
        : c.textSecondary;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: disabled ? null : onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: disabled ? c.border : c.border),
          boxShadow: highlighted
              ? [
                  BoxShadow(
                    color: c.shadow.withValues(alpha: 0.2),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBoxColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: disabled
                    ? c.textTertiary
                    : highlighted
                    ? c.buttonPrimaryForeground
                    : c.brandPrimaryDark,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (disabled) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: c.border,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'EM BREVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: c.textTertiary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: subtitleColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              disabled
                  ? Icons.lock_outline_rounded
                  : Icons.chevron_right_rounded,
              color: highlighted ? c.buttonPrimaryForeground : c.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final summary = homeSummaryService.buildSummary(
              trainingState.sessions.toList(),
            );
            final userName = authState.userProfile.value?.name ?? ' ';
            final hasData = summary.sessionCount > 0;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c.brandPrimaryLight,
                        borderRadius: BorderRadius.circular(22),
                        image: profileState.localProfileImagePath.value != null
                            ? DecorationImage(
                                image: FileImage(
                                  File(
                                    profileState.localProfileImagePath.value!,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: profileState.localProfileImagePath.value == null
                          ? Icon(Icons.person, color: c.iconPrimary)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.modules_home_dashboard_welcome_back.tr(),
                            style: TextStyle(
                              color: c.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Ola, $userName',
                            style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (hasData) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: c.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.modules_home_dashboard_day_status.tr(),
                          style: TextStyle(
                            color: c.brandPrimary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: c.textPrimary),
                            children: [
                              TextSpan(
                                text: '${summary.totalArrows}',
                                style: const TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const TextSpan(
                                text: ' flechas',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: (summary.totalArrows / 72).clamp(0, 1),
                            minHeight: 8,
                            backgroundColor: c.border,
                            color: c.brandPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoStat(
                                label: 'Melhor media',
                                value: summary.averageScore.toStringAsFixed(1),
                              ),
                            ),
                            Expanded(
                              child: _InfoStat(
                                label: 'Sessoes',
                                value: '${summary.sessionCount}',
                                alignEnd: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
                if (!hasData) ...[
                  Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 256,
                          height: 200.5,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: c.brandPrimaryLight,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.radar,
                                  size: 100,
                                  color: c.brandPrimaryDark.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: c.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.edit_calendar_outlined,
                                    color: c.brandPrimaryDark,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Nenhum treino registrado ainda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: c.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Que tal começar agora? Organize suas sessões de tiro com arco e acompanhe sua evolução técnica.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
                Text(
                  LocaleKeys.modules_home_dashboard_quick_access.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _quickAction(
                  context: context,
                  icon: Icons.timer_outlined,
                  title: 'Temporizador',
                  subtitle: 'Iniciar nova rodada de treino',
                  highlighted: true,
                  onTap: () => Modular.to.pushNamed('/timer/'),
                ),
                const SizedBox(height: 12),
                _quickAction(
                  context: context,
                  icon: Icons.edit_note_rounded,
                  title: 'Registrar End',
                  subtitle: 'Logar resultados da sessão',
                  onTap: () => Modular.to.pushNamed('/training/training_page'),
                ),
                const SizedBox(height: 12),
                _quickAction(
                  context: context,
                  icon: Icons.sports_martial_arts_outlined,
                  title: 'Embates',
                  subtitle: 'Desafie outros arqueiros',
                  disabled: true,
                  onTap: () {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  const _InfoStat({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<CustomColorScheme>()!;
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: c.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }
}
