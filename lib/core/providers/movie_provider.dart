import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/di/dependency_injection.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/view_model/movie_list_view_model.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/view_model/movie_detail_view_model.dart';

final movieListViewModelProvider = ChangeNotifierProvider<MovieListViewModel>((ref) {
  return getIt<MovieListViewModel>();
});

final movieDetailViewModelProvider = ChangeNotifierProvider.family<MovieDetailViewModel, int>((ref, movieId) {
  return getIt<MovieDetailViewModel>(param1: movieId);
});
