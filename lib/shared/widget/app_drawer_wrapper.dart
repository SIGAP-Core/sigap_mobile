import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/app/provider/drawer_provider.dart';
import 'app_sidebar.dart';

class AppDrawerWrapper extends StatelessWidget {
  final Widget child;

  const AppDrawerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isOpen = context.select<DrawerProvider, bool>((p) => p.isOpen);

    // Nilai geser ke kiri (Minus) sebesar lebar sidebar
    const double maxSlide = 280.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: Stack(
        children: [
          // Sidebar
          const Align(alignment: Alignment.centerLeft, child: AppSidebar()),

          // Dashboard Screen
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: isOpen ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            builder: (context, value, _) {
              return Transform.translate(
                // Menggeser sumbu X ke kiri (0 hingga -280)
                offset: Offset(maxSlide * value, 0),
                child: Stack(
                  children: [
                    // Main Screen
                    child,

                    if (value > 0)
                      IgnorePointer(
                        ignoring: !isOpen,
                        child: GestureDetector(
                          onTap: () =>
                              context.read<DrawerProvider>().closeDrawer(),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.6 * value),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
