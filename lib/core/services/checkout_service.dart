import 'package:learning_flutter_app/core/models/movie.dart';

class CheckoutService {
  Future<bool> processCheckout(Movie movie, DateTime date, String time, int seats) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Simulate successful checkout (you can add logic to sometimes return false for testing)
    return true;
  }
}
