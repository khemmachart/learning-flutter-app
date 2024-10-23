import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final List<String> availableTimes;
  final String? selectedTime;
  final Function(String?) onTimeSelected;

  const TimePicker({
    Key? key,
    required this.availableTimes,
    required this.selectedTime,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableTimes.map((time) {
            return ChoiceChip(
              label: Text(time),
              selected: selectedTime == time,
              onSelected: (selected) {
                onTimeSelected(selected ? time : null);
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Colors.grey[300],
              labelStyle: TextStyle(
                color: selectedTime == time ? Colors.black : Colors.grey[600],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}