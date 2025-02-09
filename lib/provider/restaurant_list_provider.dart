import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/static/restaurant_list_result_state.dart';
import 'package:flutter/widgets.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  RestaurantListProvider(this._restaurantService);

  // getter and setter
  RestaurantListResultState _resultState = RestaurantListNoneState();
  RestaurantListResultState get resultState => _resultState;

  Future<void> getRestaurants() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final result = await _restaurantService.getRestaurants();

      if (result.error) {
        _resultState = RestaurantListErrorState(
          result.message,
        );
        notifyListeners();
      } else {
        _resultState = RestaurantListLoadedState(
          result.restaurants,
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantListErrorState(e.toString());
      notifyListeners();
    }
  }
}
