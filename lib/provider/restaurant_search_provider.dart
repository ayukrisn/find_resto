import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/static/restaurant_search_result_state.dart';
import 'package:flutter/widgets.dart';

import 'dart:developer' as developer;

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  RestaurantSearchProvider(this._restaurantService);

  // getter and setter
  RestaurantSearchResultState _resultState = RestaurantSearchNoneState();
  RestaurantSearchResultState get resultState => _resultState;

  Future<void> searchRestaurants(String param) async {
    Map<String, String> queryParameters = {
      'q': param,
    };

    developer.log(
      '$queryParameters',
      name: 'restaurant_search_service',
    );

    try {
      _resultState = RestaurantSearchLoadingState();
      notifyListeners();

      final result = await _restaurantService.searchRestaurants(
        params: queryParameters,
      );

      if (result.error) {
        _resultState = RestaurantSearchErrorState(
          result.error.toString(),
        );
        notifyListeners();
      } else {
        _resultState = RestaurantSearchLoadedState(
          result.restaurants,
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantSearchErrorState(
        e.toString(),
      );
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _resultState = RestaurantSearchNoneState();
    notifyListeners();
  }
}
