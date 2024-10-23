import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/modules/movie_list/movie_list_page.dart';
import 'package:learning_flutter_app/core/services/movie_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/review.dart';

class MovieListViewModel extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieApiService _apiService;
  int _currentPage = 1;
  bool _isLoading = false;
  MovieDisplayMode _currentMode = MovieDisplayMode.popular;

  Map<MovieDisplayMode, List<Movie>> _movieCache = {
    MovieDisplayMode.popular: [],
    MovieDisplayMode.nowShowing: [],
  };
  List<Movie> _topRatedMovies = [];

  MovieListViewModel(this._apiService) : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  Future<void> fetchMovies({bool loadMore = false, MovieDisplayMode? mode}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      if (mode != null && mode != _currentMode) {
        _currentMode = mode;
        if (_movieCache[_currentMode]!.isEmpty) {
          _currentPage = 1;
        } else {
          state = AsyncValue.data(_movieCache[_currentMode]!);
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
      
      _movieCache[_currentMode] = loadMore 
          ? [..._movieCache[_currentMode]!, ...movies] 
          : movies;
      
      state = AsyncValue.data(_movieCache[_currentMode]!);
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
      state = AsyncValue.error(e, stackTrace);
    }
  }

  List<Movie> get topRatedMovies => _topRatedMovies;

  Future<Movie> fetchMovieDetails(int movieId) async {
    try {
      return await _apiService.getMovieDetails(movieId);
    } catch (e, stackTrace) {
      throw AsyncError(e, stackTrace);
    }
  }

  Future<List<Review>> fetchMovieReviews(int movieId, {int page = 1}) async {
    try {
      return await _apiService.getMovieReviews(movieId, page: page);
    } catch (e, stackTrace) {
      throw AsyncError(e, stackTrace);
    }
  }
}