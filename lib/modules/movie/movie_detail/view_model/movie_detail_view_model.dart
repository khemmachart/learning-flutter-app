import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/services/movie_service.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/state/movie_detail_state.dart';

class MovieDetailViewModel extends StateNotifier<MovieDetailState> {
  final MovieService _movieService;
  final int movieId;

  MovieDetailViewModel(this._movieService, this.movieId)
      : super(const MovieDetailState()) {
    fetchMovieDetails();
    loadReviews();
  }

  Future<void> fetchMovieDetails() async {
    state = state.copyWith(isLoading: true);
    try {
      final movie = await _movieService.getMovieDetails(movieId);
      state = state.copyWith(movie: movie, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error
    }
  }

  Future<void> loadReviews() async {
    if (!state.hasMoreReviews || state.isLoadingReviews) return;
    state = state.copyWith(isLoadingReviews: true);
    try {
      final newReviews = await _movieService.getMovieReviews(
        movieId,
        page: state.currentReviewPage,
      );
      
      // Filter out any null reviews
      final validReviews = newReviews.where((review) => review != null).toList();
      
      state = state.copyWith(
        reviews: [...state.reviews, ...validReviews],
        currentReviewPage: state.currentReviewPage + 1,
        hasMoreReviews: validReviews.isNotEmpty,
        isLoadingReviews: false,
      );
    } catch (e) {
      print('Error fetching movie reviews: $e');
      state = state.copyWith(isLoadingReviews: false, hasMoreReviews: false);
    }
  }
}
