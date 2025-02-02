import 'dart:developer' as developer;
import 'dart:convert';

import 'package:find_resto/data/model/add_review_response.dart';
import 'package:find_resto/data/model/restaurant_detail_response.dart';
import 'package:find_resto/data/model/restaurant_response.dart';
import 'package:find_resto/data/api/api_service.dart';
import 'package:find_resto/data/model/restaurant_search_response.dart';

class RestaurantService {
  final APIService _apiService = APIService.instance;

  // Method to fetch a list of restaurants
  Future<RestaurantResponse> getRestaurants(
      {Map<String, dynamic>? params}) async {
    try {
      final response =
          await _apiService.request('/list', DioMethod.get, param: params);

      if (response.statusCode == 200) {
        // Success: Process the response data
        developer.log('API call successful: ${response.data}',
            name: 'restaurant_service_success');
        return RestaurantResponse.fromJson(response.data);
      } else {
        // Error: Handle the error response
        developer.log('API call failed: ${response.statusMessage}',
            name: 'restaurant_service');
        throw Exception('Failed to load restaurant list');
      }
    } catch (e) {
      developer.log('Network error occurred: $e', name: 'restaurant_service_network');
      throw Exception('Network error: $e');
    }
  }

  // Method to fetch the restaurant detail
  Future<RestaurantDetailResponse> getRestaurantDetail(
      {Map<String, dynamic>? params, required String id}) async {
    try {
      final response = await _apiService.request('/detail/$id', DioMethod.get,
          param: params);

      if (response.statusCode == 200) {
        // Success: Process the response data
        developer.log('API call successful: ${response.data}',
            name: 'restaurant_detail_service');
        return RestaurantDetailResponse.fromJson(response.data);
      } else {
        // Error: Handle the error response
        developer.log('API call failed: ${response.statusMessage}',
            name: 'restaurant_detail_service');
        throw Exception('Failed to load restaurant detail');
      }
    } catch (e) {
      developer.log('Network error occurred: $e',
          name: 'restaurant_detail_service');
      throw Exception('Network error: $e');
    }
  }

  // Method to add a restaurant review
  Future<AddReviewResponse> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    try {
      final dataReview = {
        'id': restaurantId,
        'name': name,
        'review': review,
      };

      final response = await _apiService.request('/review', DioMethod.post,
          formData: json.encode(dataReview));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success: Process the response data
        developer.log('API call successful: ${response.data}',
            name: 'restaurant_review_service');
        return AddReviewResponse.fromJson(response.data);
      } else {
        // Error: Handle the error response
        developer.log('API call failed: ${response.statusMessage}',
            name: 'restaurant_review_service');
        throw Exception('Failed to add review, ${json.encode(dataReview)}');
      }
    } catch (e) {
      developer.log('Network error occurred: $e',
          name: 'restaurant_review_service');
      throw Exception('Network error: $e');
    }
  }

    // Method to fetch a list of restaurants
  Future<RestaurantSearchResponse> searchRestaurants(
      {Map<String, dynamic>? params}) async {
    try {
      final response =
          await _apiService.request('/search', DioMethod.get, param: params);

      if (response.statusCode == 200) {
        // Success: Process the response data
        developer.log('API call successful: ${response.data}',
            name: 'restaurant_service');
        return RestaurantSearchResponse.fromJson(response.data);
      } else {
        // Error: Handle the error response
        developer.log('API call failed: ${response.statusMessage}',
            name: 'restaurant_service');
        throw Exception('Failed to load restaurant list');
      }
    } catch (e) {
      developer.log('Network error occurred: $e', name: 'restaurant_service');
      throw Exception('Network error: $e');
    }
  }
}
