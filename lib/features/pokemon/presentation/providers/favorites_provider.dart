import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_favorites.dart';
import 'package:pokedex/features/pokemon/domain/usecases/toggle_favorite.dart';

enum FavoriteStatus { loading, success, error, initial }

class FavoritesProvider extends ChangeNotifier {
  final ToggleFavorite toggleFavorite;
  final GetFavorites getFavorites;

  Set<int> _favorites = {};
  FavoriteStatus _status = FavoriteStatus.initial;
  String _favoriteErrorMessage = "";

  Set<int> get favorites => _favorites;
  FavoriteStatus get status => _status;
  String get favoriteMessage => _favoriteErrorMessage;

  FavoritesProvider(this.toggleFavorite, this.getFavorites) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _status = FavoriteStatus.loading;
    notifyListeners();

    final result = await getFavorites.call(NoParams());

    result.fold(
      (failure) {
        _status = FavoriteStatus.error;
        _favoriteErrorMessage = failure.message;
        _favorites = {};
        notifyListeners();
      },
      (favorites) {
        _status = FavoriteStatus.success;
        _favorites = favorites;
        notifyListeners();
      },
    );
  }

  FavoriteStatus _toggleStatus = FavoriteStatus.initial;
  String _toggleErrorMessage = "";
  bool _wasAdded = false;

  FavoriteStatus get toggleStatus => _toggleStatus;
  String get toggleMessage => _toggleErrorMessage;
  bool get wasAdded => _wasAdded;

  Future<void> toggle(int id) async {
    _wasAdded = !_favorites.contains(id);

    if (_wasAdded) {
      _favorites.add(id);
    } else {
      _favorites.remove(id);
    }

    notifyListeners();

    final result = await toggleFavorite.call(ToggleFavoriteParams(id));

    result.fold(
      (failure) {
        _toggleStatus = FavoriteStatus.error;
        _toggleErrorMessage = failure.message;
        if (_wasAdded) {
          favorites.remove(id);
        } else {
          favorites.add(id);
        }
        notifyListeners();
      },
      (toogle) {
        _toggleStatus = FavoriteStatus.success;

        notifyListeners();
      },
    );
  }
}
