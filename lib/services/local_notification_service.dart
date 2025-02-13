import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class LocalNotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //Initialize the timezone
  Future<void> configureLocalTimeZone() async {
    //init timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  //Initialize the notification
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // prepare for Android init settings
    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // prepare for iOS init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    //initialize the plugin
    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  //check if android permission is granted
  Future<bool> _isAndroidPermissionGranted() async {
    return await notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  //requeste exact alarm permission for Android
  Future<bool> _requestExactAlarmsPermission() async {
    return await notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestExactAlarmsPermission() ??
        false;
  }

//request permission for Android 13+
  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation =
          notificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation =
          notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final requestNotificationsPermission =
          await androidImplementation?.requestNotificationsPermission() ??
              false;
      final notificationEnabled = await _isAndroidPermissionGranted();
      final requestAlarmEnabled = await _requestExactAlarmsPermission();

      return requestNotificationsPermission &&
          notificationEnabled &&
          requestAlarmEnabled;
    } else {
      return false;
    }
  }

  //Notification detail setup
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "meal_reminder_id",
        "Daily Meal Reminder",
        channelDescription: "Daily Meal Reminder Channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  //Get the schedule at the specific time
  tz.TZDateTime _nextInstanceOfSchedule(
      {required int hour, required int minute}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  //Show Notification based on schedule
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    //Check whether it has been initialized or not
    if (!_isInitialized) {
      developer.log('Notifications not initialized',
          name: 'notification_service');
      return;
    }

    //Get current date/time from the device's local timezone
    final scheduledDate = _nextInstanceOfSchedule(hour: hour, minute: minute);

    //Schedule the notification
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),

      //iOS Specific
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,

      //Android Specific
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      //Make notification repeat daily
      matchDateTimeComponents: DateTimeComponents.time,
    );

    developer.log('Notification scheduled', name: 'notification_service');
  }

  //See all pending notification
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  //Cancel all notification
  Future<void> cancelAllNotification() async {
    try {
      await notificationsPlugin.cancelAll();
      developer.log('Notification canceled', name: 'notification_service');
    } catch (e) {
      developer.log('Failed to cancel notification: $e',
          name: 'notification_service');
    }
  }
}
