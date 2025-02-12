enum DarkThemeState {
  enable,
  disable;

  bool get isEnable => this == DarkThemeState.enable;
}

extension BoolExtension on bool {
  DarkThemeState get isEnable =>
      this == true ? DarkThemeState.enable : DarkThemeState.disable;
}
