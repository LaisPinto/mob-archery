import 'package:flutter/material.dart';
import 'package:mob_archery/core/theme/custom_color_scheme.dart';

/// [AppTheme] is a singleton that builds [ThemeData] from [CustomColorScheme].
class AppTheme {
  AppTheme._();

  static final instance = AppTheme._();

  ThemeData buildTheme({
    required Brightness brightness,
    required bool highContrast,
  }) {
    if (brightness == Brightness.dark) return _buildDarkTheme();
    if (highContrast) return _buildLightHighContrastTheme();
    return _buildLightTheme();
  }

  // ── 1. TEMA CLARO ─────────────────────────────────────────────────────────
  ThemeData _buildLightTheme() {
    const c = CustomColorScheme.light;

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: c.brandPrimary,
      onPrimary: c.buttonPrimaryForeground,
      primaryContainer: c.brandPrimaryLight,
      onPrimaryContainer: c.brandPrimaryDark,
      secondary: c.brandPrimaryDark,
      onSecondary: c.buttonPrimaryForeground,
      secondaryContainer: c.brandPrimaryLight,
      onSecondaryContainer: c.brandPrimary,
      surface: c.surface,
      onSurface: c.textPrimary,
      surfaceContainerHighest: c.surfaceVariant,
      surfaceContainer: c.cardBackground,
      onSurfaceVariant: c.textSecondary,
      outline: c.textTertiary,
      outlineVariant: c.border,
      error: c.error,
      onError: c.buttonPrimaryForeground,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      tertiary: c.warning,
      onTertiary: c.buttonPrimaryForeground,
      tertiaryContainer: const Color(0xFFFFEFCC),
      onTertiaryContainer: const Color(0xFF4A3500),
      inverseSurface: c.textPrimary,
      onInverseSurface: c.surface,
      inversePrimary: c.brandPrimaryLight,
      shadow: c.shadow,
      scrim: Colors.black,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: c.background,
      extensions: const <ThemeExtension<dynamic>>[c],

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),

      iconTheme: const IconThemeData(color: Color(0xFF64748B)),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.inputBackground,
        hintStyle: TextStyle(color: c.inputHint, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.brandPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.error, width: 1.5),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.buttonPrimary,
          foregroundColor: c.buttonPrimaryForeground,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: c.buttonSecondary,
          foregroundColor: c.buttonSecondaryForeground,
          minimumSize: const Size.fromHeight(46),
          side: BorderSide(color: c.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.brandPrimary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(c.buttonPrimaryForeground),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.switchActive;
          return c.switchInactive;
        }),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.navBarBackground,
        surfaceTintColor: c.navBarBackground,
        indicatorColor: c.brandPrimaryLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c.navBarSelected,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: c.navBarUnselected,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.navBarSelected);
          }
          return IconThemeData(color: c.navBarUnselected);
        }),
      ),

      cardTheme: CardThemeData(
        color: c.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: c.border),
        ),
      ),

      dividerColor: c.divider,

      sliderTheme: SliderThemeData(
        activeTrackColor: c.brandPrimaryLight,
        inactiveTrackColor: c.border,
        thumbColor: c.surface,
        trackHeight: 6,
      ),

      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: c.textPrimary,
        displayColor: c.textPrimary,
      ),
    );
  }

  // ── 2. TEMA CLARO ALTO CONTRASTE ─────────────────────────────────────────
  ThemeData _buildLightHighContrastTheme() {
    const c = CustomColorScheme.light;
    const textStrong = Color(0xFF0A0F1E);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: c.brandPrimary,
      brightness: Brightness.light,
      contrastLevel: 1.0,
    ).copyWith(
      surface: Colors.white,
      surfaceContainer: Colors.white,
      outlineVariant: textStrong,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      extensions: <ThemeExtension<dynamic>>[
        c.copyWith(
          background: Colors.white,
          surface: Colors.white,
          cardBackground: Colors.white,
          textPrimary: textStrong,
          border: textStrong,
          divider: textStrong,
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textStrong,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textStrong,
        ),
      ),
      iconTheme: const IconThemeData(color: textStrong),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: textStrong,
        displayColor: textStrong,
      ),
    );
  }

  // ── 3. TEMA ESCURO ────────────────────────────────────────────────────────
  ThemeData _buildDarkTheme() {
    const c = CustomColorScheme.dark;

    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: c.brandPrimary,
      onPrimary: c.buttonPrimaryForeground,
      primaryContainer: c.brandPrimaryLight,
      onPrimaryContainer: c.brandPrimaryDark,
      secondary: c.brandPrimaryDark,
      onSecondary: c.buttonPrimaryForeground,
      secondaryContainer: c.brandPrimaryLight,
      onSecondaryContainer: c.brandPrimary,
      surface: c.surface,
      onSurface: c.textPrimary,
      surfaceContainerHighest: c.surfaceVariant,
      surfaceContainer: c.cardBackground,
      onSurfaceVariant: c.textSecondary,
      outline: c.textTertiary,
      outlineVariant: c.border,
      error: c.error,
      onError: c.buttonPrimaryForeground,
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      tertiary: c.warning,
      onTertiary: Colors.black,
      tertiaryContainer: const Color(0xFF4A3500),
      onTertiaryContainer: const Color(0xFFFFDEA0),
      inverseSurface: c.textPrimary,
      onInverseSurface: c.background,
      inversePrimary: c.brandPrimary,
      shadow: c.shadow,
      scrim: Colors.black,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: c.background,
      extensions: const <ThemeExtension<dynamic>>[c],

      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: c.textPrimary,
        ),
      ),

      iconTheme: IconThemeData(color: c.textPrimary),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.inputBackground,
        hintStyle: TextStyle(color: c.inputHint, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.brandPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.error, width: 1.5),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.buttonPrimary,
          foregroundColor: c.buttonPrimaryForeground,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: c.buttonSecondary,
          foregroundColor: c.buttonSecondaryForeground,
          minimumSize: const Size.fromHeight(46),
          side: BorderSide(color: c.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.brandPrimary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(c.buttonPrimaryForeground),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.switchActive;
          return c.switchInactive;
        }),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.navBarBackground,
        surfaceTintColor: c.navBarBackground,
        indicatorColor: c.brandPrimaryLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c.navBarSelected,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: c.navBarUnselected,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.navBarSelected);
          }
          return IconThemeData(color: c.navBarUnselected);
        }),
      ),

      cardTheme: CardThemeData(
        color: c.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: c.border),
        ),
      ),

      dividerColor: c.divider,

      sliderTheme: SliderThemeData(
        activeTrackColor: c.brandPrimaryDark,
        inactiveTrackColor: c.border,
        thumbColor: c.buttonSecondaryForeground,
        trackHeight: 6,
      ),

      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: c.textPrimary,
        displayColor: c.textPrimary,
      ),
    );
  }
}