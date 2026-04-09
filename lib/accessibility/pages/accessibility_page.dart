import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/accessibility/stores/accessibility_action.dart';
import 'package:mob_archery/accessibility/stores/accessibility_state.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';
import 'package:mob_archery/core/widgets/app_bottom_navigation.dart';
import 'package:mob_archery/core/widgets/switch_card_component.dart';
import 'package:mob_archery/timer/stores/timer_action.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customColor = Theme.of(context).extension<CustomColorScheme>()!;
    final accessibilityState = Modular.get<AccessibilityState>();
    final accessibilityAction = Modular.get<AccessibilityAction>();
    final timerAction = Modular.get<TimerAction>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
      appBar: AppBar(
        title: const Text('Acessibilidade'),
        leading: BackButton(onPressed: () => Modular.to.navigate('/profile/')),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              LocaleKeys.modules_accessibility_personalize_title.tr(),
              style: TextStyle(
                color: customColor.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.modules_accessibility_personalize_subtitle.tr(),
              style: TextStyle(
                color: customColor.textSecondary,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // ── Tamanho do Texto ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: customColor.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: customColor.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.text_fields_rounded,
                        color: customColor.brandPrimaryDark,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        LocaleKeys.modules_accessibility_text_size_label.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: customColor.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Observer(
                    builder: (_) {
                      final double scale =
                          accessibilityState.textScaleFactor.value;
                      final double sliderValue = ((scale - 0.8) / 1.2)
                          .clamp(0.0, 1.0)
                          .toDouble();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: customColor.textPrimary,
                                  ),
                                ),
                                Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: customColor.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 6,
                              activeTrackColor: customColor.brandPrimaryDark,
                              thumbColor: customColor.surface,
                              inactiveTrackColor: customColor.border,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 20,
                              ),
                            ),
                            child: Slider(
                              value: sliderValue,
                              onChanged: (double v) => accessibilityAction
                                  .setTextScale(0.8 + v * 1.2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            LocaleKeys.modules_accessibility_text_size_hint
                                .tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: customColor.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Visual & Interação ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 16),
              child: Text(
                'Visual & Interação',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: customColor.textSecondary,
                ),
              ),
            ),
            Observer(
              builder: (_) => SwitchCardComponent(
                title: 'Alto Contraste',
                subtitle: 'Melhora visibilidade de textos e ícones',
                value: accessibilityState.isHighContrastEnabled.value,
                onChanged: accessibilityAction.toggleHighContrast,
              ),
            ),
            Observer(
              builder: (_) => SwitchCardComponent(
                title: 'Dark Mode',
                subtitle: 'Deixa a interface escura para economizar bateria',
                value: accessibilityState.isDarkModeEnabled.value,
                onChanged: accessibilityAction.toggleDarkMode,
              ),
            ),

            // ── Sinais de Alerta ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Sinais de Alerta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: customColor.textSecondary,
                ),
              ),
            ),
            Observer(
              builder: (_) => SwitchCardComponent(
                title: 'Sinal Sonoro',
                icon: Icons.volume_up_outlined,
                value:
                    accessibilityState.isScreenReaderAnnouncementsEnabled.value,
                onChanged: accessibilityAction.toggleScreenReaderAnnouncements,
              ),
            ),
            Observer(
              builder: (_) => SwitchCardComponent(
                title: 'Vibração Háptica',
                icon: Icons.vibration_rounded,
                value: accessibilityState.isHapticFeedbackEnabled.value,
                onChanged: accessibilityAction.toggleHapticFeedback,
              ),
            ),
            Observer(
              builder: (_) => SwitchCardComponent(
                title: 'Flash de Alerta',
                icon: Icons.flash_on_outlined,
                value: accessibilityState.isFlashEnabled.value,
                onChanged: accessibilityAction.toggleFlash,
              ),
            ),

            // ── Tempo de Reação ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Tempo de Reação',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: customColor.textSecondary,
                ),
              ),
            ),
            Observer(
              builder: (_) => SwitchCardComponent(
                title: 'Tempo Extra',
                subtitle: 'Adiciona +10s por flecha em ações temporais',
                value: accessibilityState.isAccessibleTimerEnabled.value,
                onChanged: (bool v) async {
                  await accessibilityAction.toggleAccessibleTimer(v);
                  timerAction.syncAccessibilityPreference();
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
