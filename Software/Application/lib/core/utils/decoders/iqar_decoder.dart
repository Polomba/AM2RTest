import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IQArDecoder {
  static final Map<int, Color?> colorMap = {
    1: Colors.red[400],
    2: Colors.amber[800],
    3: Colors.yellow[700],
    4: Colors.green,
    5: Colors.greenAccent[400],
    6: Colors.grey
  };

  static Color? decodeColor(int iqar) => colorMap[iqar];

  static String decodeIQArStatus(int iqar, AppLocalizations? l10n) {
    switch (iqar) {
      case 1:
        return l10n?.mapModuleInfoAirQualityBad ?? '';
      case 2:
        return l10n?.mapModuleInfoAirQualityWeak ?? '';
      case 3:
        return l10n?.mapModuleInfoAirQualityAverage ?? '';
      case 4:
        return l10n?.mapModuleInfoAirQualityGood ?? '';
      case 5:
        return l10n?.mapModuleInfoAirQualityVeryGood ?? '';
      default:
        return 'unavailable';
    }
  }
}
