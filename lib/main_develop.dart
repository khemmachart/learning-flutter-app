import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;

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
      title: 'Flutter Demo (Dev)',
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
      home: const MovieListPage(title: 'Movie List (Dev)'),
    );
  }
}

// Define a provider for the counter
final counterProvider = StateProvider<int>((ref) => 0);

// Define an enum for display modes
enum MovieDisplayMode { popular, nowShowing }

// Define a provider for the display mode
final movieDisplayModeProvider = StateProvider<MovieDisplayMode>((ref) => MovieDisplayMode.popular);

class Movie {
  final int id;
  final String title;
  final double voteAverage;
  final String overview;
  final List<String> genres;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final int? runtime;
  final List<Cast> cast;

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.genres,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    this.runtime,
    required this.cast,
  });
}

class Cast {
  final String name;
  final String? character;
  final String? profilePath;

  Cast({required this.name, this.character, this.profilePath});
}

// Mock movie data provider
final moviesProvider = Provider<List<Movie>>((ref) {
  return List.generate(10, (index) {
    return Movie(
      id: index + 1,
      title: 'Movie ${String.fromCharCode(65 + index)}',
      voteAverage: 4 + (index % 2),
      overview: 'This is a sample overview for Movie ${String.fromCharCode(65 + index)}. '
          'It\'s an exciting adventure film that will keep you on the edge of your seat!',
      genres: ['Action', 'Adventure'],
      posterPath: 'https://via.placeholder.com/300x450?text=Movie+${String.fromCharCode(65 + index)}',
      backdropPath: 'https://via.placeholder.com/1280x720?text=Movie+${String.fromCharCode(65 + index)}+Backdrop',
      releaseDate: '2023-${(index % 12 + 1).toString().padLeft(2, '0')}-01',
      runtime: 90 + (index * 5),
      cast: List.generate(5, (castIndex) => Cast(
        name: 'Actor ${castIndex + 1}',
        character: 'Character ${castIndex + 1}',
        profilePath: 'https://via.placeholder.com/185x278?text=Actor+${castIndex + 1}',
      )),
    );
  });
});

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieInfo(),
                  const SizedBox(height: 16),
                  _buildOverview(),
                  const SizedBox(height: 16),
                  _buildCast(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(movie.title),
        background: movie.backdropPath != null
            ? Image.network(
                movie.backdropPath!,
                fit: BoxFit.cover,
              )
            : Container(color: Colors.grey),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.posterPath != null)
          Image.network(movie.posterPath!, height: 150)
        else
          Container(
            height: 150,
            width: 100,
            color: Colors.grey,
            child: const Icon(Icons.movie, color: Colors.white),
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Release Date: ${movie.releaseDate}'),
              if (movie.runtime != null) Text('Runtime: ${movie.runtime} minutes'),
              Text('Genres: ${movie.genres.join(", ")}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(movie.overview),
      ],
    );
  }

  Widget _buildCast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cast',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie.cast.length,
            itemBuilder: (context, index) {
              final cast = movie.cast[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: cast.profilePath != null
                          ? NetworkImage(cast.profilePath!)
                          : null,
                      child: cast.profilePath == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(cast.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (cast.character != null)
                      Text(cast.character!, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MovieListPage extends ConsumerWidget {
  const MovieListPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(movieDisplayModeProvider);
    final movies = ref.watch(moviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          _buildDisplayModeButton(displayMode, ref),
        ],
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _buildMovieListItem(context, movie);
        },
      ),
    );
  }

  Widget _buildDisplayModeButton(MovieDisplayMode displayMode, WidgetRef ref) {
    return PopupMenuButton<MovieDisplayMode>(
      initialValue: displayMode,
      onSelected: (MovieDisplayMode mode) {
        ref.read(movieDisplayModeProvider.notifier).state = mode;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MovieDisplayMode>>[
        const PopupMenuItem<MovieDisplayMode>(
          value: MovieDisplayMode.popular,
          child: Text('Popular'),
        ),
        const PopupMenuItem<MovieDisplayMode>(
          value: MovieDisplayMode.nowShowing,
          child: Text('Now Showing'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              displayMode == MovieDisplayMode.popular ? 'Popular' : 'Now Showing',
              style: TextStyle(color: Colors.blue[700]),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieListItem(BuildContext context, Movie movie) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 75,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.movie, color: Colors.white),
        ),
        title: Text(
          movie.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
        ),
        subtitle: Text(movie.genres.join(", "), style: TextStyle(color: Colors.grey[600])),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber[700], size: 20),
            const SizedBox(width: 4),
            Text(movie.voteAverage.toStringAsFixed(1), style: TextStyle(color: Colors.grey[800])),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(movie: movie),
            ),
          );
        },
      ),
    );
  }
}
