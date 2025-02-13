import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

class LocalNotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //Initialize
  Future<void> initNotification() async {
    if (_isInitialized) return;

    //init timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

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
  }

  //Notification detail setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
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

  //Show Notification based on schedule
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    //Get current date/time from the device's local timezone
    final now = tz.TZDateTime.now(tz.local);

    //Create a date/time for today at the specified time
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    //Schedule the notification
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(),

      //iOS Specific
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,

      //Android Specific
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

      //Make notification repeat daily
      matchDateTimeComponents: DateTimeComponents.time,
    );

    developer.log('Notification scheduled', name: 'notification_service');
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
