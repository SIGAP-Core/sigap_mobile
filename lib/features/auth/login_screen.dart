import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/auth/data/auth_repository.dart';
import 'package:sigap_mobile/features/auth/models/driver_model.dart';
import 'package:sigap_mobile/features/auth/provider/auth_screen_provider.dart';
import 'package:sigap_mobile/features/auth/provider/driver_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER SECTION (Logo & Teks)
                const HeaderSectionLogo(),

                // INPUT SECTION (Email & Password)
                // Email Field
                EmailTextField(emailController: _emailController),
                const SizedBox(height: 20),

                // Password Field
                PasswordTextField(passwordController: _passwordController),
                const SizedBox(height: 40),

                // LOGIN BUTTON
                LoginButton(
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSectionLogo extends StatelessWidget {
  const HeaderSectionLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.shield,
              size: 72,
              color: Color(0xFF3B82F6), // Blue Accent
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'SIGAP',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Silakan masuk dengan kredensial\ndriver Anda.',
          style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailTextField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email Driver',
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF94A3B8)),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;

  const PasswordTextField({super.key, required this.passwordController});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passwordController,
      style: const TextStyle(color: Colors.white),
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8)),
        suffixIcon: IconButton(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFF94A3B8),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController, passwordController;

  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  Future<void> _handleLogin(BuildContext context) async {
    final authScreenProvider = context.read<AuthScreenProvider>();
    final authRepository = AuthRepository();

    authScreenProvider.setLoadingState(true);

    try {
      // Mencoba login ke Firebase
      if (emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        throw Exception("Email atau password tidak boleh kosong.");
      }

      DriverModel driverData = await authRepository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!context.mounted) return;
      context.read<DriverProvider>().setDriver(driverData);
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Gagal melakukan login!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF950606),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      String errorMessage = e.toString().replaceAll("Exception: ", "");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF950606),
        ),
      );
    } finally {
      authScreenProvider.setLoadingState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthScreenProvider>().isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleLogin(context),
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
