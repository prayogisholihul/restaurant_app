import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';

import '../data/model/restaurant.dart';

enum ImageSize { small, medium, large }

class ApiService {
  static const baseUrl = 'https://restaurant-api.dicoding.dev';
  static const baseImageUrl = 'https://restaurant-api.dicoding.dev/images/';
  static const errorMessage = 'Oops Error!, Check Your Connection';

  String imageFetch(ImageSize size, id) {
    return '$baseImageUrl${size.name}/$id';
  }

  Future<RestaurantResult> fetchRestList({http.Client? client}) async {
    final call = await (client ?? http.Client()).get(Uri.parse('$baseUrl/list'));

    if (call.statusCode == 200) {
      return restResultFromJson(call.body);
    } else {
      throw Exception('Failed to load Restaurant List');
    }
  }

  Future<DetailRestaurantResult> fetchRestDetail(String idRest, {http.Client? client}) async {
    final call = await (client ?? http.Client()).get(Uri.parse('$baseUrl/detail/$idRest'));

    if (call.statusCode == 200) {
      return detailRestaurantDecode(call.body);
    } else {
      throw Exception('Failed to load Restaurant Detail');
    }
  }

  Future<SearchResult> searchRestaurant(String query) async {
    final call = await http.get(Uri.parse('$baseUrl/search?q=$query'));

    if (call.statusCode == 200) {
      return searchRestDecode(call.body);
    } else {
      throw Exception('Failed to load Search');
    }
  }
}
