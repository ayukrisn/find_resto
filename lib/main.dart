import 'package:find_resto/data/model/settings/setting.dart';
import 'package:find_resto/provider/settings/dark_theme_provider.dart';
import 'package:find_resto/provider/settings/notification_provider.dart';
import 'package:find_resto/provider/settings/setting_provider.dart';
import 'package:find_resto/services/local_notification_service.dart';
import 'package:find_resto/services/shared_preferences_service.dart';
import 'package:find_resto/services/workmanager_service.dart';
import 'package:find_resto/static/settings/dark_theme_state.dart';
import 'package:find_resto/static/settings/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/data/local/local_database_service.dart';
import 'package:find_resto/data/model/restaurant/restaurant.dart';
import 'package:find_resto/provider/main/index_nav_provider.dart';
import 'package:find_resto/provider/restaurant/restaurant_detail_provider.dart';
import 'package:find_resto/provider/restaurant/restaurant_list_provider.dart';
import 'package:find_resto/provider/restaurant/add_review_provider.dart';
import 'package:find_resto/provider/restaurant/restaurant_search_provider.dart';
import 'package:find_resto/provider/favourite/favourite_icon_provider.dart';
import 'package:find_resto/provider/favourite/local_database_provider.dart';
import 'package:find_resto/screens/restaurant/detail/detail_screen.dart';
import 'package:find_resto/screens/restaurant/review/review_screen.dart';
import 'package:find_resto/screens/restaurant/search/search_screen.dart';
import 'package:find_resto/screens/main/main_screen.dart';
import 'package:find_resto/static/restaurant/navigation_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/util.dart';
import 'theme/theme.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => LocalDatabaseService(),
        ),
        Provider(
          create: (context) => SharedPreferencesService(prefs),
        ),
        Provider(
          create: (context) => RestaurantService(),
        ),
        Provider(
          create: (context) => LocalNotificationService()
            ..initNotification()
            ..configureLocalTimeZone(),
        ),
        Provider(
          create: (context) => WorkmanagerService()..init(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalDatabaseProvider(
            context.read<LocalDatabaseService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FavouriteIconProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => IndexNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantListProvider(
            context.read<RestaurantService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
            context.read<RestaurantService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AddReviewProvider(
            context.read<RestaurantService>(),
            context.read<RestaurantDetailProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantSearchProvider(
            context.read<RestaurantService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingProvider(
            context.read<SharedPreferencesService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DarkThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NotificationProvider(context.read<LocalNotificationService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider darkThemeProvider = DarkThemeProvider();

  Future<void> getCurrentSettings() async {
    final darkThemeProvider = context.read<DarkThemeProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    final settingProvider = context.read<SettingProvider>();
    final workmanagerService = context.read<WorkmanagerService>();

    // Check permission for the notification
    bool notificationGranted =
        await notificationProvider.requestPermissions() ?? false;
    developer.log('Notification granted: $notificationGranted',
        name: 'notification granted main');

    // Retrieve settings
    settingProvider.getSettingValue();
    Setting setting = settingProvider.setting!;
    developer.log(
      'setting retrieved: ${setting.darkTheme} ${setting.notificationEnable}',
      name: 'settings main',
    );

    // Set the theme
    developer.log('setting.darkTheme: ${setting.darkTheme}',
        name: 'theme_settings main');
    darkThemeProvider.darkThemeState =
        setting.darkTheme ? DarkThemeState.enable : DarkThemeState.disable;
    //Set the notification
    developer.log('setting.notification: ${setting.notificationEnable}',
        name: 'notification_settings main');
    notificationProvider.notificationState =
        (notificationGranted && setting.notificationEnable)
            ? NotificationState.enable
            : NotificationState.disable;
    //Set the workmanager
    if (notificationProvider.notificationState == NotificationState.enable) {
      workmanagerService.runPeriodicTask();
    } else {
      workmanagerService.cancelAllTask();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentSettings();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Lato", "Lato");

    MaterialTheme theme = MaterialTheme(textTheme);
    return Consumer<DarkThemeProvider>(
      builder: (context, darkThemeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: darkThemeProvider.darkThemeState == DarkThemeState.enable
              ? theme.dark()
              : theme.light(),
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as Restaurant,
                ),
            NavigationRoute.addReviewRoute.name: (context) => ReviewScreen(
                restaurant: ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>)
          },
        );
      },
    );
  }
}
