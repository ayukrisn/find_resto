import 'package:find_resto/services/local_notification_service.dart';
import 'package:find_resto/static/settings/notification_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

class NotificationProvider extends ChangeNotifier {
  //Notification service
  final LocalNotificationService notificationService;

  NotificationProvider(this.notificationService);

  int _notificationId = 0;
  bool? _permission = false;

  //Notification state
  NotificationState _notificationState = NotificationState.enable;

  NotificationState get notificationState => _notificationState;

  set notificationState(NotificationState value) {
    _notificationState = value;
    notifyListeners();

    if (value == NotificationState.enable) {
      _scheduleDailyMealNotification();
    } else {
      _cancelAllNotification();
    }
  }

  //Pending notification request
  List<PendingNotificationRequest> pendingNotificationRequests = [];

  Future<void> requestPermissions() async {
    _permission = await notificationService.requestPermissions();
    notifyListeners();
  }

  // Create a schedule notification
  void _scheduleDailyMealNotification() {
    if (_notificationState == NotificationState.disable) {
    developer.log("Notifications are disabled", name: "notification_provider");
    return;
  }

    _notificationId += 1;
    notificationService.scheduleNotification(
      id: _notificationId,
      title: "Daily Meal Reminder",
      body: "Jangan lupa makan siang, ya!",
      hour: 11,
      minute: 0,
    );
  }

  //Show a list of pending notification
  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await notificationService.pendingNotificationRequests();
    notifyListeners();
  }

  // Cancel a notification
  Future<void> _cancelAllNotification() async {
    await notificationService.cancelAllNotification();
  }
}
