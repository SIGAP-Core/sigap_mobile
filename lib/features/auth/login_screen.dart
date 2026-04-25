import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/auth/data/auth_repository.dart';
import 'package:sigap_mobile/features/auth/models/driver_model.dart';
import 'package:sigap_mobile/features/auth/provider/auth_screen_provider.dart';
import 'package:sigap_mobile/features/auth/provider/driver_provider.dart';
import 'package:sigap_mobile/shared/widget/custom_error_banner.dart';
import 'package:sigap_mobile/shared/widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;

  Future<void> _handleLogin() async {
    // Reset error
    setState(() {
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // VALIDASI LOKAL (Kosong & Format)
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Email dan password wajib diisi.");
      return;
    }

    // Validasi format email menggunakan Regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = "Format email tidak valid.");
      return;
    }

    // LOGIN KE FIREBASE
    final authScreenProvider = context.read<AuthScreenProvider>();
    final authRepository = AuthRepository();

    authScreenProvider.setLoadingState(true);

    try {
      DriverModel driverData = await authRepository.login(email, password);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Berhasil masuk. Selamat datang, ${driverData.name}!",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      context.read<DriverProvider>().setDriver(driverData);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll("Exception: ", "");
        });
      }
    } finally {
      if (mounted) {
        authScreenProvider.setLoadingState(false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ubah status bar menjadi terang
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Premium Dark Slate
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              // Brand Header
              const TopBrandHeader(),

              // Login Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                      bottom: 90,
                      top: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // TEKS PETUNJUK LOGIN (Untuk User)
                        const LoginInstructionText(),
                        const SizedBox(height: 24),

                        // BANNER ERROR
                        if (_errorMessage != null)
                          CustomErrorBanner(errorMessage: _errorMessage!),

                        // INPUT SECTION (Email & Password)
                        // Email Field
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Email Driver",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        CustomTextField(
                          controller: _passwordController,
                          hintText: "Password",
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 32),

                        // LOGIN BUTTON
                        LoginButton(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBrandHeader extends StatelessWidget {
  const TopBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.only(top: 32, bottom: 24, left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIGAP',
                  style: TextStyle(
                    fontSize: 24,
                    // fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sistem Informasi Gerbang & Akses Pintar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    // fontWeight: FontWeight.w600,
                    height: 1.4,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Icon(Icons.shield, size: 20, color: Color(0xFF3B82F6)),
          ),
        ],
      ),
    );
  }
}

class LoginInstructionText extends StatelessWidget {
  const LoginInstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selamat Datang,",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Silakan masuk menggunakan kredensial email dan password driver Anda.",
          style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.5),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController, passwordController;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthScreenProvider>().isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          disabledBackgroundColor: const Color(
            0xFF3B82F6,
          ).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isLoading ? 0 : 8,
          shadowColor: const Color(0xFF3B82F6).withValues(alpha: 0.5),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'MASUK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }
}
