import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:find_resto/provider/restaurant_list_provider.dart';
import 'package:find_resto/screens/error/error_screen.dart';
import 'package:find_resto/screens/home/restaurant_card.dart';
import 'package:find_resto/static/navigation_route.dart';
import 'package:find_resto/static/restaurant_list_result_state.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantListProvider>().getRestaurants();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      // appBar: AppBar(title: const Text("Find Resto")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: statusBarHeight,
            ),
            Text("Mau makan apa hari ini?",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 8,
            ),
            Text("Cari restoran favoritmu di sini.",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  NavigationRoute.searchRoute.name,
                );
              },
              child: Material(
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge,
                child: IgnorePointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari restoran",
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),
            Consumer<RestaurantListProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantListLoadingState() => const Center(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  RestaurantListLoadedState(data: var restaurantList) =>
                    restaurantList.isEmpty
                        ? Center(
                            child: Text(
                              "Belum ada restoran saat ini",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 12),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: restaurantList.length,
                            itemBuilder: (context, index) {
                              final restaurant = restaurantList[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: RestaurantCard(
                                  restaurant: restaurant,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      NavigationRoute.detailRoute.name,
                                      arguments: restaurant.id,
                                    );
                                  },
                                ),
                              );
                            }),
                  RestaurantListErrorState(error: var message) =>
                    Center(child: ErrorScreen(message: message)),
                  _ => const SizedBox(),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
