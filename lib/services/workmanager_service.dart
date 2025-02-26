import 'dart:math';
import 'dart:developer' as developer;

import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/data/model/restaurant/restaurant.dart';
import 'package:find_resto/services/local_notification_service.dart';
import 'package:find_resto/static/work_manager/my_workmanager.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

// @pragma is an anotation as an entry point to make sure that callbackDispatcher is still available
// in runtime to process payload from Workmanager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Check uniqueName or taskName that is currently working
    if (task == MyWorkmanager.periodic.taskName) {
      final restaurantService = RestaurantService();
      final LocalNotificationService notificationService =
          LocalNotificationService();
      notificationService.initNotification();

      Restaurant restaurant = await fetchRandomRestaurant(restaurantService);
      showRestaurantNotification(restaurant, notificationService);
    }
    return Future.value(true);
  });
}

// Work manager service
class WorkmanagerService {
  final Workmanager _workmanager;

  // if workManager is null, assign Workmanager
  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ??= Workmanager();

  // Initiate Workmanager before the app's display is built
  Future<void> init() async {
    await _workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  // Run periodic task
  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(days: 1),
      initialDelay: Duration.zero,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
    );
  }

  // Cancel all background service
  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}

// Fetch random restaurant
Future<Restaurant> fetchRandomRestaurant(
    RestaurantService restaurantService) async {
  var random = Random();
  List<Restaurant> restaurants = [];
  final result = await restaurantService.getRestaurants();

  if (!result.error) {
    restaurants = result.restaurants;
    Restaurant restaurant = restaurants[random.nextInt(restaurants.length)];
    return restaurant;
  } else {
    developer.log('Network error occurred: ${result.message}',
        name: 'restaurant_service_network');
    throw Exception('Network error: ${result.message}');
  }
}

// Show notification
Future<void>  showRestaurantNotification(
  Restaurant restaurant,
  LocalNotificationService notificationService,
) async {
  developer.log('showRestaurantNotification called!', name: 'work manager');
  notificationService.initNotification();
  developer.log('Payload sent: ${restaurant.toJsonStr()}',
      name: 'work manager show notif screen');

  await notificationService.showNotification(
    id: UniqueKey().hashCode,
    title: "Daily Restaurant Recommendation",
    body: "Yuk cek ${restaurant.name} di sini!",
    payload: restaurant.toJsonStr(),
  );
}
