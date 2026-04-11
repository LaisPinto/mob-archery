import 'package:easy_localization/easy_localization.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

/// [AuthServiceInterface] defines the Auth Form validation service contract.
abstract class AuthServiceInterface {
  String? validateName(String value);

  String? validateEmail(String value);

  String? validatePassword(String value);

  String? validateLoginPassword(String value);

  String? validatePasswordConfirmation({
    required String password,
    required String confirmation,
  });
}

/// [AuthService] implements [AuthServiceInterface].
class AuthService implements AuthServiceInterface {
  @override
  String? validateName(String value) {
    if (value.trim().isEmpty) {
      return LocaleKeys.modules_auth_validation_name_required.tr();
    }
    if (value.trim().length < 2) {
      return LocaleKeys.modules_auth_validation_name_min_chars.tr();
    }
    return null;
  }

  @override
  String? validateEmail(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      return LocaleKeys.modules_auth_validation_email_required.tr();
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(normalizedValue)) {
      return LocaleKeys.modules_auth_validation_email_invalid.tr();
    }

    return null;
  }

  @override
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return LocaleKeys.modules_auth_validation_password_required.tr();
    }
    if (value.length < 8) {
      return LocaleKeys.modules_auth_validation_password_min_chars.tr();
    }
    return null;
  }

  @override
  String? validateLoginPassword(String value) {
    if (value.isEmpty) {
      return LocaleKeys.modules_auth_validation_password_required.tr();
    }
    return null;
  }

  @override
  String? validatePasswordConfirmation({
    required String password,
    required String confirmation,
  }) {
    final passwordValidationMessage = validatePassword(password);
    if (passwordValidationMessage != null) {
      return passwordValidationMessage;
    }
    if (password != confirmation) {
      return LocaleKeys.modules_auth_validation_passwords_mismatch.tr();
    }
    return null;
  }
}
