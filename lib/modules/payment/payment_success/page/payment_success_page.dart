import 'package:flutter/material.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:intl/intl.dart';

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
                      _buildInfoCard(),
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

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Movie', movie.title),
            const SizedBox(height: 16),
            _buildInfoRow('Date', DateFormat('MMMM d, yyyy').format(date)),
            const SizedBox(height: 16),
            _buildInfoRow('Time', time),
            const SizedBox(height: 16),
            _buildInfoRow('Seats', '$seats'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
