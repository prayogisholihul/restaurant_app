import 'package:get/get.dart';

import '../data/model/restaurant.dart';
import '../networking/api_service.dart';

class SearchViewController extends GetxController {
  var restaurantList = <Restaurant>[].obs;
  var error = ApiService.errorMessage.obs;
  var isLoading = false.obs;
  var isInit = false.obs;

  searchRestaurant(String query) async {
    isLoading(true);
    try {
      var api = await ApiService().searchRestaurant(query);
      if (api.restaurants.isNotEmpty) {
        restaurantList(api.restaurants);
      }
    } catch (e) {
      error(ApiService.errorMessage);
    } finally {
      isLoading(false);
    }
  }
}