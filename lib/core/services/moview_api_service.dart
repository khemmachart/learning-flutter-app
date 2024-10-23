import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/genre.dart';
import 'package:learning_flutter_app/core/models/review.dart';
import 'package:learning_flutter_app/core/networks/network_client.dart';

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

  Future<Movie> getMovieDetails(int movieId) async {
    await _initGenres(); // Ensure genres are loaded
    final data = await _networkClient.get('/movie/$movieId', queryParams: {
      'language': 'en-US',
      'append_to_response': 'credits',
    });

    return Movie.fromJson(data, _genreMap);
  }

  Future<List<Review>> getMovieReviews(int movieId, {int page = 1}) async {
    final data = await _networkClient.get('/movie/$movieId/reviews', queryParams: {
      'language': 'en-US',
      'page': page.toString(),
    });

    final results = data['results'] as List<dynamic>;
    return results.map((reviewData) => Review.fromJson(reviewData)).toList();
  }
}