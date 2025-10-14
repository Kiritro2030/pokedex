import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemons.dart';
import 'package:pokedex/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_respository_impl.dart';
import 'package:pokedex/features/pokemon/presentation/screens/dashboard.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            final repository = PokemonRespositoryImpl(
              remoteDataSource: dataSource,
            );
            // 4. Crear el UseCase
            final useCase = GetPokemons(repository);
            // 5. Crear el provider
            return PokemonProviders(getPokemons: useCase);
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
