import 'package:flutter/material.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/modules/payment/payment_success/widgets/payment_info_card.dart';

class PaymentSuccessPage extends StatelessWidget {
  final Movie movie;
  final DateTime date;
  final String time;
  final int seats;

  const PaymentSuccessPage({
    Key? key,
    required this.movie,
    required this.date,
    required this.time,
    required this.seats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 100,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Payment Successful!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                      ),
                      const SizedBox(height: 40),
                      PaymentInfoCard(
                        movie: movie,
                        date: date,
                        time: time,
                        seats: seats,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Thank you for your purchase!',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
