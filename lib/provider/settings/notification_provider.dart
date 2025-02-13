import 'package:find_resto/static/settings/notification_state.dart';
import 'package:flutter/widgets.dart';

class NotificationProvider extends ChangeNotifier {
  //
  NotificationState _notificationState = NotificationState.enable;

  NotificationState get notificationState => _notificationState;

  set notificationState(NotificationState value) {
    _notificationState = value;
    notifyListeners();
  }
}