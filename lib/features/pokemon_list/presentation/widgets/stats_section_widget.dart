import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/theme_change_provider.dart';

class StatsSection extends ConsumerWidget {
  final List<dynamic> stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Column(
      children: stats.map<Widget>((stat) {
        final statName = (stat['stat']['name'] as String).toUpperCase();
        final statValue = stat['base_stat'] as int;
        final percent = (statValue / 150).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  statName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: percent,
                  color: isDark ? Colors.lightGreenAccent : Colors.green,
                  backgroundColor: isDark
                      ? Colors.green.shade900
                      : Colors.green.shade100,
                  minHeight: 8,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 30,
                child: Text(
                  statValue.toString(),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
