import 'package:mob_archery/accessibility/enums/accessibility_preference_type.dart';

class AccessibilityPreferenceModel {
  const AccessibilityPreferenceModel({
    required this.type,
    required this.isEnabled,
  });

  final AccessibilityPreferenceType type;
  final bool isEnabled;
}
