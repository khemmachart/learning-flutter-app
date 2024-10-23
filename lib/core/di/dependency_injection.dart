import 'package:get_it/get_it.dart';
import 'package:learning_flutter_app/core/services/movie_service.dart';
import 'package:learning_flutter_app/core/services/checkout_service.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/view_model/movie_list_view_model.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/view_model/movie_detail_view_model.dart';
import 'package:learning_flutter_app/modules/checkout/view_model/checkout_view_model.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton(() => MovieService());
  getIt.registerLazySingleton(() => CheckoutService());

  // ViewModels
  getIt.registerFactory(() => MovieListViewModel(getIt<MovieService>()));
  getIt.registerFactoryParam<MovieDetailViewModel, int, void>(
    (movieId, _) => MovieDetailViewModel(getIt<MovieService>(), movieId),
  );
  getIt.registerFactory(() => CheckoutViewModel(getIt<CheckoutService>()));
}
