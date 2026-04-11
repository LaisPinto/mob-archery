import 'package:flutter/material.dart';

@immutable
class CustomColorScheme extends ThemeExtension<CustomColorScheme> {
  const CustomColorScheme({
    required this.brandPrimary,
    required this.brandPrimaryLight,
    required this.brandPrimaryDark,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.cardBackground,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.buttonPrimary,
    required this.buttonPrimaryForeground,
    required this.buttonSecondary,
    required this.buttonSecondaryForeground,
    required this.switchActive,
    required this.switchInactive,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputHint,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.shadow,
    required this.navBarBackground,
    required this.navBarSelected,
    required this.navBarUnselected,
  });

  // ── Brand ────────────────────────────────────────────────────────────────
  /// Laranja principal — CTAs, botões, ícones em destaque, nav ativo
  final Color brandPrimary;

  /// Laranja pastel — fundo de ícone, indicador da nav bar, container primário
  final Color brandPrimaryLight;

  /// Laranja escuro — accents, labels de seção, slider ativo, taglines
  final Color brandPrimaryDark;

  // ── Backgrounds & Surfaces ───────────────────────────────────────────────
  /// Fundo geral do Scaffold
  final Color background;

  /// Fundo dos cards e containers principais (branco/dark surface)
  final Color surface;

  /// Fundo alternativo — inputs de busca, email readonly, areas secundárias
  final Color surfaceVariant;

  /// Fundo de Card widget explícito
  final Color cardBackground;

  // ── Borders & Dividers ───────────────────────────────────────────────────
  /// Borda padrão de inputs, cards e containers
  final Color border;

  /// Cor dos Divider e separadores de lista
  final Color divider;

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Títulos, headings e texto principal
  final Color textPrimary;

  /// Subtítulos, labels secundários, hints de descrição
  final Color textSecondary;

  /// Texto desabilitado, placeholders e metadados terciários
  final Color textTertiary;

  // ── Icons ─────────────────────────────────────────────────────────────────
  /// Ícones em destaque (laranja)
  final Color iconPrimary;

  /// Ícones secundários e de navegação inativos
  final Color iconSecondary;

  // ── Buttons ───────────────────────────────────────────────────────────────
  /// Fundo do botão primário (FilledButton laranja)
  final Color buttonPrimary;

  /// Texto/ícone sobre o botão primário
  final Color buttonPrimaryForeground;

  /// Fundo do botão secundário (OutlinedButton branco/dark surface)
  final Color buttonSecondary;

  /// Texto/ícone sobre o botão secundário
  final Color buttonSecondaryForeground;

  // ── Switch ────────────────────────────────────────────────────────────────
  /// Track do Switch quando ativo
  final Color switchActive;

  /// Track do Switch quando inativo
  final Color switchInactive;

  // ── Inputs ────────────────────────────────────────────────────────────────
  /// Fundo de TextField
  final Color inputBackground;

  /// Borda de TextField em repouso
  final Color inputBorder;

  /// Hint text dos campos de texto
  final Color inputHint;

  // ── Semantic ──────────────────────────────────────────────────────────────
  /// Fundo do snackbar de sucesso
  final Color success;

  /// Fundo do snackbar de erro e bordas de erro
  final Color error;

  /// Cor de aviso/amber (timer warning)
  final Color warning;

  /// Fundo de caixas informativas (acessibilidade, dicas)
  final Color info;

  /// Cor base de sombra colorida (brand shadow)
  final Color shadow;

  // ── Navigation Bar ────────────────────────────────────────────────────────
  /// Fundo da bottom navigation bar
  final Color navBarBackground;

  /// Ícone e label do item selecionado na nav bar
  final Color navBarSelected;

  /// Ícone e label dos itens não selecionados na nav bar
  final Color navBarUnselected;

  // ── Presets ──────────────────────────────────────────────────────────────

  static const light = CustomColorScheme(
    brandPrimary: Color(0xFFFF5C00),
    brandPrimaryLight: Color(0xFFFFE9DC),
    brandPrimaryDark: Color(0xFFEC5B13),
    background: Color(0xFFF8F9FA),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF2F5FA),
    cardBackground: Color(0xFFFFFFFF),
    border: Color(0xFFE4E9F2),
    divider: Color(0xFFCBD5E1),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textTertiary: Color(0xFF94A3B8),
    iconPrimary: Color(0xFFFF5C00),
    iconSecondary: Color(0xFF64748B),
    buttonPrimary: Color(0xFFFF5C00),
    buttonPrimaryForeground: Color(0xFFFFFFFF),
    buttonSecondary: Color(0xFFFFFFFF),
    buttonSecondaryForeground: Color(0xFF3C4257),
    switchActive: Color(0xFFFF5C00),
    switchInactive: Color(0xFFCCCCCC),
    inputBackground: Color(0xFFFAFBFC),
    inputBorder: Color(0xFFE4E9F2),
    inputHint: Color(0xFFB4BBCC),
    success: Color(0xFF313033),
    error: Color(0xFFD32F2F),
    warning: Color(0xFFFFA000),
    info: Color(0xFFFFF4ED),
    shadow: Color(0xFFFF5C00),
    navBarBackground: Color(0xFFFFFFFF),
    navBarSelected: Color(0xFFFF5C00),
    navBarUnselected: Color(0xFF64748B),
  );

  static const dark = CustomColorScheme(
    brandPrimary: Color(0xFFFF5C00),
    brandPrimaryLight: Color(0xFF3D1A00),
    brandPrimaryDark: Color(0xFFEC5B13),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF243044),
    cardBackground: Color(0xFF1E293B),
    border: Color(0xFF334155),
    divider: Color(0xFF475569),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    iconPrimary: Color(0xFFFF5C00),
    iconSecondary: Color(0xFF94A3B8),
    buttonPrimary: Color(0xFFFF5C00),
    buttonPrimaryForeground: Color(0xFFFFFFFF),
    buttonSecondary: Color(0xFF1E293B),
    buttonSecondaryForeground: Color(0xFFF1F5F9),
    switchActive: Color(0xFFFF5C00),
    switchInactive: Color(0xFF475569),
    inputBackground: Color(0xFF243044),
    inputBorder: Color(0xFF334155),
    inputHint: Color(0xFF64748B),
    success: Color(0xFF313033),
    error: Color(0xFFD32F2F),
    warning: Color(0xFFFFA000),
    info: Color(0xFF1E3A5F),
    shadow: Color(0xFF000000),
    navBarBackground: Color(0xFF1E293B),
    navBarSelected: Color(0xFFFF5C00),
    navBarUnselected: Color(0xFF94A3B8),
  );

  // ── ThemeExtension ────────────────────────────────────────────────────────

  @override
  CustomColorScheme copyWith({
    Color? brandPrimary,
    Color? brandPrimaryLight,
    Color? brandPrimaryDark,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? cardBackground,
    Color? border,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? buttonPrimary,
    Color? buttonPrimaryForeground,
    Color? buttonSecondary,
    Color? buttonSecondaryForeground,
    Color? switchActive,
    Color? switchInactive,
    Color? inputBackground,
    Color? inputBorder,
    Color? inputHint,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? shadow,
    Color? navBarBackground,
    Color? navBarSelected,
    Color? navBarUnselected,
  }) {
    return CustomColorScheme(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandPrimaryLight: brandPrimaryLight ?? this.brandPrimaryLight,
      brandPrimaryDark: brandPrimaryDark ?? this.brandPrimaryDark,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      cardBackground: cardBackground ?? this.cardBackground,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonPrimaryForeground:
          buttonPrimaryForeground ?? this.buttonPrimaryForeground,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      buttonSecondaryForeground:
          buttonSecondaryForeground ?? this.buttonSecondaryForeground,
      switchActive: switchActive ?? this.switchActive,
      switchInactive: switchInactive ?? this.switchInactive,
      inputBackground: inputBackground ?? this.inputBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      inputHint: inputHint ?? this.inputHint,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      shadow: shadow ?? this.shadow,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      navBarSelected: navBarSelected ?? this.navBarSelected,
      navBarUnselected: navBarUnselected ?? this.navBarUnselected,
    );
  }

  @override
  CustomColorScheme lerp(CustomColorScheme? other, double t) {
    if (other is! CustomColorScheme) return this;
    return CustomColorScheme(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandPrimaryLight:
          Color.lerp(brandPrimaryLight, other.brandPrimaryLight, t)!,
      brandPrimaryDark:
          Color.lerp(brandPrimaryDark, other.brandPrimaryDark, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      buttonPrimaryForeground:
          Color.lerp(buttonPrimaryForeground, other.buttonPrimaryForeground, t)!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
      buttonSecondaryForeground: Color.lerp(
          buttonSecondaryForeground, other.buttonSecondaryForeground, t)!,
      switchActive: Color.lerp(switchActive, other.switchActive, t)!,
      switchInactive: Color.lerp(switchInactive, other.switchInactive, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputHint: Color.lerp(inputHint, other.inputHint, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      navBarBackground:
          Color.lerp(navBarBackground, other.navBarBackground, t)!,
      navBarSelected: Color.lerp(navBarSelected, other.navBarSelected, t)!,
      navBarUnselected:
          Color.lerp(navBarUnselected, other.navBarUnselected, t)!,
    );
  }
}