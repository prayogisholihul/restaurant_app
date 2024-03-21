import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../networking/api_service.dart';
import '../data/model/restaurant.dart';
import '../screen/detail_screen.dart';

class RestaurantListWidget extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantListWidget({super.key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (ctx, index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .primaryColorLight, // Assign color based on index
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              Get.to(() => DetailScreen(
                restaurantId: restaurants[index].id,
              ));
            },
            leading: Hero(
              tag: restaurants[index].id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  ApiService().imageFetch(
                      ImageSize.small, restaurants[index].pictureId),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      if (loadingProgress.expectedTotalBytes != null) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return child;
                      }
                    }
                  },
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                restaurants[index].name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    defaultTargetPlatform == TargetPlatform.iOS
                        ? const Icon(CupertinoIcons.placemark_fill)
                        : const Icon(Icons.place),
                    Text(restaurants[index].city)
                  ],
                ),
                Row(
                  children: [
                    defaultTargetPlatform == TargetPlatform.iOS
                        ? const Icon(
                      CupertinoIcons.star_fill,
                      color: Colors.amber,
                    )
                        : const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(restaurants[index].rating.toString())
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
