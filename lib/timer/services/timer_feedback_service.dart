import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

class TimerFeedbackService {
  Future<void> announce(String message) async {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  Future<void> selection() => HapticFeedback.selectionClick();

  Future<void> warning() => HapticFeedback.mediumImpact();

  Future<void> completion() => HapticFeedback.heavyImpact();
}
