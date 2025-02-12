import 'package:find_resto/data/model/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String themeStatus = "THEME_STATUS";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(themeStatus, setting.darkTheme);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Setting getSettingValue() {
    return Setting(darkTheme: _preferences.getBool(themeStatus) ?? false);
  }
}
