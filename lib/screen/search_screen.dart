import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/controller/search_controller.dart';
import 'package:restaurant_app/widget/restaurant_list.dart';

import '../networking/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final SearchViewController _searchController =
      Get.put(SearchViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: 'Search...',
                  suffixIcon: IconButton(
                    icon: defaultTargetPlatform == TargetPlatform.iOS
                        ? const Icon(CupertinoIcons.search)
                        : const Icon(Icons.search),
                    onPressed: () {
                      _searchController.isInit(true);
                      _searchController.searchRestaurant(_controller.text);
                    },
                  ),
                ),
                onSubmitted: (String value) {
                  _searchController.isInit(true);
                  _searchController.searchRestaurant(value);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(() => _searchController.isInit.value
                  ? _fetchList()
                  : const Center(
                      child: Text('Find Your Restaurant Here'),
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _fetchList() {
    return Obx(() {
      if (_searchController.isLoading.value) {
        return const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 24,
            ),
            Text('Find Your Restaurant For You'),
          ],
        );
      } else {
        if (_searchController.restaurantList.isNotEmpty) {
          return Flexible(
            child: RestaurantListWidget(
                restaurants: _searchController.restaurantList),
          );
        } else if (_searchController.restaurantList.isEmpty) {
          return const Center(
            child: Text('No Data Found'),
          );
        } else {
          return const Center(child: Text(ApiService.errorMessage));
        }
      }
    });
  }
}
