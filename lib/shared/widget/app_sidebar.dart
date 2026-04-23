import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/auth/data/auth_repository.dart';
import 'package:sigap_mobile/app/provider/drawer_provider.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  Future<void> _handleLogout() async {
    final authRepository = AuthRepository();
    await authRepository.logout();
  }

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;

    return Container(
      width: 280,
      height: double.infinity,
      color: const Color(0xFF0B1120),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Info
            const CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFF1E293B),
              child: Icon(Icons.person, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "Budi Santoso",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "driver@sigap.com",
              style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 48),

            // Menu Items
            _buildMenuItem(
              context,
              icon: Icons.home_rounded,
              title: "Dashboard",
              namedPath: "dashboard",
              path: "/",
              currentPath: currentPath,
            ),
            _buildMenuItem(
              context,
              icon: Icons.person,
              title: "Profile Saya",
              namedPath: "profile_screen",
              path: "/profile",
              currentPath: currentPath,
            ),

            const Spacer(),

            // Logout Button
            InkWell(
              onTap: _handleLogout,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.redAccent),
                    SizedBox(width: 12),
                    Text(
                      "Keluar",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String namedPath,
    required String path,
    required String currentPath,
  }) {
    final bool isSelected = path == currentPath;

    return InkWell(
      onTap: !isSelected
          ? () {
              context.goNamed(namedPath);
              context.read<DrawerProvider>().closeDrawer();
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
