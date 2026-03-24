import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:mob_archery/translations/locale_keys.g.dart';

enum MeasurementUnit {
  meters,
  yards,
}

extension MeasurementUnitExtension on MeasurementUnit {
  String get firestoreValue => name;

  String label(BuildContext context) {
    switch (this) {
      case MeasurementUnit.meters:
        return LocaleKeys.modules_profile_fields_units_meters.tr();
      case MeasurementUnit.yards:
        return LocaleKeys.modules_profile_fields_units_yards.tr();
    }
  }
}
