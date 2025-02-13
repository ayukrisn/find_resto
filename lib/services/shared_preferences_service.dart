import 'package:find_resto/data/model/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String keyThemeStatus = "THEME_STATUS";
  static const String keyNotificationStatus = "NOTIFICATION_STATUS";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(keyThemeStatus, setting.darkTheme);
      await _preferences.setBool(
          keyNotificationStatus, setting.notificationEnable);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Setting getSettingValue() {
    return Setting(
      darkTheme: _preferences.getBool(keyThemeStatus) ?? false,
      notificationEnable: _preferences.getBool(keyNotificationStatus) ?? true,
    );
  }
}
