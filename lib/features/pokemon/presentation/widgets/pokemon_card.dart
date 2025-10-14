import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 25, bottom: 15, top: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pokemon.nombre.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "#${pokemon.id}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(border: Border.all()),
              child: Image.network(pokemon.imageUrl, height: 50, width: 50),
            ),
            Text(
              'Tipos: ${pokemon.types.join(', ')}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
