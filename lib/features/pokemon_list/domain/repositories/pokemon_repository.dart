import 'package:heb_pokeapi_prueba_tecnica/core/api/poke_api_service.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/repositories/i_pokemon_repository.dart';

class PokemonRepository implements IPokemonRepository {
  final PokeApiService _pokeApiService;

  PokemonRepository(this._pokeApiService);

  @override
  Future<List<Pokemon>> fetchPokemonList({int offset = 0, int limit = 20}) {
    return _pokeApiService.fetchPokemonList(offset: offset, limit: limit);
  }

  // pokemon_repository.dart

  Future<Pokemon> fetchPokemonByNameOrId(String nameOrId) {
    return _pokeApiService.fetchPokemonByNameOrId(nameOrId);
  }
}
