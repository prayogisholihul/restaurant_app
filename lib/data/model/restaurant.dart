import 'dart:convert';

RestaurantResult restResultFromJson(String str) {
  return RestaurantResult.fromJson(json.decode(str));
}

class RestaurantResult {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  RestaurantResult({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantResult.fromJson(Map<String, dynamic> json) {
    return RestaurantResult(
      error: json['error'],
      message: json['message'],
      count: json['count'],
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((restaurantJson) => Restaurant.fromJson(restaurantJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'count': count,
      'restaurants':
          restaurants.map((restaurant) => restaurant.toMap()).toList(),
    };
  }
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
    );
  }

  factory Restaurant.fromLocal(Map<String, dynamic> item) {
    return Restaurant(
        id: item['id'],
        name: item['name'],
        description: item['description'],
        pictureId: item['pictureId'],
        city: item['city'],
        rating: item['rating']);
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }
}
