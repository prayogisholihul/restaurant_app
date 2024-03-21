import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/screen/favorite_screen.dart';
import 'package:restaurant_app/screen/search_screen.dart';
import 'package:restaurant_app/screen/setting_screen.dart';

import '../controller/home_controller.dart';
import '../widget/restaurant_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                  onTap: () {
                    Get.to(() => const SettingScreen());
                  },
                  child: const Icon(Icons.settings, color: Colors.white,)),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Restaurant',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Recommendation restaurant for you',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(height: 16),
                Expanded(child: _fetchList()),
              ],
            ),
          ),
        ));
  }

  Widget _fetchList() {
    return Obx(() {
      if (_homeController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (_homeController.restaurantList.isNotEmpty) {
        return RestaurantListWidget(
            restaurants: _homeController.restaurantList);
      } else {
        return Text(_homeController.error.value);
      }
    });
  }
}
