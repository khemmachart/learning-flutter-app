import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/services/moview_api_service.dart';
import 'package:learning_flutter_app/modules/movie_list/movie_list_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.blue[700]!,
          secondary: Colors.blue[500]!,
          surface: Colors.white,
          background: Colors.grey[100]!,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[700],
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: const MovieListPage(title: 'Movie List'),
    );
  }
}

// Define a provider for the counter
final counterProvider = StateProvider<int>((ref) => 0);

// Define a provider for the display mode
final movieDisplayModeProvider = StateProvider<MovieDisplayMode>((ref) => MovieDisplayMode.popular);




final movieApiServiceProvider = Provider<MovieApiService>((ref) => MovieApiService());


