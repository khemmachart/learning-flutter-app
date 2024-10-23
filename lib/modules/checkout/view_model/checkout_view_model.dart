import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/services/checkout_service.dart';
import 'package:learning_flutter_app/modules/checkout/state/checkout_state.dart';
import 'package:learning_flutter_app/core/base/base_view_model.dart';

class CheckoutViewModel extends BaseViewModel<CheckoutState> {
  final CheckoutService _service;

  CheckoutViewModel(this._service) : super(CheckoutState());

  Future<void> processCheckout(Movie movie, DateTime date, String time, int seats) async {
    await runSafe(() async {
      final success = await _service.processCheckout(movie, date, time, seats);
      setState(state.copyWith(isSuccess: success));
    });
  }
}