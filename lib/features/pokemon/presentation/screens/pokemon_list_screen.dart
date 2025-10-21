import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:pokedex/features/pokemon/presentation/screens/pokemon_detail_screen.dart';
import 'package:provider/provider.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar Pokémon al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonProviders>().loadPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonProviders>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
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

        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: ListView.builder(
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 1,
            //   mainAxisSpacing: 10,
            //   crossAxisSpacing: 10,
            // ),
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                      pokemon.nombre.toUpperCase(),
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
            },
          ),
        );
      },
    );
  }
}
