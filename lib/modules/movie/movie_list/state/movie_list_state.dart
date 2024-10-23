import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_flutter_app/core/models/movie.dart';

part 'movie_list_state.freezed.dart';

@freezed
class MovieListState with _$MovieListState {
  const factory MovieListState({
    @Default([]) List<Movie> popularMovies,
    @Default([]) List<Movie> nowPlayingMovies,
    @Default([]) List<Movie> topRatedMovies,
    @Default(1) int popularCurrentPage,
    @Default(1) int nowPlayingCurrentPage,
    @Default(false) bool isLoading,
    @Default(MovieDisplayMode.popular) MovieDisplayMode currentMode,
  }) = _MovieState;

  const MovieListState._();
}

enum MovieDisplayMode { popular, nowShowing }
