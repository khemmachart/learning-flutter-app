import 'package:flutter/material.dart';
import 'package:learning_flutter_app/modules/checkout/state/checkout_state.dart';

class CheckoutButton extends StatelessWidget {
  final CheckoutState checkoutState;
  final bool isEnabled;
  final VoidCallback onPressed;

  const CheckoutButton({
    Key? key,
    required this.checkoutState,
    required this.isEnabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: checkoutState.isLoading || !isEnabled ? null : onPressed,
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