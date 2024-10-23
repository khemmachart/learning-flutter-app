import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/review.dart';

part 'movie_detail_state.freezed.dart';

@freezed
class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState({
    Movie? movie,
    @Default([]) List<Review> reviews,
    @Default(1) int currentReviewPage,
    @Default(true) bool hasMoreReviews,
    @Default(false) bool isLoadingReviews,
    @Default(false) bool isLoading,
  }) = _MovieDetailState;
}

