import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  const PokemonModel({
    required super.id,
    required super.nombre,
    required super.imageUrl,
    required super.types,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'] as int,
      nombre: json["name"] as String,
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default']
              as String,
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': nombre, 'imageUrl': imageUrl, 'types': types};
  }

  Pokemon toEntity() {
    return Pokemon(id: id, nombre: nombre, imageUrl: imageUrl, types: types);
  }
}
