import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/di/dependency_injection.dart';
import 'package:learning_flutter_app/modules/checkout/view_model/checkout_view_model.dart';

final checkoutViewModelProvider = ChangeNotifierProvider<CheckoutViewModel>((ref) {
  return getIt<CheckoutViewModel>();
});
