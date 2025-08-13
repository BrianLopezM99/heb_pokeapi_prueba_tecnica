import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon.dart';

abstract class IPokemonRepository {
  Future<List<Pokemon>> fetchPokemonList({int offset, int limit});
}
