import 'package:flutter/cupertino.dart';

class AuthScreenProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
