import 'dart:convert';

import 'package:find_resto/data/model/restaurant/restaurant.dart';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
    final bool error;
    final int founded;
    final List<Restaurant> restaurants;

    SearchResponse({
        required this.error,
        required this.founded,
        required this.restaurants,
    });

    factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
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