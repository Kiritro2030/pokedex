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

        if (pokemons.isEmpty) {
          return const Center(child: Text('No hay pokemons disponibles'));
        }

        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: ListView.builder(
            key: const PageStorageKey<String>('pokemon_list_view'),
            cacheExtent: 300, // Reducido para menos precarga
            controller: _scrollController,
            itemCount: pokemons.length + 1,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            itemExtent: 96, // Altura fija = mejor rendimiento
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == pokemons.length) {
                return _buildLoadingIndicator(provider);
              }
              final pokemon = pokemons[index];
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
}
