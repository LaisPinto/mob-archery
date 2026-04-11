import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:mob_archery/app/modules/core/theme/custom_color_scheme.dart';

void showErrorSnackbar(String message) {
  Asuka.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: CustomColorScheme.light.error,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 4),
    ),
  );
}

void showSuccessSnackbar(String message) {
  Asuka.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: CustomColorScheme.light.success,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 4),
    ),
  );
}