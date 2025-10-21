import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemon.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemons.dart';
import 'package:flutter/foundation.dart';

enum PokemonStatus { initial, loading, success, error }

class PokemonProviders extends ChangeNotifier {
  final GetPokemons getPokemons;
  final GetPokemon getPokemon;

  PokemonProviders({required this.getPokemons, required this.getPokemon});

  // Estado
  PokemonStatus _status = PokemonStatus.initial;
  List<Pokemon> _pokemons = [];
  String _errorMessage = '';

  // Getters
  PokemonStatus get status => _status;
  List<Pokemon> get pokemons => _pokemons;
  String get errorMessage => _errorMessage;

  //Indica si esta cargando
  bool get isLoading => _status == PokemonStatus.loading;

  //Cargar los primero 20 pokemon
  Future<void> loadPokemons() async {
    //1. Cambiar estado a loading
    _status = PokemonStatus.loading;

    notifyListeners();

    //2. Ejecutar el UseCase
    final result = await getPokemons.call(
      GetPokemonsParams(limit: 20, offset: 0),
    );

    //3. Manejar resultado
    result.fold(
      (failure) {
        _status = PokemonStatus.error;
        _errorMessage = failure.message;
        _pokemons = [];
        notifyListeners();
      },
      (pokemonList) {
        _status = PokemonStatus.success;
        _pokemons = pokemonList;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  Future<void> refresh() async {
    await loadPokemons();
  }

  PokemonStatus _searchStatus = PokemonStatus.initial;
  Pokemon? _pokemon;
  String _searchErrorMessage = '';

  PokemonStatus get searchStatus => _searchStatus;
  Pokemon? get pokemon => _pokemon;
  String get searchErrorMessage => _searchErrorMessage;

  bool get isSearchLoading => _searchStatus == PokemonStatus.loading;

  Future<void> searchPokemon(String id) async {
    print("providerSearchPokemon");
    _searchStatus = PokemonStatus.loading;

    notifyListeners();

    final result = await getPokemon.call(GetPokemonParams(id: id));

    result.fold(
      (failure) {
        _searchStatus = PokemonStatus.error;
        _searchErrorMessage = failure.message;
        _pokemon = null;
        notifyListeners();
      },
      (pokemon) {
        _searchStatus = PokemonStatus.success;
        _pokemon = pokemon;
        _searchErrorMessage = '';
        notifyListeners();
      },
    );
  }

  void resetSearch() {
    _searchStatus = PokemonStatus.initial;
    _pokemon = null;
    _searchErrorMessage = '';
    notifyListeners();
  }
}
