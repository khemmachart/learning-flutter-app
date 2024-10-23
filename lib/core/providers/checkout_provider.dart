import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/services/checkout_service.dart';
import 'package:learning_flutter_app/modules/checkout/state/checkout_state.dart';
import 'package:learning_flutter_app/modules/checkout/view_model/checkout_view_model.dart';

final checkoutServiceProvider = Provider<CheckoutService>((ref) => CheckoutService());

final checkoutViewModelProvider = StateNotifierProvider<CheckoutViewModel, CheckoutState>((ref) {
  final service = ref.watch(checkoutServiceProvider);
  return CheckoutViewModel(service);
});