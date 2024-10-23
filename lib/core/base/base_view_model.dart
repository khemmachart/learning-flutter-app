import 'package:flutter/foundation.dart';

abstract class BaseViewModel<T> extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  late T _state;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  T get state => _state;

  BaseViewModel(T initialState) {
    _state = initialState;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setState(T newState) {
    _state = newState;
    notifyListeners();
  }

  @protected
  Future<void> runSafe(Future<void> Function() action) async {
    try {
      setLoading(true);
      await action();
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
