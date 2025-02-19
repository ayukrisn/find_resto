import 'package:find_resto/data/model/settings/setting.dart';
import 'package:find_resto/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class SettingProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SettingProvider(this._service);

  String _message = "";
  String get message => _message;

  Setting? _setting;
  Setting? get setting => _setting;

  Future<void> saveSettingValue(Setting value) async {
    try {
      await _service.saveSettingValue(value);
      _message = "Pengaturanmu telah disimpan";
    } catch (e) {
      _message = "Pengaturan gagal disimpan.";
    }
    notifyListeners();
  }

  void getSettingValue() {
    try {
      _setting = _service.getSettingValue();
      _message = "Data pengaturan telah dimuat.";
    } catch (e) {
      _message = "Data pengaturan gagal dimuat.";
    }
    notifyListeners();
  }
}
