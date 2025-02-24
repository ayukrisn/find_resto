import 'package:find_resto/services/local_notification_service.dart';
import 'package:find_resto/services/workmanager_service.dart';
import 'package:find_resto/static/settings/notification_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

class NotificationProvider extends ChangeNotifier {
  //Notification service
  final LocalNotificationService notificationService;
  //Work manager service
  final WorkmanagerService workmanagerService;

  NotificationProvider({
    required this.notificationService,
    required this.workmanagerService,
  });
  //Notification state
  NotificationState _notificationState = NotificationState.disable;

  NotificationState get notificationState => _notificationState;

  set notificationState(NotificationState value) {
    _notificationState = value;
    notifyListeners();

    if (value == NotificationState.enable) {
      _scheduleDailyMealNotification();
      workmanagerService.runPeriodicTask();
    } else {
      _cancelAllNotification();
      workmanagerService.cancelAllTask();
    }
  }

  //Pending notification request
  List<PendingNotificationRequest> pendingNotificationRequests = [];

  // Future<bool?> requestPermissions() async {
  //   bool? granted = await notificationService.
  //   if (granted ?? false) {
  //     notificationState = NotificationState.disable;
  //   }
  //   notifyListeners();
  //   return granted;
  // }

  // Create a schedule notification
  void _scheduleDailyMealNotification() {
    if (_notificationState == NotificationState.disable) {
      _cancelAllNotification();
      developer.log("Notifications are disabled",
          name: "notification_provider");
      return;
    }

    notificationService.scheduleNotification(
      id: UniqueKey().hashCode,
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
