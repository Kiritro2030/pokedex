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
  final Set<Pokemon> _favoritePokemons = {};
  bool _isloading = true;

  Future<void> _loadFavorites() async {
    setState(() {
      _isloading = true;
    });

    _favoritePokemons.clear();
    final favoritesProvider = context.read<FavoritesProvider>();
    final pokemonProviders = context.read<PokemonProviders>();

    for (int pokemonId in favoritesProvider.favorites) {
      await pokemonProviders.searchPokemon(pokemonId.toString());
      setState(() {
        _favoritePokemons.add(pokemonProviders.pokemon!);
      });
    }

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
      child: Builder(
        builder: (context) {
          if (_isloading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_favoritePokemons.isEmpty) {
            return Center(child: Text("No tienes favoritos"));
          }

          return ListView(
            children: _favoritePokemons
                .map((pokemon) => _buildPokemonCard(pokemon))
                .toList(),
          );
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
