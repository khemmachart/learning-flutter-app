import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/services/movie_service.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/state/movie_list_state.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/view_model/movie_list_view_model.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/state/movie_detail_state.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/view_model/movie_detail_view_model.dart';

final movieServiceProvider = Provider<MovieService>((ref) => MovieService());

final movieListViewModelProvider = StateNotifierProvider<MovieListViewModel, MovieListState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieListViewModel(movieService);
});

final movieDetailViewModelProvider = StateNotifierProvider.family<MovieDetailViewModel, MovieDetailState, int>((ref, movieId) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieDetailViewModel(movieService, movieId);
});
