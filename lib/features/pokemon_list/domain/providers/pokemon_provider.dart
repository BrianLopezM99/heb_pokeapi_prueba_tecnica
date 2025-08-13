import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/api/api_client.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/api/poke_api_service.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/repositories/pokemon_repository.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final pokeApiService = Provider<PokeApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PokeApiService(dioClient);
});

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  final apiService = ref.watch(pokeApiService);
  return PokemonRepository(apiService);
});
