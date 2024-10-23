import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/genre.dart';
import 'package:learning_flutter_app/core/models/review.dart';
import 'package:learning_flutter_app/core/networks/network_client.dart';
import 'package:learning_flutter_app/core/utils/logger.dart';

class MovieApiService {
  final NetworkClient _networkClient;
  late Map<int, String> _genreMap;

  MovieApiService({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient() {
    _initGenres();
  }

  Future<void> _initGenres() async {
    logger.d('Initializing genres');
    try {
      final data = await _networkClient.get('/genre/movie/list', queryParams: {
        'language': 'en-US',
      });

      final genres = (data['genres'] as List<dynamic>).map((genreData) => Genre.fromJson(genreData)).toList();
      _genreMap = Map.fromEntries(genres.map((genre) => MapEntry(genre.id, genre.name)));
      logger.i('Genres initialized successfully');
    } catch (e) {
      logger.e('Error initializing genres: $e');
      rethrow;
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    logger.d('Fetching popular movies, page: $page');
    await _initGenres(); // Ensure genres are loaded
    try {
      final data = await _networkClient.get('/movie/popular', queryParams: {
        'language': 'en-US',
        'page': page.toString(),
      });

      final results = data['results'] as List<dynamic>;
      final movies = results.map((movieData) => Movie.fromJson(movieData, _genreMap)).toList();
      logger.i('Fetched ${movies.length} popular movies');
      return movies;
    } catch (e) {
      logger.e('Error fetching popular movies: $e');
      rethrow;
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    logger.d('Fetching now playing movies, page: $page');
    await _initGenres(); // Ensure genres are loaded
    try {
      final data = await _networkClient.get('/movie/now_playing', queryParams: {
        'language': 'en-US',
        'page': page.toString(),
      });

      final results = data['results'] as List<dynamic>;
      final movies = results.map((movieData) => Movie.fromJson(movieData, _genreMap)).toList();
      logger.i('Fetched ${movies.length} now playing movies');
      return movies;
    } catch (e) {
      logger.e('Error fetching now playing movies: $e');
      rethrow;
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    logger.d('Fetching top rated movies, page: $page');
    await _initGenres(); // Ensure genres are loaded
    try {
      final data = await _networkClient.get('/movie/top_rated', queryParams: {
        'language': 'en-US',
        'page': page.toString(),
      });

      final results = data['results'] as List<dynamic>;
      final movies = results.map((movieData) => Movie.fromJson(movieData, _genreMap)).toList();
      logger.i('Fetched ${movies.length} top rated movies');
      return movies;
    } catch (e) {
      logger.e('Error fetching top rated movies: $e');
      rethrow;
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    logger.d('Fetching details for movie ID: $movieId');
    await _initGenres(); // Ensure genres are loaded
    try {
      final data = await _networkClient.get('/movie/$movieId', queryParams: {
        'language': 'en-US',
        'append_to_response': 'credits',
      });

      final movie = Movie.fromJson(data, _genreMap);
      logger.i('Fetched details for movie: ${movie.title}');
      return movie;
    } catch (e) {
      logger.e('Error fetching movie details: $e');
      rethrow;
    }
  }

  Future<List<Review>> getMovieReviews(int movieId, {int page = 1}) async {
    logger.d('Fetching reviews for movie ID: $movieId, page: $page');
    try {
      final data = await _networkClient.get('/movie/$movieId/reviews', queryParams: {
        'language': 'en-US',
        'page': page.toString(),
      });

      final results = data['results'] as List<dynamic>;
      final reviews = results.map((reviewData) => Review.fromJson(reviewData)).toList();
      logger.i('Fetched ${reviews.length} reviews for movie ID: $movieId');
      return reviews;
    } catch (e) {
      logger.e('Error fetching movie reviews: $e');
      rethrow;
    }
  }
}