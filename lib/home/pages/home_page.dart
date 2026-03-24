import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/home/services/home_summary_service.dart';
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

  @override
  void initState() {
    super.initState();
    authAction = Modular.get<AuthAction>();
    authState = Modular.get<AuthState>();
    trainingAction = Modular.get<TrainingAction>();
    trainingState = Modular.get<TrainingState>();
    homeSummaryService = Modular.get<HomeSummaryService>();
    trainingAction.watchSessions();
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool highlighted = false,
    bool disabled = false,
  }) {
    final foreground = highlighted ? Colors.white : const Color(0xFF1A2238);
    final subtitleColor = highlighted ? Colors.white70 : const Color(0xFF6B7A99);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: disabled ? null : onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: disabled
              ? const Color(0xFFF1F4F9)
              : highlighted
                  ? const Color(0xFFFF5C00)
                  : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE7EAF0)),
          boxShadow: highlighted
              ? const [
                  BoxShadow(
                    color: Color(0x33FF5C00),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: highlighted ? const Color(0x33FFFFFF) : const Color(0xFFFFEFE6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: highlighted ? Colors.white : const Color(0xFFFF5C00)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (disabled) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1E6EF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            LocaleKeys.modules_home_dashboard_coming_soon.tr(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7E8DA8),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: subtitleColor, height: 1.35),
                  ),
                ],
              ),
            ),
            Icon(
              disabled ? Icons.lock_outline : Icons.chevron_right_rounded,
              color: highlighted ? Colors.white : const Color(0xFF9AA7BC),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barChart() {
    const values = [28.0, 48.0, 22.0, 68.0, 84.0, 36.0, 12.0];
    const labels = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.modules_home_dashboard_weekly_progress.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                LocaleKeys.modules_home_dashboard_see_all.tr(),
                style: const TextStyle(
                  color: Color(0xFFFF5C00),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                final isSelected = index == 4;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: values[index],
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF5C00)
                                : const Color(0xFFFFD9C6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          labels[index],
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFFFF5C00)
                                : const Color(0xFF93A0B8),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final summary =
                homeSummaryService.buildSummary(trainingState.sessions.toList());
            final userName = authState.userProfile.value?.name ?? 'Julia';

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE3D4),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(Icons.person, color: Color(0xFFFF5C00)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.modules_home_dashboard_welcome_back.tr(),
                            style: const TextStyle(color: Color(0xFF7C8AA5)),
                          ),
                          Text(
                            'Ola, $userName',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await authAction.signOut();
                        Modular.to.navigate('/auth/login');
                      },
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE7EAF0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.modules_home_dashboard_day_status.tr(),
                        style: const TextStyle(
                          color: Color(0xFFFF5C00),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Color(0xFF1A2238)),
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
                          backgroundColor: const Color(0xFFF1F4F9),
                          color: const Color(0xFFFF5C00),
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
                Text(
                  LocaleKeys.modules_home_dashboard_quick_access.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                _quickAction(
                  icon: Icons.timer_outlined,
                  title: 'Temporizador',
                  subtitle: 'Iniciar nova rodada de treino',
                  highlighted: true,
                  onTap: () => Modular.to.pushNamed('/timer/'),
                ),
                const SizedBox(height: 12),
                _quickAction(
                  icon: Icons.edit_note_rounded,
                  title: 'Registrar End',
                  subtitle: 'Logar resultados da sessao',
                  onTap: () => Modular.to.pushNamed('/training/register-end'),
                ),
                const SizedBox(height: 12),
                _quickAction(
                  icon: Icons.sports_martial_arts_outlined,
                  title: 'Embates',
                  subtitle: 'Desafie outros arqueiros',
                  disabled: true,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _barChart(),
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
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF7C8AA5))),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
