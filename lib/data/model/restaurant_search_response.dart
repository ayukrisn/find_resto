import 'package:find_resto/data/model/restaurant.dart';
import 'dart:convert';

RestaurantSearchResponse restaurantSearchResponseFromJson(String str) => RestaurantSearchResponse.fromJson(json.decode(str));

String restaurantSearchResponseToJson(RestaurantSearchResponse data) => json.encode(data.toJson());

class RestaurantSearchResponse {
    final bool error;
    final int founded;
    final List<Restaurant> restaurants;

    RestaurantSearchResponse({
        required this.error,
        required this.founded,
        required this.restaurants,
    });

    factory RestaurantSearchResponse.fromJson(Map<String, dynamic> json) => RestaurantSearchResponse(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
}