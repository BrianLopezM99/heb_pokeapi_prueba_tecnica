import 'package:dio/dio.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/api/api_client.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon_detail.dart';

class PokeApiService {
  final DioClient _dioClient;

  PokeApiService(this._dioClient);

  Future<List<Pokemon>> fetchPokemonList({
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        'pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      final List<dynamic> results = response.data['results'];
      return results.map((e) => Pokemon.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load Pokémon list: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    try {
      final response = await _dioClient.dio.get(url);
      return PokemonDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load Pokémon details: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<String> fetchPokemonSpeciesDescription(int id) async {
    try {
      final response = await _dioClient.dio.get('pokemon-species/$id/');
      final flavorEntries =
          response.data['flavor_text_entries'] as List<dynamic>;
      final flavorTextEntry = flavorEntries.firstWhere(
        (entry) => entry['language']['name'] == 'en',
        orElse: () => null,
      );
      if (flavorTextEntry != null) {
        return (flavorTextEntry['flavor_text'] as String)
            .replaceAll('\n', ' ')
            .replaceAll('\f', ' ');
      }
      return 'No description available.';
    } on DioException catch (e) {
      throw Exception('Failed to load species description: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Pokemon> fetchPokemonByNameOrId(String nameOrId) async {
    try {
      final response = await _dioClient.dio.get('pokemon/$nameOrId');
      final data = response.data;
      return Pokemon.fromJson({
        'name': data['name'],
        'url': 'pokemon/${data['id']}',
      });
    } catch (e) {
      throw Exception('Pokémon no encontrado');
    }
  }
}
