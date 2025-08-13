class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<dynamic> abilities;
  final List<dynamic> types;
  final Map<String, dynamic> sprites;
  final String locationArea;
  final List<dynamic> stats;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.types,
    required this.sprites,
    required this.locationArea,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      abilities: json['abilities'],
      types: json['types'],
      sprites: json['sprites'],
      locationArea: json['location_area_encounters'] ?? 'Unknown',
      stats: json['stats'] ?? 'No stats available',
    );
  }
}
