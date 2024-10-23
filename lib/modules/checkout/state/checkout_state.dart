class CheckoutState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  CheckoutState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  CheckoutState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}