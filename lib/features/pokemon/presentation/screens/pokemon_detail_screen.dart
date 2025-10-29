import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/core/extensions/string_extensions.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text("Detalles Pokemon", style: TextStyle(fontSize: 15)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //Pokemon Image
                Container(
                  width: 150,
                  height: 125,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    // border: Border.all(
                    //   color: Theme.of(context).colorScheme.outline,
                    // ),
                    // borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                  ),
                  child: Hero(
                    tag: 'pokemon-image-${pokemon.id}',
                    child: ClipRRect(
                      child: Image.network(
                        pokemon.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.catching_pokemon, size: 100);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                //Pokemon Name
                Text(
                  pokemon.name.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                //Pokemon Id
                Text(
                  '#${pokemon.id}',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 15),
                //Types
                Wrap(
                  spacing: 5,
                  children: pokemon.types
                      .map(
                        (type) => Chip(
                          label: Text(
                            type.toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 5),
                //Abilites title
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        "Abilities",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                //Abilites
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    spacing: 5,
                    children: pokemon.abilities
                        .map(
                          (ability) => Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ability.name.capitalizeFirst(),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                //Stats title
                Row(
                  children: [
                    Text(
                      "Stats",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                //Stats
                Column(
                  children: pokemon.stats.asMap().entries.map((entry) {
                    final stat = entry.value;
                    final index = entry.key;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Stat name
                          SizedBox(
                            width: 70,
                            child: Text(
                              stat.name.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 10,
                              ),
                            ),
                          ),
                          //Stat bar
                          Expanded(
                            child: TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 1000 + (index * 150),
                              ),
                              curve: Curves.easeInOutCubic,
                              tween: Tween<double>(
                                begin: 0.0,
                                end: stat.valor / 255,
                              ),

                              builder: (context, value, child) {
                                return LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),

                          //Stat Value
                          TweenAnimationBuilder<int>(
                            duration: Duration(
                              milliseconds: 1000 + (index * 150),
                            ),
                            curve: Curves.easeOutCubic,
                            tween: IntTween(begin: 0, end: stat.valor),

                            builder: (context, value, child) {
                              return Text(
                                '$value',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
