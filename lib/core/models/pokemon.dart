class Pokemon {
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  int get id {
    final uri = Uri.parse(url);
    var idString = uri.pathSegments[uri.pathSegments.length - 2];
    if (uri.pathSegments.length < 4) {
      idString = uri.pathSegments[uri.pathSegments.length - 1];
      return int.parse(idString);
    } else {
      return int.parse(idString);
    }
  }

  // Getter para obtener la URL del GIF animado
  String get animatedImageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$id.gif';

  // Getter para obtener la URL de la imagen estatica
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}
