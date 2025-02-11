import 'package:flutter/widgets.dart';

import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/static/restaurant_detail_result_state.dart';
class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  RestaurantDetailProvider(this._restaurantService);

  // getter and setter
  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();
  RestaurantDetailResultState get resultState => _resultState;

  Future<void> getRestaurantDetail(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();

      final result = await _restaurantService.getRestaurantDetail(
        id: id,
      );

      if (result.error) {
        _resultState = RestaurantDetailErrorState(
          result.message,
        );
        notifyListeners();
      } else {
        _resultState = RestaurantDetailLoadedState(
          result.restaurant,
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}
