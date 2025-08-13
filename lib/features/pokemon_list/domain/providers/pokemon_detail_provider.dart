import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon_detail.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/pokemon_provider.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/repositories/pokemon_detail_repository.dart';

final pokemonDetailRepositoryProvider = Provider<PokemonDetailRepository>((
  ref,
) {
  final apiService = ref.watch(pokeApiService);
  return PokemonDetailRepository(apiService);
});

final pokemonDetailProvider = FutureProvider.family<PokemonDetail, String>((
  ref,
  pokemonUrl,
) async {
  final repository = ref.watch(pokemonDetailRepositoryProvider);
  return repository.fetchPokemonDetail(pokemonUrl);
});
