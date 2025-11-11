import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:pokedex/features/pokemon/presentation/screens/pokemon_detail_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearch() async {
    final value = _searchController.text.trim();

    if (value.isEmpty) {
      context.read<PokemonProviders>().resetSearch();
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<PokemonProviders>().searchPokemon(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          //Input
          Row(
            spacing: 5,

            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: _searchController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Buscar Pokemon por nombre o ID",
                    border: const OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              context.read<PokemonProviders>().resetSearch();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                  onSubmitted: (_) => _onSearch(),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              IconButton(
                tooltip: 'Buscar',
                onPressed: _onSearch,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          const SizedBox(height: 8),
          //Pokemon Card
          Expanded(
            child: Consumer<PokemonProviders>(
              builder: (context, provider, child) {
                if (provider.searchStatus == PokemonStatus.initial) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Buscar Pokemon por nombre o ID',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (provider.isSearchLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Buscando Pokémon...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.searchStatus == PokemonStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ✅ AÑADIR: Ícono de error
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.searchErrorMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // ✅ AÑADIR: Botón para reintentar
                        ElevatedButton.icon(
                          onPressed: _onSearch,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final pokemon = provider.pokemon;

                if (pokemon == null) {
                  return const Center(child: Text("No se encontro el pokemon"));
                }

                return Center(
                  child: RefreshIndicator(
                    onRefresh: _onSearch,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PokemonDetailScreen(pokemon: pokemon),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Pokemon Imagef
                                  Hero(
                                    tag: 'pokemon-image-${pokemon.id}',
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final size =
                                            (constraints.maxWidth * 0.6).clamp(
                                              100.0,
                                              200.0,
                                            );
                                        return ClipRect(
                                          child: Image.network(
                                            fit: BoxFit.contain,
                                            pokemon.imageUrl,
                                            width: size,
                                            height: size,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.catching_pokemon,
                                                    size: size * 0.5,
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    pokemon.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ID: #${pokemon.id}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    children: pokemon.types.map((type) {
                                      return Chip(
                                        label: Text(
                                          type.toUpperCase(),
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
