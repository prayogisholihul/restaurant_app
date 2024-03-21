import 'package:flutter/material.dart';

class FavoriteWidget extends StatelessWidget {
  final bool isFavorite;
  final void Function() action;

  const FavoriteWidget({super.key, required this.isFavorite, required this.action});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 75,
      child: InkWell(
        onTap: action,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight),
          child: isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}
