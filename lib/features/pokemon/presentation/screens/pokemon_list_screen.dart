import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:pokedex/features/pokemon/presentation/screens/pokemon_detail_screen.dart';
import 'package:provider/provider.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar Pokémon al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonProviders>().loadPokemons();
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
          return Center(child: Text('No hay pokemons disponibles'));
        }

        // return RefreshIndicator(
        //   onRefresh: provider.refresh,
        //   child: Column(
        //     children: [
        //       GridView.builder(
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           mainAxisSpacing: 10,
        //           crossAxisSpacing: 10,
        //         ),
        //         itemCount: pokemons.length,
        //         itemBuilder: (context, index) {
        //           return PokemonCard(pokemon: pokemons[index]);
        //         },
        //       ),
        //     ],
        //   ),
        // );
        debugPrint(provider.hasMore ? 'si tiene mas' : 'no tiene mas');
        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: ListView.builder(
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 1,
            //   mainAxisSpacing: 10,
            //   crossAxisSpacing: 10,
            // ),
            controller: _scrollController,
            itemCount: pokemons.length + 1,
            itemBuilder: (context, index) {
              if (index == pokemons.length) {
                debugPrint("index == length");
                return _buildLoadingIndicator(provider);
              }
              final pokemon = pokemons[index];
              return _buildPokemonCard(context, pokemon);
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(PokemonProviders provider) {
    if (provider.isFetchingMore) {
      debugPrint("isfetchingMore");
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!provider.hasMore) {
      debugPrint("!provider.hasMore");
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '🏁 No hay más Pokémon',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    debugPrint("nadaaa");
    return SizedBox.shrink();
  }

  Widget _buildPokemonCard(BuildContext context, Pokemon pokemon) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonDetailScreen(pokemon: pokemon),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: Hero(
            tag: 'pokemon-image-${pokemon.id}',
            child: Image.network(
              pokemon.imageUrl,
              width: 56,
              height: 56,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.catching_pokemon, size: 56);
              },
            ),
          ),
          title: Text(
            pokemon.name.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Tipos: ${pokemon.types.join(', ')}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Text(
            '#${pokemon.id}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
