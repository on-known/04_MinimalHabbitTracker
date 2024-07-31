import 'package:flutter/material.dart';
import 'package:minimal_habbit_tracker/theme/dark_mode.dart';
import 'package:minimal_habbit_tracker/theme/light_Mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themedata => _themeData;

  bool get isdarkMode => _themeData == darkTheme;

  set themedata(ThemeData themedata) {
    _themeData = themedata;
    notifyListeners();
  }

  void toggleButton() {
    if (_themeData == lightTheme) {
      themedata = darkTheme;
    } else {
      themedata = lightTheme;
    }
  }
}
