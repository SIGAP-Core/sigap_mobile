import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/auth/data/auth_repository.dart';
import 'package:sigap_mobile/features/qr/data/gate_repository.dart';
import 'package:sigap_mobile/features/qr/provider/qr_screen_provider.dart';
import 'package:sigap_mobile/shared/strings.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  Future<void> _handleGateVerify(BuildContext context, String payload) async {
    final screenStateProvider = context.read<QrScreenProvider>();
    final repo = GateRepository();

    screenStateProvider.setLoadingState(true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final idToken = await user.getIdToken();
      final response = await repo.verifyGate(payload, idToken!);

      if (response.statusCode == 200 && context.mounted) {
        _showResultDialog(
          context,
          "Berhasil",
          response.data['message'],
          Colors.green,
        );
      }
    } on DioException catch (e) {
      String msg = e.response?.data['message'] ?? "Gagal terhubung";
      if (context.mounted) {
        _showResultDialog(context, "Ditolak", msg, Colors.red);
      }
    } catch (e) {
      if (context.mounted) {
        _showResultDialog(context, "Error", e.toString(), Colors.red);
      }
    } finally {
      // 3. Matikan Loading
      screenStateProvider.setLoadingState(false);
    }
  }

  void _showResultDialog(
    BuildContext context,
    String title,
    String message,
    Color color,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cameraController.start();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget actionLogout() {
    Future<void> handleLogout() async {
      final authRepository = AuthRepository();
      await authRepository.logout();
    }

    return IconButton(
      onPressed: () => handleLogout(),
      icon: Icon(Icons.logout, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = context.watch<QrScreenProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR Sigap',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [actionLogout()],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? rawValue = barcode.rawValue;

                if (rawValue != null && rawValue.startsWith(deepLinkFormat)) {
                  cameraController.stop();

                  final String payload = rawValue.replaceAll(
                    deepLinkFormat,
                    "",
                  );

                  _handleGateVerify(context, payload);
                  break;
                }
              }
            },
          ),

          if (isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
