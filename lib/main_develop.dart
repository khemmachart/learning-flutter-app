import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

// Add this provider after the other providers
final userInfoProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'name': 'John Doe',
    'avatar': 'https://i.pravatar.cc/150?img=8',
    'favoriteGenres': ['Action', 'Sci-Fi', 'Comedy'],
    'recommendedMovies': [
      Movie(
        id: 1,
        title: 'Inception',
        voteAverage: 8.8,
        overview: 'A thief who enters the dreams of others to steal secrets from their subconscious.',
        genres: ['Action', 'Sci-Fi', 'Thriller'],
        posterPath: 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
        releaseDate: '2010-07-16',
        cast: [],
      ),
      Movie(
        id: 2,
        title: 'The Matrix',
        voteAverage: 8.7,
        overview: 'A computer programmer discovers that reality as he knows it is a simulation created by machines.',
        genres: ['Action', 'Sci-Fi'],
        posterPath: 'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg',
        releaseDate: '1999-03-31',
        cast: [],
      ),
      Movie(
        id: 3,
        title: 'Guardians of the Galaxy',
        voteAverage: 8.0,
        overview: 'A group of intergalactic misfits team up to save the galaxy.',
        genres: ['Action', 'Sci-Fi', 'Comedy'],
        posterPath: 'https://image.tmdb.org/t/p/w500/r7vmZjiyZw9rpJMQJdXpjgiCOk9.jpg',
        releaseDate: '2014-08-01',
        cast: [],
      ),
    ],
  };
});

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

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
      genres: (json['genre_ids'] as List<dynamic>).map((id) => id.toString()).toList(),
      posterPath: json['poster_path'] != null ? 'https://image.tmdb.org/t/p/w200${json['poster_path']}' : null,
      backdropPath: json['backdrop_path'] != null ? 'https://image.tmdb.org/t/p/original${json['backdrop_path']}' : null,
      releaseDate: json['release_date'],
      runtime: null,
      cast: [],
    );
  }
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
                  Hero(
                    tag: 'movie-info-${movie.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: _buildMovieInfo(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOverview(),
                  const SizedBox(height: 16),
                  _buildCast(),
                  const SizedBox(height: 24),
                  _buildRecommendations(),
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
        title: Hero(
          tag: 'movie-title-${movie.id}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              movie.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        background: Hero(
          tag: 'movie-poster-${movie.id}',
          child: movie.backdropPath != null
              ? Image.network(
                  movie.backdropPath!,
                  fit: BoxFit.cover,
                )
              : Container(color: Colors.grey),
        ),
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

  Widget _buildRecommendations() {
    // Mock data for recommendations
    final recommendations = List.generate(
      5,
      (index) => Movie(
        id: 1000 + index,
        title: 'Recommended Movie ${index + 1}',
        voteAverage: 4.5 + (index * 0.1),
        overview: 'A great recommended movie!',
        genres: ['Action', 'Adventure'],
        posterPath: 'https://via.placeholder.com/300x450?text=Recommended+${index + 1}',
        releaseDate: '2023-06-01',
        cast: [],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommendations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: recommendations.map((movie) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(movie.posterPath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class NetworkClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YjI5ZWNiOWI1YzlkY2E4ODBhZjE1YTZmM2NlNjgyZCIsIm5iZiI6MTcyODkyMDY4Ny42MjY2OTksInN1YiI6IjY3MGQzYmIxZDVmOTNhM2RhMGJiY2M3ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6SOjjGI7YB0-8H2oZuf5VZXAKXcSOykJmqfqTtOUlyE';

  final http.Client _client;

  NetworkClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParams);
    final response = await _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}

class MovieApiService {
  final NetworkClient _networkClient;

  MovieApiService({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient();

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final data = await _networkClient.get('/discover/movie', queryParams: {
      'include_adult': 'false',
      'include_video': 'false',
      'language': 'en-US',
      'page': page.toString(),
      'sort_by': 'popularity.desc',
    });

    final results = data['results'] as List<dynamic>;
    return results.map((movieData) => Movie.fromJson(movieData)).toList();
  }
}

class MovieListViewModel extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieApiService _apiService;
  int _currentPage = 1;
  bool _isLoading = false;

  MovieListViewModel(this._apiService) : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  Future<void> fetchMovies({bool loadMore = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      if (!loadMore) {
        state = const AsyncValue.loading();
        _currentPage = 1;
      }

      final movies = await _apiService.getPopularMovies(page: _currentPage);
      
      if (loadMore) {
        final currentMovies = state.value ?? [];
        state = AsyncValue.data([...currentMovies, ...movies]);
      } else {
        state = AsyncValue.data(movies);
      }

      _currentPage++;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadMore() async {
    await fetchMovies(loadMore: true);
  }
}

final movieApiServiceProvider = Provider<MovieApiService>((ref) => MovieApiService());

final movieListViewModelProvider = StateNotifierProvider<MovieListViewModel, AsyncValue<List<Movie>>>((ref) {
  final apiService = ref.watch(movieApiServiceProvider);
  return MovieListViewModel(apiService);
});

class MovieListPage extends ConsumerWidget {
  const MovieListPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(movieDisplayModeProvider);
    final moviesAsyncValue = ref.watch(movieListViewModelProvider);
    final userInfo = ref.watch(userInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          _buildDisplayModeButton(displayMode, ref),
        ],
      ),
      body: moviesAsyncValue.when(
        data: (movies) => NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              ref.read(movieListViewModelProvider.notifier).loadMore();
            }
            return true;
          },
          child: ListView(
            children: [
              _buildRecommendationsSection(userInfo['recommendedMovies']),
              ...movies.map((movie) => _buildMovieListItem(context, movie)).toList(),
              _buildLoadMoreIndicator(),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildRecommendationsSection(List<Movie> recommendations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Recommended for You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: recommendations.map((movie) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(movie.posterPath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: Movie poster
              Hero(
                tag: 'movie-poster-${movie.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: movie.posterPath != null
                    ? Image.network(
                        movie.posterPath!,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.movie, color: Colors.white, size: 40),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              // Right column: Movie info
              Expanded(
                child: Hero(
                  tag: 'movie-info-${movie.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Type: ${movie.genres.join(", ")}",
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.overview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[800], fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber[700], size: 20),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
