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

    // ✅ Carga todos los pokémons en paralelo
    final pokemonFutures = favoritesProvider.favorites.map((pokemonId) async {
      await pokemonProviders.searchPokemon(pokemonId.toString());
      return pokemonProviders.pokemon;
    }).toList();

    final loadedPokemons = await Future.wait(pokemonFutures);

    // Filtra los null y agrega a la lista
    _favoritePokemons.addAll(loadedPokemons.whereType<Pokemon>());

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
          : _favoritePokemons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes favoritos',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              cacheExtent: 300,
              addRepaintBoundaries: true,
              itemExtent: 96,
              itemCount: _favoritePokemons.length + 1, // ✅ +1 para el overlay
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildOverlay(
                    image: 'assets/images/favorite_screen.jpg',
                    content: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 28,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Mis Favoritos',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.catching_pokemon,
                                  color: Colors.yellowAccent,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_favoritePokemons.length} Pokémon capturados',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
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
                    ],
                  );
                }

                // ✅ Invierte el índice para mostrar los últimos primero
                // index 1 → muestra el último pokémon (_favoritePokemons.length - 1)
                // index 2 → muestra el penúltimo (_favoritePokemons.length - 2)
                final pokemonIndex = _favoritePokemons.length - index;
                return _buildPokemonCard(_favoritePokemons[pokemonIndex]);
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

  Widget _buildOverlay({required String image, required List<Widget> content}) {
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
                  Image.asset(image, fit: BoxFit.cover),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: content,
            ),
          ),
        ],
      ),
    );
  }
}
