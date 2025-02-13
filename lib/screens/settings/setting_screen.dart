import 'package:find_resto/data/model/settings/setting.dart';
import 'package:find_resto/provider/settings/dark_theme_provider.dart';
import 'package:find_resto/provider/settings/notification_provider.dart';
import 'package:find_resto/provider/settings/setting_provider.dart';
import 'package:find_resto/static/settings/dark_theme_state.dart';
import 'package:find_resto/static/settings/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
// import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void saveAction() async {
    final darkThemeState = context.read<DarkThemeProvider>().darkThemeState;
    final isDarkThemeEnable = darkThemeState.isEnable;

    final notificationState =
        context.read<NotificationProvider>().notificationState;
    final isNotificationEnable = notificationState.isEnable;

    final Setting setting = Setting(
      darkTheme: isDarkThemeEnable,
      notificationEnable: isNotificationEnable,
    );
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final settingProvider = context.read<SettingProvider>();
    await settingProvider.saveSettingValue(setting);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(settingProvider.message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final darkThemeProvider = context.read<DarkThemeProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    final settingProvider = context.read<SettingProvider>();

    Future.microtask(
      () async {
        settingProvider.getSettingValue();
        final setting = settingProvider.setting;

        if (setting != null) {
          developer.log('setting.darkTheme: ${setting.darkTheme}',
              name: 'theme_settings');
          darkThemeProvider.darkThemeState = setting.darkTheme
              ? DarkThemeState.enable
              : DarkThemeState.disable;
          notificationProvider.notificationState = setting.notificationEnable
              ? NotificationState.enable
              : NotificationState.disable;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
      ),
      body: Column(
        children: [
          Consumer<DarkThemeProvider>(
            builder: (_, provider, __) {
              return SwitchListTile(
                title: const Text("Tema Gelap"),
                secondary: Icon(provider.darkThemeState == DarkThemeState.enable
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode),
                value: provider.darkThemeState == DarkThemeState.enable,
                onChanged: (value) {
                  provider.darkThemeState =
                      value ? DarkThemeState.enable : DarkThemeState.disable;
                  saveAction();
                },
              );
            },
          ),
          Consumer<NotificationProvider>(
            builder: (_, provider, __) {
              return SwitchListTile(
                title: const Text("Notifikasi"),
                secondary: Icon(provider.notificationState == NotificationState.enable
                    ? Icons.notifications_active
                    : Icons.notifications_off),
                value: provider.notificationState == NotificationState.enable,
                onChanged: (value) {
                  provider.notificationState =
                      value ? NotificationState.enable : NotificationState.disable;
                  saveAction();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
