import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/features/pokemon/domain/entities/ability.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/domain/entities/stat.dart';

class PokemonModel extends Pokemon {
  const PokemonModel({
    required super.id,
    required super.nombre,
    required super.imageUrl,
    required super.types,
    required super.stats,
    required super.abilities,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'] as int,
      nombre: json["name"] as String,
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
                Stat(nombre: stat['stat']['name'], valor: stat['base_stat']),
          )
          .toList(),
      abilities: (json["abilities"] as List)
          .map((ability) => Ability(nombre: ability["ability"]["name"]))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nombre,
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
              "ability": {"name": ability.nombre},
            },
          )
          .toList(),
      'stats': stats
          .map(
            (stat) => {
              "stat": {"name": stat.nombre},
              "base_stat": stat.valor,
            },
          )
          .toList(),
    };
  }

  Pokemon toEntity() {
    return Pokemon(
      id: id,
      nombre: nombre,
      imageUrl: imageUrl,
      types: types,
      abilities: abilities,
      stats: stats,
    );
  }
}
