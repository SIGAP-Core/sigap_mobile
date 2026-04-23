import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void toggleDrawer() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  void closeDrawer() {
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }
}
