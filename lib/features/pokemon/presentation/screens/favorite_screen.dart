import 'package:dartz/dartz_streaming.dart' hide Text;
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/presentation/providers/favorites_provider.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<Pokemon> _favoritePokemons = [];
  bool _isloading = true;

  Future<void> _loadFavorites() async {
    setState(() {
      _isloading = true;
      _favoritePokemons.clear();
    });

    final favoritesProvider = context.read<FavoritesProvider>();
    final pokemonProviders = context.read<PokemonProviders>();

    await favoritesProvider.loadFavorites();

    for (int pokemonId in favoritesProvider.favorites) {
      await pokemonProviders.searchPokemon(pokemonId.toString());
      if (pokemonProviders.pokemon != null) {
        _favoritePokemons.add(pokemonProviders.pokemon!);
      }
    }
    pokemonProviders.resetSearch();

    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: (_isloading && _favoritePokemons.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              cacheExtent: 300, // Reducido para menos precarga
              addRepaintBoundaries: true,
              itemExtent: 96,
              itemCount: _favoritePokemons.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRect(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://e0.pxfuel.com/wallpapers/250/288/desktop-wallpaper-pikachu-forest-pokemon-pokemon-landscape.jpg',
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.3),
                                        Colors.black.withValues(alpha: 0.5),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.catching_pokemon_outlined),
                              Text(
                                'Total de pokemon favoritos #${_favoritePokemons.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final reversedIndex = _favoritePokemons.length - index;

                if (_favoritePokemons.isEmpty) {
                  return const Center(child: Text("No tienes favoritos"));
                }

                return _buildPokemonCard(_favoritePokemons[reversedIndex]);
              },
            ),
    );
  }

  Widget _buildPokemonCard(Pokemon pokemon) {
    return PokemonCard(
      key: ValueKey('pokemon-${pokemon.id}'),
      pokemon: pokemon,
    );
  }
}
