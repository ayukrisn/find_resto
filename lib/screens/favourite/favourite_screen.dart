import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:find_resto/provider/favourite/local_database_provider.dart';
import 'package:find_resto/screens/home/restaurant_card.dart';
import 'package:find_resto/static/navigation_route.dart';

// import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadAllRestaurantFav();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text("Restoran Favorit"),
      ),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {
          final restaurantList = value.restaurantList ?? [];

          return switch (restaurantList.isNotEmpty) {
            true => ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];

                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant,
                      );
                    },
                  );
                },
              ),
            _ => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Oops, belum ada restoran favorit, nih!",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Yuk cari restoran favoritmu dulu.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}
