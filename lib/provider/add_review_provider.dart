import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/static/add_review_result_state.dart';
import 'package:flutter/widgets.dart';

class AddReviewProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  AddReviewProvider(this._restaurantService);

  // getter and setter
  AddReviewResultState _resultState = AddReviewNoneState();
  AddReviewResultState get resultState => _resultState;

  Future<void> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    try {
      _resultState = AddReviewLoadingState();
      notifyListeners();

      final result = await _restaurantService.addReview(
        restaurantId: restaurantId,
        name: name,
        review: review,
      );

      if (result.error) {
        _resultState = AddReviewErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = AddReviewDoneState(result.message);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = AddReviewErrorState(e.toString());
      notifyListeners();
    }
  }
}
