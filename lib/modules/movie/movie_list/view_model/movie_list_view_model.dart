import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/review.dart';
import 'package:learning_flutter_app/core/services/movie_service.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/state/movie_list_state.dart';

class MovieListViewModel extends StateNotifier<MovieListState> {
  final MovieService _apiService;

  MovieListViewModel(this._apiService) : super(const MovieListState()) {
    fetchMovies();
  }

  Future<void> fetchMovies({bool loadMore = false, MovieDisplayMode? mode}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);

    try {
      if (mode != null && mode != state.currentMode) {
        state = state.copyWith(currentMode: mode);
      }

      if (state.currentMode == MovieDisplayMode.popular) {
        if (state.popularMovies.isEmpty || loadMore) {
          await fetchPopularMovies(loadMore: loadMore);
        }
      } else {
        if (state.nowPlayingMovies.isEmpty || loadMore) {
          await fetchNowPlayingMovies(loadMore: loadMore);
        }
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error
    }
  }

  Future<void> fetchPopularMovies({bool loadMore = false}) async {
    final currentPage = loadMore ? state.popularCurrentPage + 1 : 1;
    final movies = await _apiService.getPopularMovies(page: currentPage);
    
    final updatedMovies = loadMore ? [...state.popularMovies, ...movies] : movies;

    state = state.copyWith(
      popularMovies: updatedMovies,
      popularCurrentPage: currentPage,
    );
  }

  Future<void> fetchNowPlayingMovies({bool loadMore = false}) async {
    final currentPage = loadMore ? state.nowPlayingCurrentPage + 1 : 1;
    final movies = await _apiService.getNowPlayingMovies(page: currentPage);
    
    final updatedMovies = loadMore ? [...state.nowPlayingMovies, ...movies] : movies;

    state = state.copyWith(
      nowPlayingMovies: updatedMovies,
      nowPlayingCurrentPage: currentPage,
    );
  }

  Future<void> loadMore() async {
    await fetchMovies(loadMore: true);
  }

  Future<void> changeDisplayMode(MovieDisplayMode mode) async {
    if (mode != state.currentMode) {
      state = state.copyWith(currentMode: mode);
      if ((mode == MovieDisplayMode.popular && state.popularMovies.isEmpty) ||
          (mode == MovieDisplayMode.nowShowing && state.nowPlayingMovies.isEmpty)) {
        await fetchMovies();
      }
    }
  }

  Future<void> fetchTopRatedMovies() async {
    try {
      final topRatedMovies = await _apiService.getTopRatedMovies();
      state = state.copyWith(topRatedMovies: topRatedMovies);
    } catch (e) {
      // Handle error
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    return await _apiService.getMovieDetails(movieId);
  }

  Future<List<Review>> fetchMovieReviews(int movieId, {int page = 1}) async {
    return await _apiService.getMovieReviews(movieId, page: page);
  }
}
