import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/auth/data/auth_repository.dart';
import 'package:sigap_mobile/features/auth/login_screen.dart';
import 'package:sigap_mobile/features/auth/provider/auth_screen_provider.dart';
import 'package:sigap_mobile/features/auth/provider/driver_provider.dart';
import 'package:sigap_mobile/features/dashboard/bloc/access_logs_bloc.dart';
import 'package:sigap_mobile/features/profile/profile_screen.dart';
import 'package:sigap_mobile/shared/widget/app_drawer_wrapper.dart';
import 'package:sigap_mobile/features/dashboard/dashboard_screen.dart';
import 'package:sigap_mobile/features/dashboard/provider/dashboard_sheet_provider.dart';
import 'package:sigap_mobile/app/provider/drawer_provider.dart';
import 'package:sigap_mobile/features/qr/provider/qr_screen_provider.dart';
import 'package:sigap_mobile/features/qr/qr_scanner_screen.dart';
import 'package:sigap_mobile/shared/widget/custom_transition.dart';

class RouterNotifier extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final DriverProvider _driverProvider;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  RouterNotifier(this._driverProvider) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        final driverData = await _authRepo.getDriverData(user.email!);
        if (driverData != null) {
          _driverProvider.setDriver(driverData);
        }
      }
      _isInitialized = true;
      notifyListeners();
    });
  }
}

GoRouter createRouter({
  required RouterNotifier routerNotifier,
  required DriverProvider driverProvider,
}) {
  return GoRouter(
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
    refreshListenable: routerNotifier,
    routes: [
      GoRoute(
        name: "login_screen",
        path: "/login",
        pageBuilder: (_, state) => CustomTransition.none(
          state: state,
          child: ChangeNotifierProvider(
            create: (_) => AuthScreenProvider(),
            builder: (_, _) => LoginScreen(),
          ),
        ),
      ),
      ShellRoute(
        builder: (_, _, child) {
          return ChangeNotifierProvider(
            create: (_) => DrawerProvider(),
            child: AppDrawerWrapper(child: child),
          );
        },
        routes: [
          GoRoute(
            name: "dashboard",
            path: "/",
            pageBuilder: (_, state) => CustomTransition.none(
              state: state,
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => DashboardSheetProvider()),
                  BlocProvider(create: (_) => AccessLogsBloc()),
                ],
                child: const DashboardScreen(),
              ),
            ),
            routes: [
              GoRoute(
                name: "qr_scan_screen",
                path: "scan",
                pageBuilder: (context, state) => CustomTransition.slideFade(
                  context: context,
                  state: state,
                  child: ChangeNotifierProvider(
                    create: (_) => QrScreenProvider(),
                    builder: (_, _) => QrScannerScreen(),
                  ),
                ),
              ),
            ],
          ),

          GoRoute(
            name: "profile_screen",
            path: "/profile",
            pageBuilder: (_, state) =>
                CustomTransition.none(state: state, child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}
