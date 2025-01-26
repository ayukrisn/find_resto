import 'package:find_resto/data/api/api_service.dart';

class RestaurantService {
  final APIService _apiService = APIService.instance;

  // Method to fetch a list of restaurants
  Future<void> getRestaurants({Map<String, dynamic>? params}) async {
    try {
      final response =
          await _apiService.request('/list', DioMethod.get, param: params);

      if (response.statusCode == 200) {
        // Success: Process the response data
        print('API call successful: ${response.data}');
      } else {
        // Error: Handle the error response
        print('API call failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('Network error occurred: $e');
    }
  }
}
