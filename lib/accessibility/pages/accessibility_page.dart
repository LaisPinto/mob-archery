import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/accessibility/stores/accessibility_action.dart';
import 'package:mob_archery/accessibility/stores/accessibility_state.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/timer/stores/timer_action.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  Widget _switchCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0E2D7)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFFFF5C00)),
            const SizedBox(width: 12),
          ],
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
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityState = Modular.get<AccessibilityState>();
    final accessibilityAction = Modular.get<AccessibilityAction>();
    final timerAction = Modular.get<TimerAction>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
      appBar: AppBar(
        leading: BackButton(onPressed: () => Modular.to.navigate('/home/')),
        title: Text(LocaleKeys.modules_accessibility_title.tr()),
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) => ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.modules_accessibility_personalize_title.tr(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      LocaleKeys.modules_accessibility_personalize_subtitle.tr(),
                      style: const TextStyle(color: Color(0xFF6B7A99), height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF0E2D7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.text_fields_rounded, color: Color(0xFFFF5C00)),
                        const SizedBox(width: 10),
                        Text(
                          LocaleKeys.modules_accessibility_text_size_label.tr(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Text('A', style: TextStyle(color: Color(0xFF7C8AA5))),
                        Expanded(
                          child: Slider(
                            value: 0.6,
                            onChanged: (_) {},
                            activeColor: const Color(0xFFFF5C00),
                          ),
                        ),
                        const Text(
                          'A',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      LocaleKeys.modules_accessibility_text_size_hint.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF6B7A99)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.modules_accessibility_section_visual.tr(),
                style: const TextStyle(
                  color: Color(0xFF7587A6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              _switchCard(
                title: 'Alto Contraste',
                subtitle: 'Melhora visibilidade de textos e icones',
                value: accessibilityState.isHighContrastEnabled.value,
                onChanged: accessibilityAction.toggleHighContrast,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.modules_accessibility_section_alerts.tr(),
                style: const TextStyle(
                  color: Color(0xFF7587A6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              _switchCard(
                title: 'Sinal Sonoro',
                subtitle: 'Anuncios do leitor de tela',
                value: accessibilityState.isScreenReaderAnnouncementsEnabled.value,
                onChanged: accessibilityAction.toggleScreenReaderAnnouncements,
                icon: Icons.volume_up_outlined,
              ),
              const SizedBox(height: 12),
              _switchCard(
                title: 'Vibracao Haptica',
                subtitle: 'Feedback tactil para acoes criticas',
                value: accessibilityState.isHapticFeedbackEnabled.value,
                onChanged: accessibilityAction.toggleHapticFeedback,
                icon: Icons.vibration_rounded,
              ),
              const SizedBox(height: 12),
              _switchCard(
                title: 'Flash de Alerta',
                subtitle: 'Recurso visual em fases temporizadas',
                value: false,
                onChanged: (_) {},
                icon: Icons.flash_on_outlined,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.modules_accessibility_section_reaction.tr(),
                style: const TextStyle(
                  color: Color(0xFF7587A6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              _switchCard(
                title: 'Tempo Extra',
                subtitle: 'Adiciona +10s por flecha em acoes temporais',
                value: accessibilityState.isAccessibleTimerEnabled.value,
                onChanged: (value) async {
                  await accessibilityAction.toggleAccessibleTimer(value);
                  timerAction.syncAccessibilityPreference();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
