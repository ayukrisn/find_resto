import 'dart:async';

// import 'package:find_resto/data/model/settings/received_notification.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

final notificationsPlugin = FlutterLocalNotificationsPlugin();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class LocalNotificationService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// CONFIGURE TIMEZONE
  //Initialize the timezone
  Future<void> configureLocalTimeZone() async {
    //init timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  /// NOTIFICATION
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
    await notificationsPlugin.initialize(
      initSettings,
      // Handle the retrieved notification in foreground
      onDidReceiveNotificationResponse: (notificationResponse) {
        final payload = notificationResponse.payload;
        if (payload != null && payload.isNotEmpty) {
          selectNotificationStream.add(payload);
        }
      },
    );
    _isInitialized = true;
  }

  //Notification detail setup
  NotificationDetails notificationDetails(
    String channelId,
    String channelName,
    String channelDescription,
  ) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
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

  // Show simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    if (!_isInitialized) {
      developer.log('Notifications not initialized',
          name: 'notification_service');
      return;
    }

    //Schedule the notification
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(
        "restaurant_recommendation_id",
        "Daily Restaurant Recommendation",
        "Daily Restaurant Recommendation Channel",
      ),
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
      notificationDetails(
        "meal_reminder_id",
        "Daily Meal Reminder",
        "Daily Meal Reminder Channel",
      ),

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
