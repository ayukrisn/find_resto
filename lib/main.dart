import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/provider/detail/restaurant_detail_provider.dart';
import 'package:find_resto/provider/home/restaurant_list_provider.dart';
import 'package:find_resto/provider/review/add_review_provider.dart';
import 'package:find_resto/screens/detail/detail_screen.dart';
import 'package:find_resto/screens/home/home_screen.dart';
import 'package:find_resto/screens/review/review_screen.dart';
import 'package:find_resto/static/navigation_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/util.dart';
import 'theme/theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (context) => RestaurantService(),
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
        create: (context) =>
            AddReviewProvider(context.read<RestaurantService>()),
      ),
    ],
    child: const MyApp(),
  ));
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
      // home: ReviewScreen(),
      initialRoute: NavigationRoute.homeRoute.name,
      routes: {
        NavigationRoute.homeRoute.name: (context) => const HomeScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId: ModalRoute.of(context)?.settings.arguments as String,
            ),
            NavigationRoute.addReviewRoute.name: (context) => ReviewScreen(
              restaurant: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
            )
      },
    );
  }
}
