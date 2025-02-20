import 'package:find_resto/data/model/restaurant/restaurant.dart';

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final Restaurant? payload;
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}
