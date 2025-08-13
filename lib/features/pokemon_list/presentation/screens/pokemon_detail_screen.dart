import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/models/pokemon.dart';
import 'package:heb_pokeapi_prueba_tecnica/core/pokemon_colors.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/pokemon_description_provider.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/pokemon_detail_provider.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/theme_change_provider.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/presentation/widgets/info_box_widget.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/presentation/widgets/stats_section_widget.dart';

class PokemonDetailScreen extends ConsumerWidget {
  final Pokemon pokemon;
  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonDetailsAsync = ref.watch(pokemonDetailProvider(pokemon.url));
    final themeColor = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: !themeColor ? Colors.white : Colors.grey.shade700,
      body: pokemonDetailsAsync.when(
        data: (details) {
          final mainType = details.types.first['type']['name'] as String;
          final typeColor = getPokemonTypeColor(mainType);
          final speciesDescriptionAsync = ref.watch(
            pokemonSpeciesDescriptionProvider(details.id),
          );

          return Stack(
            children: [
              // Fondo degradado segun el tipo
              Container(
                height: MediaQuery.of(context).size.height * 0.33,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      typeColor.withOpacity(0.9),
                      typeColor.withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Barra ID y estrella
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // circulito
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'ID',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        details.id.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Imagen principal
                      Hero(
                        tag: pokemon.name,
                        child: Image.network(
                          pokemon.animatedImageUrl,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Row galeria de sprites
                      SizedBox(
                        height: 80,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final entry
                                  in details.sprites.entries.toList().reversed)
                                if (entry.value != null &&
                                    entry.value is String)
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            entry.value as String,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image),
                                          ),
                                        ),
                                        if (entry.key.contains('female'))
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.pinkAccent
                                                    .withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.female,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        else
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent
                                                    .withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.male,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Estadisticas
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: StatsSection(stats: details.stats),
                      ),

                      const SizedBox(height: 16),

                      //Peso, altura, tipos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InfoBox(
                              label: 'Weight',
                              value: '${details.weight / 10} kg',
                              icon: Icons.fitness_center,
                            ),
                            InfoBox(
                              label: 'Height',
                              value: '${details.height / 10} m',
                              icon: Icons.height,
                            ),
                            Row(
                              children: details.types.map<Widget>((type) {
                                final typeName = type['type']['name'] as String;
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: getPokemonTypeColor(typeName),
                                  ),
                                  child: Text(
                                    typeName.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Descripcion
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: speciesDescriptionAsync.when(
                          data: (description) => Text(
                            description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) =>
                              const Text('Error loading description'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Movimientos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Moves',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: typeColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: details.abilities.take(10).map<Widget>((
                                move,
                              ) {
                                final moveName =
                                    move["ability"]["name"] as String;
                                return Chip(
                                  label: Text(moveName),
                                  backgroundColor: typeColor.withOpacity(0.7),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
