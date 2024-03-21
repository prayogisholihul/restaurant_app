import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurant_app/networking/api_service.dart';

import '../data/date_time.dart';
import '../data/model/restaurant.dart';
import '../service/background_service.dart';

class HomeController extends GetxController {
  static const alarmId = 919;
  static const scheduledKey = 'schedule';

  var restaurantList = <Restaurant>[].obs;
  var error = ApiService.errorMessage.obs;
  var isLoading = true.obs;
  var isScheduled = false.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchRestList();
    isScheduled(_storage.read(scheduledKey));
  }

  fetchRestList() async {
    try {
      var api = await ApiService().fetchRestList();
      if (api.restaurants.isNotEmpty) {
        restaurantList(api.restaurants);
      } else if (api.error) {
        error(api.message);
      }
    } catch (e) {
      error(ApiService.errorMessage);
    } finally {
      isLoading(false);
    }
  }

  Future<bool> scheduled(bool value) async {
    isScheduled(value);
    _storage.write(scheduledKey, value);
    if (isScheduled.value) {
      print('Scheduling Activated');
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        alarmId,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Canceled');
      return await AndroidAlarmManager.cancel(alarmId);
    }
  }
}
