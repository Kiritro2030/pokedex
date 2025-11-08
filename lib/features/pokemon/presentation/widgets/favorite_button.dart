import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/presentation/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final int pokemonId;
  final double size;
  const FavoriteButton({super.key, required this.pokemonId, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoriteProvider, child) {
        final isFav = favoriteProvider.favorites.contains(pokemonId);

        return IconButton(
          onPressed: () => favoriteProvider.toggle(pokemonId),
          icon: isFav
              ? Icon(Icons.favorite, size: size)
              : Icon(Icons.favorite_border_outlined, size: size),
        );
      },
    );
  }
}
