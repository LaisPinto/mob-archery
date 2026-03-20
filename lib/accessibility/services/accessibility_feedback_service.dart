import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

class AccessibilityFeedbackService {
  Future<void> announce(String message) async =>
      SemanticsService.announce(message, TextDirection.ltr);

  Future<void> haptic() => HapticFeedback.selectionClick();
}
