import 'package:heb_pokeapi_prueba_tecnica/core/api/poke_api_service.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon_detail.dart';

class PokemonDetailRepository {
  final PokeApiService _pokeApiService;

  PokemonDetailRepository(this._pokeApiService);

  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    return _pokeApiService.fetchPokemonDetail(url);
  }
}
