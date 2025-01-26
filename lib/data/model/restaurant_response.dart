import 'package:find_resto/data/model/restaurant.dart';

class RestaurantResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  // Factory constructor to parse JSON
  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(
      error: json['error'],
      message: json['message'],
      count: json['count'],
      restaurants: (json['restaurants'] as List?)
          ?.map((e) => Restaurant.fromJson(e))
          .toList() ?? [],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'count': count,
      'restaurants': restaurants.map((e) => e.toJson()).toList(),
    };
  }
}