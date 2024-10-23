import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/main_develop.dart';
import 'package:learning_flutter_app/modules/movie_list/movie_list_view_model.dart';

final movieListViewModelProvider = StateNotifierProvider<MovieListViewModel, AsyncValue<List<Movie>>>((ref) {
  final apiService = ref.watch(movieApiServiceProvider);
  return MovieListViewModel(apiService);
});