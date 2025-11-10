import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemon.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:pokedex/features/pokemon/presentation/screens/pokemon_detail_screen.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true; // Mantiene el estado cuando sales/entras

  @override
  void initState() {
    super.initState();
    // Cargar Pokémon al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PokemonProviders>();
      if (provider.currentPage == 0) {
        provider.loadPokemons();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      final provider = context.read<PokemonProviders>();
      if (!provider.isFetchingMore && provider.hasMore) {
        provider.loadMorePokemons();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Importante para AutomaticKeepAliveClientMixin
    return Consumer<PokemonProviders>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.pokemons.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.status == PokemonStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadPokemons(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final pokemons = provider.pokemons;
        provider.resetSearch();

        if (pokemons.isEmpty) {
          return const Center(child: Text('No hay pokemons disponibles'));
        }

        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: ListView.builder(
            key: const PageStorageKey<String>('pokemon_list_view'),
            cacheExtent: 300, // Reducido para menos precarga
            controller: _scrollController,
            itemCount: pokemons.length + 2,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            itemExtent: 96, // Altura fija = mejor rendimiento
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildOverlay(
                  image: 'assets/images/list_screen.jpg',
                  content: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.explore,
                              color: Colors.lightBlueAccent,
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
                              'Explorar Pokédex',
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
                                '${pokemons.length} Pokémon descubiertos',
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
              if (index == pokemons.length + 1) {
                return _buildLoadingIndicator(provider);
              }
              final pokemon =
                  pokemons[index - 1]; // Ajusta el índice por el overlay
              return _buildPokemonCard(context, pokemon, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(PokemonProviders provider) {
    if (provider.isFetchingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!provider.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '🏁 No hay más Pokémon',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPokemonCard(BuildContext context, Pokemon pokemon, int index) {
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
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
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
