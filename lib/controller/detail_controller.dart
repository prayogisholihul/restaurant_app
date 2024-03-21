import 'package:get/get.dart';
import 'package:restaurant_app/data/database_helper.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

import '../networking/api_service.dart';

class DetailController extends GetxController {
  final db = DatabaseHelper.instance;

  var restaurantDetail = RestaurantDetail(
      id: '',
      name: '',
      description: '',
      city: '',
      address: '',
      pictureId: '',
      categories: [],
      menus: Menus(foods: [], drinks: []),
      rating: 0,
      customerReviews: []).obs;
  var error = ApiService.errorMessage.obs;
  var isLoading = true.obs;

  fetchDetail(String id) async {
    try {
      var api = await ApiService().fetchRestDetail(id);
      restaurantDetail(api.restaurant);
      if (api.error) {
        error(api.message);
      }
    } catch (e) {
      error(ApiService.errorMessage);
    } finally {
      isLoading(false);
    }
  }

  var isFavorite = false.obs;

  getLocal(String id) async {
    try {
      Restaurant restaurant = await db.get(id);
      isFavorite(restaurant.id == id);
    } catch (e) {
      print("ERROR GET $e");
    }
  }

  createFavorite() async {
    try {
      final rest = restaurantDetail.value;
      isFavorite(true);
      await db.insert(Restaurant(
          id: rest.id,
          name: rest.name,
          description: rest.description,
          pictureId: rest.pictureId,
          city: rest.city,
          rating: rest.rating));
    } catch (e) {
      print("ERROR create $e");
    }
  }

  unFavoriteRestaurant() async {
    try {
      isFavorite(false);
      await db.delete(restaurantDetail.value.id);
    } catch (e) {
      print("ERROR Delete $e");
    }
  }
}
