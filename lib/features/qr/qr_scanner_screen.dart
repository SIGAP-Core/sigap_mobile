import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/qr/data/gate_repository.dart';
import 'package:sigap_mobile/features/qr/provider/qr_screen_provider.dart';
import 'package:sigap_mobile/shared/strings.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _mobileScannerController =
      MobileScannerController();

  @override
  void dispose() {
    _mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Responsif: 70% dari lebar layar
    final scanAreaSize = screenSize.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black, // Dasar hitam untuk kamera
      body: Stack(
        children: [
          // CAMERA FEED
          MobileFeedCameraScanner(cameraController: _mobileScannerController),

          // SCANNER OVERLAY (Efek Gelap + Kotak Terang)
          ScannerOverlayStyle(scanAreaSize: scanAreaSize),

          // GLOWING FRAME
          ScannerFrameStyle(scanAreaSize: scanAreaSize),

          // INSTRUCTION TEXT
          HintInstructionText(scanAreaSize: scanAreaSize),

          // CUSTOM TOP BAR (Back Button)
          const CustomBackButton(),

          // LOADING OVERLAY (Glassmorphism Effect)
          const ScannerLoadingOverlayStyle(),
        ],
      ),
    );
  }
}

class MobileFeedCameraScanner extends StatelessWidget {
  final MobileScannerController cameraController;

  const MobileFeedCameraScanner({super.key, required this.cameraController});

  void _showResultDialog(
    BuildContext context,
    String title,
    String message,
    Color color,
    IconData icon,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        // Premium Dark Slate
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: color.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              context.pop(); // Kembali ke dashboard
              cameraController.start();
            },
            child: Text(
              "TUTUP",
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

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
          "Akses Diberikan",
          response.data['message'],
          Colors.greenAccent,
          Icons.check_circle_outline,
        );
      }
    } on DioException catch (e) {
      String msg = e.response?.data['message'] ?? "Gagal terhubung ke server.";
      if (context.mounted) {
        _showResultDialog(
          context,
          "Akses Ditolak",
          msg,
          Colors.redAccent,
          Icons.cancel_outlined,
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showResultDialog(
          context,
          "Terjadi Kesalahan",
          e.toString(),
          Colors.orangeAccent,
          Icons.error_outline,
        );
      }
    } finally {
      if (context.mounted) {
        screenStateProvider.setLoadingState(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = context.watch<QrScreenProvider>().isLoading;

    return MobileScanner(
      controller: cameraController,
      onDetect: (capture) {
        if (isProcessing) return;

        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          final String? rawValue = barcode.rawValue;

          if (rawValue != null && rawValue.startsWith(deepLinkFormat)) {
            cameraController.stop();

            final String payload = rawValue.replaceAll(deepLinkFormat, "");

            _handleGateVerify(context, payload);
            break;
          }
        }
      },
    );
  }
}

class ScannerOverlayStyle extends StatelessWidget {
  final double scanAreaSize;

  const ScannerOverlayStyle({super.key, required this.scanAreaSize});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withValues(alpha: 0.4),
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  color: Colors.black, // Membolongi filter warna
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerFrameStyle extends StatelessWidget {
  final double scanAreaSize;

  const ScannerFrameStyle({super.key, required this.scanAreaSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: scanAreaSize,
        height: scanAreaSize,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF3B82F6), width: 3),
          // Blue accent
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class HintInstructionText extends StatelessWidget {
  final double scanAreaSize;

  const HintInstructionText({super.key, required this.scanAreaSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: scanAreaSize + 56),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.qr_code, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                "Arahkan QR Code ke dalam bingkai",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isProcessing = context.watch<QrScreenProvider>().isLoading;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Tombol Back Elegan
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if (!isProcessing) context.pop();
                      },
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  "Scan Akses",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                ),
              ),
              const SizedBox(width: 48),
              // Spacer untuk keseimbangan title
            ],
          ),
        ),
      ),
    );
  }
}

class ScannerLoadingOverlayStyle extends StatelessWidget {
  const ScannerLoadingOverlayStyle({super.key});

  @override
  Widget build(BuildContext context) {
    final isProcessing = context.watch<QrScreenProvider>().isLoading;

    if (!isProcessing) return const SizedBox.shrink();

    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: const Color(0xFF0F172A).withValues(alpha: 0.6),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF3B82F6),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Memverifikasi Akses...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
