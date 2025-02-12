import 'package:find_resto/static/settings/dark_theme_state.dart';
import 'package:flutter/material.dart';

class DarkThemeProvider extends ChangeNotifier{
  DarkThemeState _darkThemeState = DarkThemeState.disable;

  DarkThemeState get darkThemeState => _darkThemeState;

  set darkThemeState(DarkThemeState value) {
    _darkThemeState = value;
    notifyListeners();
  }
}