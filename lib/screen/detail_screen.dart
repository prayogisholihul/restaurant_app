import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/controller/detail_controller.dart';
import 'package:restaurant_app/controller/favorite_controller.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/networking/api_service.dart';
import 'package:restaurant_app/widget/favorite_widget.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DetailController _detailController = Get.put(DetailController());
  final FavoriteController _favController = Get.put(FavoriteController());

  @override
  void dispose() {
    _favController.getAllRestaurants();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _detailController.fetchDetail(widget.restaurantId);
    _detailController.getLocal(widget.restaurantId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: defaultTargetPlatform == TargetPlatform.iOS
              ? const Icon(CupertinoIcons.back)
              : const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _fetchData(),
    );
  }

  Widget _fetchData() {
    return Obx(() {
      if (_detailController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (_detailController.restaurantDetail.value.id.isNotEmpty) {
        return _bodyWidget(_detailController.restaurantDetail.value);
      } else {
        return Center(child: Text(_detailController.error.value));
      }
    });
  }

  Widget _bodyWidget(RestaurantDetail restaurant) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Hero(
                      tag: restaurant.id,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        child: Image.network(
                            ApiService().imageFetch(
                                ImageSize.large, restaurant.pictureId),
                            loadingBuilder: (ctx, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            if (loadingProgress.expectedTotalBytes != null) {
                              return const Padding(
                                padding: EdgeInsets.all(100),
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return child;
                            }
                          }
                        }),
                      ),
                    ),
                  ),
                  Obx(() => FavoriteWidget(
                      isFavorite: _detailController.isFavorite.value,
                      action: () {
                        if (_detailController.isFavorite.value) {
                          _detailController.unFavoriteRestaurant();
                        } else {
                          _detailController.createFavorite();
                        }
                      }))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          defaultTargetPlatform == TargetPlatform.iOS
                              ? const Icon(CupertinoIcons.placemark_fill)
                              : const Icon(Icons.place),
                          Text(restaurant.city)
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? const Icon(CupertinoIcons.star_fill,
                              color: Colors.amber)
                          : const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                      Text(restaurant.rating.toString())
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                restaurant.description,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 12),
              child: Text(
                'Foods',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurant.menus.foods.length,
                    itemBuilder: (ctx, index) => Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(restaurant.menus.foods[index].name),
                          ),
                        ))),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 12),
              child: Text(
                'Drinks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurant.menus.drinks.length,
                    itemBuilder: (ctx, index) => Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(restaurant.menus.drinks[index].name),
                          ),
                        ))),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}
