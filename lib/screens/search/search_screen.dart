import 'package:find_resto/provider/restaurant_search_provider.dart';
import 'package:find_resto/screens/error/error_screen.dart';
import 'package:find_resto/screens/home/restaurant_card.dart';
import 'package:find_resto/static/navigation_route.dart';
import 'package:find_resto/static/restaurant_search_result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  late FocusNode search;

  @override
  void initState() {
    super.initState();
    search = FocusNode();

    Future.microtask(() {
    final searchRestaurantProvider =
        Provider.of<RestaurantSearchProvider>(context, listen: false);
    searchRestaurantProvider.clearSearchResults();
  });
  }

  @override
  void dispose() {
    super.dispose();
    search.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchRestaurantProvider =
        Provider.of<RestaurantSearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            )),
        title: Text("Cari Restoran"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.hardEdge,
                  child: Form(
                    key: _formKey,
                    child: ValueListenableBuilder(
                        valueListenable: _searchController,
                        builder: (context, v, _) {
                          return TextFormField(
                            autofocus: true,
                            focusNode: search,
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Cari restoran",
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            onChanged: (_) async {
                              developer.log(_searchController.text,
                                  name: 'restaurant_search_onchanged');
                              await searchRestaurantProvider
                                  .searchRestaurants(_searchController.text);
                            },
                          );
                        }),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Consumer<RestaurantSearchProvider>(
                    builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantSearchNoneState() => Center(
                        child: Center(
                            child: Text(
                          "Hasil pencarian akan terlihat di sini.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )),
                      ),
                    RestaurantSearchLoadingState() => const Center(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    RestaurantSearchLoadedState(data: var restaurantList) =>
                      restaurantList.isEmpty
                          ? ErrorScreen(message: "Restaurant tidak ditemukan.")
                          : ListView.builder(
                              shrinkWrap: true,
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
                    RestaurantSearchErrorState(error: var message) => Center(
                        child: ErrorScreen(message: message),
                      ),
                  };
                })
              ])),
    );
  }
}

