import 'package:find_resto/data/model/settings/setting.dart';
import 'package:find_resto/provider/settings/dark_theme_provider.dart';
import 'package:find_resto/provider/settings/notification_provider.dart';
import 'package:find_resto/provider/settings/setting_provider.dart';
import 'package:find_resto/services/permission_service.dart';
import 'package:find_resto/static/settings/dark_theme_state.dart';
import 'package:find_resto/static/settings/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
// import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final permissionService = PermissionService();
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
              name: 'theme_settings screen');
          darkThemeProvider.darkThemeState = setting.darkTheme
              ? DarkThemeState.enable
              : DarkThemeState.disable;
          developer.log(
              'setting.notificationEnable: ${setting.notificationEnable}',
              name: 'notification_settings screen');
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
                title: const Text("Notifikasi Daily Reminder"),
                secondary: Icon(
                    provider.notificationState == NotificationState.enable
                        ? Icons.notifications_active
                        : Icons.notifications_off),
                value: provider.notificationState == NotificationState.enable,
                onChanged: (value) async {
                  developer.log(
                    'Value: $value',
                    name: 'notification switch tile value',
                  );
                  if (value) {
                    if (await permissionService.checkPermanentlyDenied()) {
                      developer.log('Notification permission denied',
                          name: 'notification setting screen');
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Aplikasi membutuhkan izin"),
                          content: Text(
                              "Agar aplikasi dapat mengirimkan notifikasi, berikan izin terlebih dahulu di pengaturanmu."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                            TextButton(
                              onPressed: () {
                                openAppSettings();
                                Navigator.pop(context);
                              },
                              child: Text('Buka Pengaturan'),
                            ),
                          ],
                        ),
                      );
                      return;
                    } else {
                      var permissionStatus = await permissionService
                          .requestNotificationsPermission();
                      if (!permissionStatus) {
                        developer.log('Notification permission not granted',
                            name: 'notification setting screen');
                        return;
                      }
                    }
                  }
                  provider.notificationState = value
                      ? NotificationState.enable
                      : NotificationState.disable;
                  saveAction();
                  developer.log(
                    'Value now: $value',
                    name: 'notification switch tile value',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
