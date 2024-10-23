import 'package:learning_flutter_app/core/base/base_view_model.dart';
import 'package:learning_flutter_app/core/services/movie_service.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/state/movie_detail_state.dart';

class MovieDetailViewModel extends BaseViewModel<MovieDetailState> {
  final MovieService _movieService;
  final int movieId;

  MovieDetailViewModel(this._movieService, this.movieId) : super(const MovieDetailState()) {
    setState(const MovieDetailState());
    fetchMovieDetails();
    loadReviews();
  }

  Future<void> fetchMovieDetails() async {
    await runSafe(() async {
      final movie = await _movieService.getMovieDetails(movieId);
      setState(state.copyWith(movie: movie));
    });
  }

  Future<void> loadReviews() async {
    if (!state.hasMoreReviews || state.isLoadingReviews) return;
    setState(state.copyWith(isLoadingReviews: true));

    try {
      final newReviews = await _movieService.getMovieReviews(
        movieId,
        page: state.currentReviewPage,
      );
      
      // Filter out any null reviews
      final validReviews = newReviews.where((review) => review != null).toList();
      
      setState(state.copyWith(
        reviews: [...state.reviews, ...validReviews],
        currentReviewPage: state.currentReviewPage + 1,
        hasMoreReviews: validReviews.isNotEmpty,
        isLoadingReviews: false,
      ));
    } catch (e) {
      setErrorMessage('Error fetching movie reviews: $e');
      setState(state.copyWith(isLoadingReviews: false, hasMoreReviews: false));
    }
  }
}
