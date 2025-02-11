
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/data/local/local_database_service.dart';
import 'package:find_resto/data/model/restaurant.dart';
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
import 'package:find_resto/static/navigation_route.dart';

import 'theme/util.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => LocalDatabaseService(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalDatabaseProvider(
            context.read<LocalDatabaseService>(),
          ),
        ),
        Provider(
          create: (context) => RestaurantService(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavouriteIconProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => IndexNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<RestaurantService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<RestaurantService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AddReviewProvider(
            context.read<RestaurantService>(),
            context.read<RestaurantDetailProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantSearchProvider(context.read<RestaurantService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Lato", "Lato");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      // home: SearchScreen(),
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
  }
}
