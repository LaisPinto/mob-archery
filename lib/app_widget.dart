import 'package:asuka/asuka.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/accessibility/stores/accessibility_state.dart';
import 'package:mob_archery/app/modules/core/theme/app_theme.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late final AccessibilityState accessibilityState;

  @override
  void initState() {
    super.initState();
    accessibilityState = Modular.get<AccessibilityState>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isHighContrast = accessibilityState.isHighContrastEnabled.value;
        final isDarkMode = accessibilityState.isDarkModeEnabled.value;
        final double textScale = accessibilityState.textScaleFactor.value;

        final ThemeMode themeMode = isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light;

        return MaterialApp.router(
          title: 'Mob Archery',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.instance.buildTheme(
            brightness: Brightness.light,
            highContrast: isHighContrast,
          ),
          darkTheme: AppTheme.instance.buildTheme(
            brightness: Brightness.dark,
            highContrast: isHighContrast,
          ),
          themeMode: themeMode,
          routerConfig: Modular.routerConfig,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Asuka.builder(context, child),
          ),
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
        );
      },
    );
  }
}
