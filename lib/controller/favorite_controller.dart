import 'package:get/get.dart';
import 'package:restaurant_app/data/database_helper.dart';

import '../data/model/restaurant.dart';

class FavoriteController extends GetxController {
  var listRestaurant = <Restaurant>[].obs;

  getAllRestaurants() async {
    try {
      final db = DatabaseHelper.instance;
      final list = await db.getAll();
      listRestaurant(list);
    } catch (e) {
      print('ERROR GET $e');
    }
  }
}
