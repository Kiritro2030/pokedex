import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pokedex/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoritesLocalDataSource {
  Future<Set<int>> getFavorites();
  Future<void> saveFavoritesIds(Set<int> ids);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _key = 'favorite_pokemon_ids';
  final SharedPreferences pref;

  FavoritesLocalDataSourceImpl({required this.pref});

  @override
  Future<Set<int>> getFavorites() async {
    try {
      final jsonString = pref.getString(_key);

      if (jsonString == null) return {};

      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((id) => id as int).toSet();
    } catch (e) {
      throw CacheExeption(e.toString());
    }
  }

  @override
  Future<void> saveFavoritesIds(Set<int> ids) async {
    final jsonString = jsonEncode(ids.toList());

    await pref.setString(_key, jsonString);
  }
}
