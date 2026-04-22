import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/auth/data/auth_repository.dart';
import 'package:sigap_mobile/features/auth/login_screen.dart';
import 'package:sigap_mobile/features/auth/provider/auth_screen_provider.dart';
import 'package:sigap_mobile/features/dashboard/dashboard_screen.dart';
import 'package:sigap_mobile/features/dashboard/provider/dashboard_sheet_provider.dart';
import 'package:sigap_mobile/features/qr/provider/qr_screen_provider.dart';
import 'package:sigap_mobile/features/qr/qr_scanner_screen.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }
}

GoRouter routes = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    final authRepository = AuthRepository();
    final user = authRepository.currentUser;
    final isLoggingIn = state.matchedLocation == '/login';

    if (user == null) {
      return isLoggingIn ? null : "/login";
    }

    if (isLoggingIn) {
      return "/";
    }

    return null;
  },
  refreshListenable: RouterNotifier(),
  routes: [
    GoRoute(
      name: "login_screen",
      path: "/login",
      builder: (_, _) => ChangeNotifierProvider(
        create: (_) => AuthScreenProvider(),
        builder: (_, _) => LoginScreen(),
      ),
    ),
    GoRoute(
      name: "dashboard",
      path: "/",
      builder: (_, _) => ChangeNotifierProvider(
        create: (_) => DashboardSheetProvider(),
        builder: (_, _) => DashboardScreen(),
      ),
      routes: [
        GoRoute(
          name: "qr_scan_screen",
          path: "scan",
          builder: (_, _) => ChangeNotifierProvider(
            create: (_) => QrScreenProvider(),
            builder: (_, _) => QrScannerScreen(),
          ),
        ),
      ],
    ),
  ],
);
