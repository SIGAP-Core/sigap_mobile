import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/app/app.dart';
import 'package:sigap_mobile/app/routes.dart';
import 'package:sigap_mobile/features/auth/provider/driver_provider.dart';
import 'package:sigap_mobile/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProxyProvider<DriverProvider, RouterNotifier>(
          create: (context) => RouterNotifier(context.read<DriverProvider>()),
          update: (_, driverProvider, notifier) =>
              notifier ?? RouterNotifier(driverProvider),
        ),
      ],
      child: const SigapMobile(),
    ),
  );
}
