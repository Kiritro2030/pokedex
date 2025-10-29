import 'package:pokedex/features/pokemon/domain/entities/ability.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/domain/entities/stat.dart';

class PokemonModel extends Pokemon {
  const PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    super.types,
    super.stats,
    super.abilities,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'] as int,
      name: json["name"] as String,
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default']
              as String? ??
          '',
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      stats: (json['stats'] as List)
          .map(
            (stat) =>
                Stat(name: stat['stat']['name'], valor: stat['base_stat']),
          )
          .toList(),
      abilities: (json["abilities"] as List)
          .map((ability) => Ability(name: ability["ability"]["name"]))
          .toList(),
    );
  }
  factory PokemonModel.lite({required String name, required String url}) {
    // Parsear ID desde la URL: "https://pokeapi.co/api/v2/pokemon/25/" → 25
    final id = int.parse(
      url.split("/").where((element) => element.isNotEmpty).last,
    );

    return PokemonModel(
      id: id,
      name: name,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      "sprites": {
        "other": {
          "official-artwork": {"front_default": imageUrl},
        },
      },
      'types': types
          .map(
            (type) => {
              "type": {"name": type},
            },
          )
          .toList(),
      'abilities': abilities
          .map(
            (ability) => {
              "ability": {"name": ability.name},
            },
          )
          .toList(),
      'stats': stats
          .map(
            (stat) => {
              "stat": {"name": stat.name},
              "base_stat": stat.valor,
            },
          )
          .toList(),
    };
  }

  Pokemon toEntity() {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      types: types,
      abilities: abilities,
      stats: stats,
    );
  }
}
