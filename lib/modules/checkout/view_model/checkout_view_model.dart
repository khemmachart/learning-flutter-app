import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/services/checkout_service.dart';
import 'package:learning_flutter_app/modules/checkout/state/checkout_state.dart';

class CheckoutViewModel extends StateNotifier<CheckoutState> {
  final CheckoutService _service;

  CheckoutViewModel(this._service) : super(CheckoutState());

  Future<void> processCheckout(Movie movie, DateTime date, String time, int seats) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await _service.processCheckout(movie, date, time, seats);
      state = state.copyWith(isLoading: false, isSuccess: success);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}