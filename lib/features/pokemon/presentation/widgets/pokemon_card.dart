import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:pokedex/features/pokemon/presentation/screens/pokemon_detail_screen.dart';
import 'package:provider/provider.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () async {
        final provider = context.read<PokemonProviders>();

        await provider.searchPokemon('${widget.pokemon.id}');

        if (!context.mounted) return;

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PokemonDetailScreen(pokemon: provider.pokemon!),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Hero(
              tag: 'pokemon-image-${widget.pokemon.id}',
              child: CachedNetworkImage(
                imageUrl: widget.pokemon.imageUrl,
                placeholder: (context, url) => const SizedBox(
                  // Añade placeholder
                  width: 56,
                  height: 56,
                  child: Center(child: Icon(Icons.catching_pokemon, size: 56)),
                ),
                memCacheHeight: 200,
                memCacheWidth: 200,
                maxHeightDiskCache: 200,
                maxWidthDiskCache: 200,
                width: 56,
                height: 56,
                fadeInDuration: const Duration(milliseconds: 200),
                errorWidget: (context, error, stackTrace) {
                  return const Icon(Icons.catching_pokemon, size: 56);
                },
              ),
            ),
            title: Text(
              widget.pokemon.name.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // subtitle: Text(
            //   'Tipos: ${pokemon.types.join(', ')}',
            //   style: const TextStyle(fontSize: 12),
            // ),
            trailing: Text(
              '#${widget.pokemon.id}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
