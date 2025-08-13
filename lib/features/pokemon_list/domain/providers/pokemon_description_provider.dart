import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/api/poke_api_service.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/pokemon_provider.dart';

final pokeApiServiceProvider = Provider<PokeApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PokeApiService(dioClient);
});

final pokemonSpeciesDescriptionProvider = FutureProvider.family<String, int>((
  ref,
  id,
) async {
  final service = ref.watch(pokeApiServiceProvider);
  return service.fetchPokemonSpeciesDescription(id);
});
