import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/app/routes.dart';
import 'package:sigap_mobile/features/auth/provider/driver_provider.dart';

class SigapMobile extends StatefulWidget {
  const SigapMobile({super.key});

  @override
  State<SigapMobile> createState() => _SigapMobileState();
}

class _SigapMobileState extends State<SigapMobile> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final routerNotifier = context.read<RouterNotifier>();
    final driverProvider = context.read<DriverProvider>();

    _router = createRouter(
      routerNotifier: routerNotifier,
      driverProvider: driverProvider,
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        canvasColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF3B82F6),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6), // Accent Blue
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF1E293B), // Lighter Slate (card/dialog)
          onSurface: Colors.white,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Menyesuaikan kursor dan teks seleksi agar senada
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: const Color(0xFF3B82F6),
          selectionColor: const Color(0xFF3B82F6).withValues(alpha: 0.5),
          selectionHandleColor: const Color(0xFF3B82F6),
        ),
      ),
      routerConfig: _router,
    );
  }
}
