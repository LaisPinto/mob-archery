import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

enum SupportedLanguage {
  englishUs,
  portugueseBrazil,
  spanishSpain,
}

extension SupportedLanguageExtension on SupportedLanguage {
  String get localeCode {
    switch (this) {
      case SupportedLanguage.englishUs:
        return 'en_US';
      case SupportedLanguage.portugueseBrazil:
        return 'pt_BR';
      case SupportedLanguage.spanishSpain:
        return 'es_ES';
    }
  }

  Locale get locale {
    final parts = localeCode.split('_');
    return Locale(parts[0], parts[1]);
  }

  String label(BuildContext context) {
    switch (this) {
      case SupportedLanguage.englishUs:
        return LocaleKeys.profile_language_english.tr();
      case SupportedLanguage.portugueseBrazil:
        return LocaleKeys.profile_language_portuguese.tr();
      case SupportedLanguage.spanishSpain:
        return LocaleKeys.profile_language_spanish.tr();
    }
  }

}

SupportedLanguage supportedLanguageFromLocaleCode(String localeCode) {
  return SupportedLanguage.values.firstWhere(
    (language) => language.localeCode == localeCode,
    orElse: () => SupportedLanguage.englishUs,
  );
}
