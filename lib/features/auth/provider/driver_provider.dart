import 'package:flutter/material.dart';
import 'package:sigap_mobile/features/auth/models/driver_model.dart';
class DriverProvider with ChangeNotifier {
  DriverModel? _currentDriver;

  DriverModel? get driver => _currentDriver;

  void setDriver(DriverModel driver) {
    _currentDriver = driver;
    notifyListeners();
  }

  void clearDriver() {
    _currentDriver = null;
    notifyListeners();
  }
}