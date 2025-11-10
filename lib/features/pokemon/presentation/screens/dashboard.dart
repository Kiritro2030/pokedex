import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/presentation/providers/pokemon_providers.dart';
import 'package:pokedex/features/pokemon/presentation/screens/favorite_screen.dart';
import 'package:pokedex/features/pokemon/presentation/screens/pokemon_detail_screen.dart';
import 'package:pokedex/features/pokemon/presentation/screens/pokemon_list_screen.dart';
import 'package:pokedex/features/pokemon/presentation/screens/search_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    _buildDashboardScreen(),
    PokemonListScreen(),
    SearchScreen(),
    FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex", style: TextStyle(fontSize: 15)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        toolbarHeight: 40,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon, color: Colors.deepOrange),
            label: "Pokemon",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.blue),
            label: "Buscar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.red),
            label: "Favoritos",
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  Widget _buildDashboardScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ],
              ),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bienvenido a",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "Tu Pokédex",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Descubre y colecciona todos los Pokémon",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Quick Access Cards
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Acceso Rápido",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildQuickAccessCard(
                  icon: Icons.catching_pokemon,
                  title: "Explorar todos los Pokémon",
                  subtitle: "Ver lista completa",
                  color: Colors.red,
                  onTap: () => _onItemTapped(1),
                ),
                SizedBox(height: 12),
                _buildQuickAccessCard(
                  icon: Icons.search,
                  title: "Buscar Pokémon",
                  subtitle: "Encuentra tu favorito",
                  color: Colors.blue,
                  onTap: () => _onItemTapped(2),
                ),
                SizedBox(height: 12),
                _buildQuickAccessCard(
                  icon: Icons.favorite,
                  title: "Mis Favoritos",
                  subtitle: "Tus Pokémon guardados",
                  color: Colors.pink,
                  onTap: () => _onItemTapped(3),
                ),
              ],
            ),
          ),

          // Featured Pokemon Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pokémon Destacados",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildFeaturedPokemon("pikachu", 25, Colors.yellow),
                    _buildFeaturedPokemon("charizard", 6, Colors.orange),
                    _buildFeaturedPokemon("blastoise", 9, Colors.blue),
                    _buildFeaturedPokemon("venusaur", 3, Colors.green),
                    _buildFeaturedPokemon("mewtwo", 150, Colors.purple),
                    _buildFeaturedPokemon("eevee", 133, Colors.brown),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedPokemon(String name, int id, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          final provider = context.read<PokemonProviders>();
          await provider.searchPokemon(name);
          final pokemon = provider.pokemon;
          provider.resetSearch();
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) {
                return PokemonDetailScreen(pokemon: pokemon!);
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'pokemon-image-$id',
                    child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',

                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  name[0].toUpperCase() + name.substring(1),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
