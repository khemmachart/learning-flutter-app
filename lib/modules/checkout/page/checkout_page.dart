import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/providers/checkout_provider.dart';
import 'package:learning_flutter_app/modules/checkout/state/checkout_state.dart';
import 'package:learning_flutter_app/modules/payment/payment_success/page/payment_success_page.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final Movie movie;

  const CheckoutPage({Key? key, required this.movie}) : super(key: key);

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  DateTime? selectedDate;
  String? selectedTime;
  int selectedSeats = 1;

  final List<String> availableTimes = ['10:00 AM', '1:00 PM', '4:00 PM', '7:00 PM', '10:00 PM'];

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout for ${widget.movie.title}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePicker(),
                const SizedBox(height: 24),
                _buildTimePicker(),
                const SizedBox(height: 24),
                _buildSeatSelector(),
                const SizedBox(height: 32),
                _buildCheckoutButton(checkoutState),
                if (checkoutState.isLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.grey)),
                if (checkoutState.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      checkoutState.errorMessage!,
                      style: TextStyle(color: Colors.red.shade300, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.grey[800]!,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            title: Text(
              selectedDate != null
                  ? DateFormat('MMMM d, yyyy').format(selectedDate!)
                  : 'Choose Date',
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(Icons.calendar_today, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
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
                setState(() {
                  selectedTime = selected ? time : null;
                });
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

  Widget _buildSeatSelector() {
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
                    setState(() {
                      selectedSeats--;
                    });
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
                  setState(() {
                    selectedSeats++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(CheckoutState state) {
    return ElevatedButton(
      onPressed: state.isLoading || selectedDate == null || selectedTime == null
          ? null
          : () async {
              await ref.read(checkoutViewModelProvider.notifier).processCheckout(
                    widget.movie,
                    selectedDate!,
                    selectedTime!,
                    selectedSeats,
                  );
              
              if (mounted) {
                final checkoutState = ref.read(checkoutViewModelProvider);
                if (checkoutState.isSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessPage(
                        movie: widget.movie,
                        date: selectedDate!,
                        time: selectedTime!,
                        seats: selectedSeats,
                      ),
                    ),
                  );
                }
              }
            },
      child: Text(
        'Confirm Checkout',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
}
