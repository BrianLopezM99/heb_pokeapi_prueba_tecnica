import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/domain/providers/theme_change_provider.dart';
import 'package:heb_pokeapi_prueba_tecnica/features/pokemon_list/presentation/screens/pokemon_list_screen.dart';
import 'package:heb_pokeapi_prueba_tecnica/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
