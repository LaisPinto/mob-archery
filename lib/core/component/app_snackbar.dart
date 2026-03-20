import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';

void showErrorSnackbar(String message) {
  Asuka.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFD32F2F),
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
      backgroundColor: const Color(0xFF2E7D32),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 4),
    ),
  );
}