import 'package:flutter/material.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:intl/intl.dart';

class PaymentInfoCard extends StatelessWidget {
  final Movie movie;
  final DateTime date;
  final String time;
  final int seats;

  const PaymentInfoCard({
    Key? key,
    required this.movie,
    required this.date,
    required this.time,
    required this.seats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
