import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/providers/checkout_provider.dart';
import 'package:learning_flutter_app/modules/payment/payment_success/page/payment_success_page.dart';
import 'package:learning_flutter_app/modules/checkout/widgets/date_picker.dart';
import 'package:learning_flutter_app/modules/checkout/widgets/time_picker.dart';
import 'package:learning_flutter_app/modules/checkout/widgets/seat_selector.dart';
import 'package:learning_flutter_app/modules/checkout/widgets/checkout_button.dart';

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
                DatePicker(
                  selectedDate: selectedDate,
                  onDateSelected: (date) => setState(() => selectedDate = date),
                ),
                const SizedBox(height: 24),
                TimePicker(
                  availableTimes: availableTimes,
                  selectedTime: selectedTime,
                  onTimeSelected: (time) => setState(() => selectedTime = time),
                ),
                const SizedBox(height: 24),
                SeatSelector(
                  selectedSeats: selectedSeats,
                  onSeatsChanged: (seats) => setState(() => selectedSeats = seats),
                ),
                const SizedBox(height: 32),
                CheckoutButton(
                  checkoutState: checkoutState.state,
                  isEnabled: selectedDate != null && selectedTime != null,
                  onPressed: () => _processCheckout(),
                ),
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

  void _processCheckout() async {
    await ref.read(checkoutViewModelProvider.notifier).processCheckout(
          widget.movie,
          selectedDate!,
          selectedTime!,
          selectedSeats,
        );
    
    if (mounted) {
      final checkoutState = ref.read(checkoutViewModelProvider);
      if (checkoutState.state.isSuccess) {
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
  }
}
