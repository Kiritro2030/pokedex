import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/core/error/exceptions.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemons({required int limit, int offset = 0});

  Future<PokemonModel> getPokemon({required String id});
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  //poder mockear tests, no es necesario pasar el cliente por parametro
  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<PokemonModel> getPokemon({required String id}) async {
    try {
      final pokemonResponse = await client.get(
        Uri.parse("$baseUrl/pokemon/$id"),
      );

      if (pokemonResponse.statusCode == 404) {
        throw ServerException("Pokémon '$id' no encontrado");
      }

      if (pokemonResponse.statusCode != 200) {
        throw ServerException("No se pudo obtener el pokemon");
      }

      final pokemonData = json.decode(pokemonResponse.body);

      return PokemonModel.fromJson(pokemonData);
    } on ServerException {
      // ✅ Si ya es ServerException, RE-LANZARLA sin modificar
      rethrow;
    } catch (e) {
      throw ServerException("Error en el servidor  ${e.toString()}");
    }
  }

  @override
  Future<List<PokemonModel>> getPokemons({
    required int limit,
    int offset = 0,
  }) async {
    try {
      // 1. Hacer petición a la API para obtener la lista
      final listResponse = await client.get(
        Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'),
      );

      if (listResponse.statusCode != 200) {
        throw ServerException('Error al obtener la lista de Pokémon');
      }

      final listData = json.decode(listResponse.body);
      final results = listData['results'] as List;

      // 2. Por cada Pokémon, hacer petición individual para obtener detalles
      final List<PokemonModel> pokemons = [];

      // debugPrint(jsonEncode(listData['results']));

      for (var pokemon in results) {
        final detailUrl = pokemon['url'] as String;
        final detailResponse = await http.get(Uri.parse(detailUrl));

        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);
          // debugPrint(jsonEncode(detailData['id']));
          // debugPrint(jsonEncode(detailData['name']));
          // debugPrint(
          //   jsonEncode(
          //     detailData['sprites']['other']['official-artwork']['front_default'],
          //   ),
          // );
          debugPrint(jsonEncode(detailData['types']));
          debugPrint(jsonEncode(detailData['stats']));
          pokemons.add(PokemonModel.fromJson(detailData));
        }
      }
      return pokemons;
    } on ServerException {
      // ✅ Si ya es ServerException, RE-LANZARLA sin modificar
      rethrow;
    } catch (e) {
      throw ServerException("Error de conexion: ${e.toString()} ");
    }
  }
}
