import 'package:flutter/material.dart';

class SeatSelector extends StatelessWidget {
  final int selectedSeats;
  final Function(int) onSeatsChanged;

  const SeatSelector({
    Key? key,
    required this.selectedSeats,
    required this.onSeatsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Seats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.grey[600]),
                onPressed: () {
                  if (selectedSeats > 1) {
                    onSeatsChanged(selectedSeats - 1);
                  }
                },
              ),
              Text(
                '$selectedSeats',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.grey[600]),
                onPressed: () {
                  onSeatsChanged(selectedSeats + 1);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}