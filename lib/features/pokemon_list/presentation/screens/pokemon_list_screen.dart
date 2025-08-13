import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/pokemon_list_notifier.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/theme_change_provider.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/presentation/screens/pokemon_detail_screen.dart';

class PokemonListScreen extends ConsumerStatefulWidget {
  const PokemonListScreen({super.key});

  @override
  ConsumerState<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends ConsumerState<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _sortAlphabetically = false; // Nuevo: controlar el orden

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isSearching &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      ref.read(pokemonListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemonListAsync = ref.watch(pokemonListProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 150).floor();
    final columns = crossAxisCount < 1 ? 1 : crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pokédex',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 5,
        actions: [
          // Botón para cambiar orden
          IconButton(
            icon: Icon(
              _sortAlphabetically ? Icons.sort_by_alpha : Icons.numbers,
              color: Colors.white,
            ),
            tooltip: _sortAlphabetically
                ? 'Ordenar por número'
                : 'Ordenar alfabéticamente',
            onPressed: () {
              setState(() {
                _sortAlphabetically = !_sortAlphabetically;
              });
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(themeModeProvider);
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .state = themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.white,
                hintText: 'Buscar Pokémon por ID o nombre...',
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                ref.read(pokemonListProvider.notifier).search(query);
                setState(() {
                  _isSearching = query.isNotEmpty;
                });
              },
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: pokemonListAsync.when(
        data: (pokemons) {
          if (pokemons.isEmpty && _searchController.text.isNotEmpty) {
            return const Center(
              child: Text(
                'No se encontraron Pokémon.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Ordenar según la preferencia
          final sortedPokemons = [...pokemons];
          if (_sortAlphabetically) {
            sortedPokemons.sort((a, b) => a.name.compareTo(b.name));
          } else {
            sortedPokemons.sort((a, b) => a.id.compareTo(b.id));
          }

          final itemCount = sortedPokemons.length + (_isSearching ? 0 : 1);
          final themeColor = ref.watch(themeModeProvider) == ThemeMode.dark;

          return GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.8,
            ),
            padding: const EdgeInsets.all(10.0),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index < sortedPokemons.length) {
                final pokemon = sortedPokemons[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PokemonDetailScreen(pokemon: pokemon),
                      ),
                    );
                  },
                  child: Hero(
                    tag: pokemon.name,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  pokemon.animatedImageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              pokemon.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'ID: ${pokemon.id}',
                              style: TextStyle(
                                fontSize: 14,
                                color: themeColor
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  ),
                );
              }
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.redAccent),
        ),
        error: (error, stackTrace) => const Center(
          child: Text(
            'Error al cargar los Pokémon.',
            style: TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
