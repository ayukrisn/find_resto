import 'package:find_resto/provider/home/restaurant_list_provider.dart';
import 'package:find_resto/screens/home/restaurant_card.dart';
import 'package:find_resto/static/navigation_route.dart';
import 'package:find_resto/static/restaurant_list_result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        padding: const EdgeInsets.all(8.0),
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
            Consumer<RestaurantListProvider>(
                builder: (context, value, child) {
              return switch (value.resultState) {
                RestaurantListLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                RestaurantListLoadedState(data: var restaurantList) =>
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 12),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: restaurantList.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurantList[index];
            
                        return RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NavigationRoute.detailRoute.name,
                              arguments: restaurant.id,
                            );
                          },
                        );
                      }),
                RestaurantListErrorState(error: var message) => Center(
                    child: Text(message),
                  ),
                _ => const SizedBox(),
              };
            }),
          ],
        ),
      ),
    );
  }
}
