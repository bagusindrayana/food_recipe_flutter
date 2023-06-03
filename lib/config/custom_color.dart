import 'package:flutter/material.dart';

class CustomColor {
  static const MaterialColor customyellow =
      MaterialColor(_customyellowPrimaryValue, <int, Color>{
    50: Color(0xFFFFFAED),
    100: Color(0xFFFFF4D1),
    200: Color(0xFFFFECB3),
    300: Color(0xFFFFE494),
    400: Color(0xFFFFDF7D),
    500: Color(_customyellowPrimaryValue),
    600: Color(0xFFFFD55E),
    700: Color(0xFFFFCF53),
    800: Color(0xFFFFCA49),
    900: Color(0xFFFFC038),
  });
  static const int _customyellowPrimaryValue = 0xFFFFD966;

  static const MaterialColor customyellowAccent =
      MaterialColor(_customyellowAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_customyellowAccentValue),
    400: Color(0xFFFFF5E1),
    700: Color(0xFFFFEDC8),
  });
  static const int _customyellowAccentValue = 0xFFFFFFFF;

  static const MaterialColor customred =
      MaterialColor(_customredPrimaryValue, <int, Color>{
    50: Color(0xFFFCE0E6),
    100: Color(0xFFF7B3BF),
    200: Color(0xFFF18095),
    300: Color(0xFFEB4D6B),
    400: Color(0xFFE7264B),
    500: Color(_customredPrimaryValue),
    600: Color(0xFFE00026),
    700: Color(0xFFDC0020),
    800: Color(0xFFD8001A),
    900: Color(0xFFD00010),
  });
  static const int _customredPrimaryValue = 0xFFE3002B;

  static const MaterialColor customredAccent =
      MaterialColor(_customredAccentValue, <int, Color>{
    100: Color(0xFFFFF8F8),
    200: Color(_customredAccentValue),
    400: Color(0xFFFF9296),
    700: Color(0xFFFF797D),
  });
  static const int _customredAccentValue = 0xFFFFC5C7;
}
