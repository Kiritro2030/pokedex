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

  //Estados Paginacion
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isFetchingMore = false;
  static const int _pageSize = 20; // Reducido de 24 a 20

  // Getters
  PokemonStatus get status => _status;
  List<Pokemon> get pokemons => _pokemons;
  String get errorMessage => _errorMessage;

  //Getters paginacion
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isFetchingMore => _isFetchingMore;

  //Indica si esta cargando
  bool get isLoading => _status == PokemonStatus.loading;

  //Cargar los primero 20 pokemon
  Future<void> loadPokemons() async {
    //1. Cambiar estado a loading
    _status = PokemonStatus.loading;
    _currentPage = 0;
    _hasMore = true;

    notifyListeners();

    //2. Ejecutar el UseCase
    final result = await getPokemons.call(
      GetPokemonsParams(limit: _pageSize, offset: 0),
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
        _hasMore = pokemonList.length == _pageSize;

        //Prueba rapida del limite de pokemons
        // _hasMore = false;

        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  Future<void> loadMorePokemons() async {
    if (_isFetchingMore || !_hasMore || _status == PokemonStatus.loading) {
      debugPrint(
        '⚠️ No se puede cargar más: isFetching=$_isFetchingMore, hasMore=$_hasMore',
      );
      return;
    }
    _status = PokemonStatus.loading;
    _isFetchingMore = true;
    notifyListeners();

    final nextOffset = (_currentPage + 1) * _pageSize;

    final result = await getPokemons.call(
      GetPokemonsParams(limit: _pageSize, offset: nextOffset),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = PokemonStatus.error;
        _isFetchingMore = false;
        debugPrint('❌ Error cargando más: ${failure.message}');
        notifyListeners();
      },
      (newPokemons) {
        if (newPokemons.isEmpty) {
          _hasMore = false;
          debugPrint("No hay mas pokemon");
        } else {
          _pokemons.addAll(newPokemons);
          _hasMore = _pageSize == newPokemons.length;
          _currentPage++;
          debugPrint(
            '✅ Agregados ${newPokemons.length} Pokémon (total: ${_pokemons.length})',
          );
        }
        _status = PokemonStatus.success;
        _isFetchingMore = false;
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
    // notifyListeners();
  }
}
