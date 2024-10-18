import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';

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

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

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

  factory Movie.fromJson(Map<String, dynamic> json, Map<int, String> genreMap) {
    List<String> genreNames = (json['genre_ids'] as List<dynamic>)
        .map((id) => genreMap[id] ?? 'Unknown')
        .toList();

    return Movie(
      id: json['id'],
      title: json['title'],
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
      genres: genreNames,
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
          tag: movie.id >= 1000 ? 'top-rated-movie-${movie.id}' : 'movie-poster-${movie.id}',
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
  late Map<int, String> _genreMap;

  MovieApiService({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient() {
    _initGenres();
  }

  Future<void> _initGenres() async {
    final data = await _networkClient.get('/genre/movie/list', queryParams: {
      'language': 'en-US',
    });

    final genres = (data['genres'] as List<dynamic>).map((genreData) => Genre.fromJson(genreData)).toList();
    _genreMap = Map.fromEntries(genres.map((genre) => MapEntry(genre.id, genre.name)));
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    await _initGenres(); // Ensure genres are loaded
    final data = await _networkClient.get('/movie/popular', queryParams: {
      'language': 'en-US',
      'page': page.toString(),
    });

    final results = data['results'] as List<dynamic>;
    return results.map((movieData) => Movie.fromJson(movieData, _genreMap)).toList();
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    await _initGenres(); // Ensure genres are loaded
    final data = await _networkClient.get('/movie/now_playing', queryParams: {
      'language': 'en-US',
      'page': page.toString(),
    });

    final results = data['results'] as List<dynamic>;
    return results.map((movieData) => Movie.fromJson(movieData, _genreMap)).toList();
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    await _initGenres(); // Ensure genres are loaded
    final data = await _networkClient.get('/movie/top_rated', queryParams: {
      'language': 'en-US',
      'page': page.toString(),
    });

    final results = data['results'] as List<dynamic>;
    return results.map((movieData) => Movie.fromJson(movieData, _genreMap)).toList();
  }
}

class MovieListViewModel extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieApiService _apiService;
  int _currentPage = 1;
  bool _isLoading = false;
  MovieDisplayMode _currentMode = MovieDisplayMode.popular;

  List<Movie> _topRatedMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _nowPlayingMovies = [];

  MovieListViewModel(this._apiService) : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  Future<void> fetchMovies({bool loadMore = false, MovieDisplayMode? mode}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      if (mode != null && mode != _currentMode) {
        _currentMode = mode;
        if (_currentMode == MovieDisplayMode.popular && _popularMovies.isEmpty) {
          _currentPage = 1;
        } else if (_currentMode == MovieDisplayMode.nowShowing && _nowPlayingMovies.isEmpty) {
          _currentPage = 1;
        } else {
          // If we already have movies for this mode, just update the state
          state = AsyncValue.data(_currentMode == MovieDisplayMode.popular ? _popularMovies : _nowPlayingMovies);
          _isLoading = false;
          return;
        }
      }

      if (loadMore) {
        _currentPage++;
      }

      final movies = _currentMode == MovieDisplayMode.popular
          ? await _apiService.getPopularMovies(page: _currentPage)
          : await _apiService.getNowPlayingMovies(page: _currentPage);
      
      if (_currentMode == MovieDisplayMode.popular) {
        _popularMovies = loadMore ? [..._popularMovies, ...movies] : movies;
        state = AsyncValue.data(_popularMovies);
      } else {
        _nowPlayingMovies = loadMore ? [..._nowPlayingMovies, ...movies] : movies;
        state = AsyncValue.data(_nowPlayingMovies);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadMore() async {
    await fetchMovies(loadMore: true);
  }

  Future<void> changeDisplayMode(MovieDisplayMode mode) async {
    if (mode != _currentMode) {
      await fetchMovies(mode: mode);
    }
  }

  Future<void> fetchTopRatedMovies() async {
    try {
      _topRatedMovies = await _apiService.getTopRatedMovies();
      state = AsyncValue.data(state.value ?? []);  // Trigger a rebuild
    } catch (e, stackTrace) {
      // Handle error
    }
  }

  List<Movie> get topRatedMovies => _topRatedMovies;
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
    final topRatedMovies = ref.watch(movieListViewModelProvider.notifier).topRatedMovies;

    // Fetch top rated movies when the page is built
    ref.read(movieListViewModelProvider.notifier).fetchTopRatedMovies();

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
              _buildTopRatedSection(topRatedMovies),
              const DisplayModeTitle(),
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

  Widget _buildTopRatedSection(List<Movie> topRatedMovies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Top Rated Movies',
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
          items: topRatedMovies.map((movie) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movie: movie),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'top-rated-movie-${movie.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(movie.posterPath ?? ''),
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
        ref.read(movieListViewModelProvider.notifier).changeDisplayMode(mode);
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
                          "${movie.genres.join(", ")}",
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

// New widget
class DisplayModeTitle extends ConsumerWidget {
  const DisplayModeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(movieDisplayModeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Movies',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[100]!.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSegmentButton(
                      context,
                      ref,
                      'Popular',
                      MovieDisplayMode.popular,
                      displayMode == MovieDisplayMode.popular,
                    ),
                  ),
                  Expanded(
                    child: _buildSegmentButton(
                      context,
                      ref,
                      'Now Playing',
                      MovieDisplayMode.nowShowing,
                      displayMode == MovieDisplayMode.nowShowing,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(BuildContext context, WidgetRef ref, String title, MovieDisplayMode mode, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ref.read(movieDisplayModeProvider.notifier).state = mode;
          ref.read(movieListViewModelProvider.notifier).changeDisplayMode(mode);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue[300]!.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}