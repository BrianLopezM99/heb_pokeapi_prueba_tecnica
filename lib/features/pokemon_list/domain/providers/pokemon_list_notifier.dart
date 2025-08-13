import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/pokemon_provider.dart';

enum SortType { id, name }

class PokemonListState {
  final List<Pokemon> pokemons;
  final bool isLoadingMore;

  PokemonListState({required this.pokemons, this.isLoadingMore = false});
}

final pokemonListProvider =
    AsyncNotifierProvider<PokemonListNotifier, List<Pokemon>>(() {
      return PokemonListNotifier();
    });

class PokemonListNotifier extends AsyncNotifier<List<Pokemon>> {
  int _offset = 0;
  static const int _limit = 20;
  List<Pokemon> _allPokemons = [];
  String _currentSearchQuery = '';
  SortType _currentSortType = SortType.id;
  bool _isLoadingMore = false;

  @override
  Future<List<Pokemon>> build() async {
    final repository = ref.watch(pokemonRepositoryProvider);
    final initialPokemons = await repository.fetchPokemonList(
      offset: _offset,
      limit: _limit,
    );
    _offset += _limit;
    _allPokemons.addAll(initialPokemons);
    return _applyFiltersAndSort();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    state = AsyncValue.data(state.value!);

    try {
      final repository = ref.watch(pokemonRepositoryProvider);
      final newPokemons = await repository.fetchPokemonList(
        offset: _offset,
        limit: _limit,
      );
      _offset += _limit;
      _allPokemons.addAll(newPokemons);
      state = AsyncValue.data(_applyFiltersAndSort());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } finally {
      _isLoadingMore = false;
    }
  }

  void search(String query) async {
    final repository = ref.watch(pokemonRepositoryProvider);

    final id = int.tryParse(query);

    if (id != null) {
      // Búsqueda por ID (ya funciona)
      final newPokemonsById = await repository.fetchPokemonList(
        offset: id - 1,
        limit: 1,
      );
      state = AsyncValue.data(newPokemonsById);
    } else {
      // Primero buscamos localmente
      final localMatch = _allPokemons
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (localMatch.isNotEmpty) {
        state = AsyncValue.data(localMatch);
      } else {
        // Si no está local, llamamos a la API
        try {
          state = AsyncValue.loading();
          final pokemonFromApi = await repository.fetchPokemonByNameOrId(
            query.toLowerCase(),
          );
          _allPokemons.add(pokemonFromApi); // agregamos a la lista local
          state = AsyncValue.data([pokemonFromApi]);
        } catch (e) {
          state = AsyncValue.error('Pokémon no encontrado', StackTrace.current);
        }
      }
    }
  }

  void sort(SortType type) {
    _currentSortType = type;
    state = AsyncValue.data(_applyFiltersAndSort());
  }

  List<Pokemon> _applyFiltersAndSort() {
    List<Pokemon> filteredList = _allPokemons.where((pokemon) {
      return pokemon.name.toLowerCase().contains(
        _currentSearchQuery.toLowerCase(),
      );
    }).toList();

    if (_currentSortType == SortType.id) {
      filteredList.sort((a, b) => a.id.compareTo(b.id));
    } else {
      filteredList.sort((a, b) => a.name.compareTo(b.name));
    }
    return filteredList;
  }
}
