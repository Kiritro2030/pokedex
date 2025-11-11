import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/features/pokemon/data/datasources/favorites_local_data_source.dart';
import 'package:pokedex/features/pokemon/domain/repositories/favorites_repository_impl.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_favorites.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemons.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemon.dart';
import 'package:pokedex/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_respository_impl.dart';
import 'package:pokedex/features/pokemon/domain/usecases/toggle_favorite.dart';
import 'package:pokedex/features/pokemon/presentation/providers/favorites_provider.dart';
import 'package:pokedex/features/pokemon/presentation/screens/dashboard.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            // 1. Crear client http
            final client = http.Client();
            // 2. Crear el DataSource
            final dataSource = PokemonRemoteDataSourceImpl(client: client);
            // 3. Crear el Repository
            final repository = PokemonRepositoryImpl(
              remoteDataSource: dataSource,
            );
            // 4. Crear el UseCase
            final getPokemons = GetPokemons(repository);
            final getPokemon = GetPokemon(repository);
            // 5. Crear el provider
            return PokemonProviders(
              getPokemons: getPokemons,
              getPokemon: getPokemon,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            //1. Crear el DataSource
            final dataSource = FavoritesLocalDataSourceImpl(pref: prefs);

            //2. Crear el repositorio
            final repository = FavoritesRepositoryImpl(dataSource: dataSource);

            //3. Crear los UseCases
            final toggleFavorite = ToggleFavorite(repository);
            final getFavorites = GetFavorites(repository);

            //4. Crear le provider
            return FavoritesProvider(toggleFavorite, getFavorites);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Pokedex',
        theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
        home: Dashboard(),
      ),
    );
  }
}
