import 'package:flutter/material.dart';

class DashboardSheetProvider with ChangeNotifier {
  double _sheetExtent = 0.48; // init
  static const double minSheetSize = 0.48;
  static const double maxSheetSize = 0.96;
  int _selectedTabIndex = 0;

  void setSheetExtent (double value) {
    _sheetExtent = value;
    notifyListeners();
  }

  void setSelectedTabIndex(int value) {
    _selectedTabIndex = value;
    notifyListeners();
  }


  // FAB muncul kalau sheet ditarik lebih dari 55%
  bool get showFab => _sheetExtent > 0.55;

  int get selectedTabIndex => _selectedTabIndex;
}