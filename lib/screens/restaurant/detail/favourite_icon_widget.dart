import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:find_resto/provider/favourite/favourite_icon_provider.dart';
import 'package:find_resto/provider/favourite/local_database_provider.dart';
import 'package:find_resto/data/model/restaurant.dart';



class FavouriteIconWidget extends StatefulWidget {
  final Restaurant restaurant;
  const FavouriteIconWidget({
    super.key,
    required this.restaurant,
  });

  @override
  State<FavouriteIconWidget> createState() => _FavouriteIconWidgetState();
}

class _FavouriteIconWidgetState extends State<FavouriteIconWidget> {
  @override
  void initState() {
    super.initState();

     developer.log('Restaurant data: ${widget.restaurant}',
        name: 'restaurant_data');

    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final favouriteIconProvider = context.read<FavouriteIconProvider>();

    Future.microtask(
      () async {
        await localDatabaseProvider.loadRestaurantById(widget.restaurant.id);
        final value = localDatabaseProvider.checkItemFav(widget.restaurant.id);

        favouriteIconProvider.isFavourited = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: IconButton(
        onPressed: () async {
          final localDatabaseProvider = context.read<LocalDatabaseProvider>();
          final favouriteIconProvider = context.read<FavouriteIconProvider>();
          final isFavourited = favouriteIconProvider.isFavourited;

          if (!isFavourited) {
          await localDatabaseProvider.saveRestaurantFav(widget.restaurant);
        } else {
          await localDatabaseProvider.removeRestaurantById(widget.restaurant.id);
        }
        favouriteIconProvider.isFavourited = !isFavourited;
        localDatabaseProvider.loadAllRestaurantFav();
        },
        icon: Icon(
          context.watch<FavouriteIconProvider>().isFavourited
          ? Icons.favorite
          : Icons.favorite_outline,
          color:  context.watch<FavouriteIconProvider>().isFavourited
          ? Colors.red
          : Theme.of(context).colorScheme.onSurface,
        ),       
      ),
    );
  }
}
