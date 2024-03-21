import 'dart:convert';
import 'package:restaurant_app/data/model/restaurant.dart';

SearchResult searchRestDecode(String str) {
  return SearchResult.fromJson(json.decode(str));
}

class SearchResult {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  SearchResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      error: json['error'],
      founded: json['founded'],
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((restaurantJson) => Restaurant.fromJson(restaurantJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'founded': founded,
      'restaurants':
          restaurants.map((restaurant) => restaurant.toMap()).toList(),
    };
  }
}
