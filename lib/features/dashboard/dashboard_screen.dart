import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigap_mobile/features/auth/data/auth_repository.dart';
import 'package:sigap_mobile/features/dashboard/provider/dashboard_sheet_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Ubah warna status bar agar cocok dengan dark mode
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A), // Deep Slate/Navy background
        body: Stack(
          children: [
            // BASE LAYER (HEADER & MAIN BUTTON)
            const BaseLayer(),

            // DRAGGABLE BOTTOM SHEET (HISTORY)
            const DraggableBottomSheet(),

            // DYNAMIC FLOATING ACTION BUTTON (SCAN QR)
            const DynamicFloatingActionButton(),
          ],
        ),
      ),
    );
  }
}

class BaseLayer extends StatelessWidget {
  const BaseLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Dashboard Header
            const DashboardHeader(),
            const SizedBox(height: 32),

            // Digital Card / Profil Kendaraan
            const DigitalCardDriverLicense(),
            const SizedBox(height: 32),

            // Main Scan Button
            const ScanQrButton(),
          ],
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  Future<void> _handleLogout() async {
    final authRepository = AuthRepository();
    await authRepository.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo, Selamat Datang!",
                style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                "Budi Santoso",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Logout
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _handleLogout,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DigitalCardDriverLicense extends StatelessWidget {
  const DigitalCardDriverLicense({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.directions_car, color: Colors.white70, size: 28),
          const SizedBox(height: 16),
          const Text(
            "Plat Nomor Kendaraan",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            "N 1234 ABC",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Driver Terverifikasi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanQrButton extends StatelessWidget {
  const ScanQrButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("Navigasi ke Scanner Screen dari Tombol Utama");
        context.goNamed("qr_scan_screen");
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              color: Color(0xFF0F172A),
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              "Scan QR Gerbang",
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggableBottomSheet extends StatefulWidget {
  const DraggableBottomSheet({super.key});

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  // Data dummy firestore
  final List<Map<String, String>> _rawLogs = [
    {
      'tanggal': '2026-04-20T07:50:30.023Z',
      'uid': 'nh6DNNmxjLbAXkMXpZVngsGT4I22',
    },
    {
      'tanggal': '2026-04-18T14:15:00.000Z',
      'uid': 'nh6DNNmxjLbAXkMXpZVngsGT4I22',
    },
    {
      'tanggal': '2026-03-25T08:22:10.000Z',
      'uid': 'nh6DNNmxjLbAXkMXpZVngsGT4I22',
    },
    {
      'tanggal': '2025-12-10T17:45:00.000Z',
      'uid': 'nh6DNNmxjLbAXkMXpZVngsGT4I22',
    },
    {
      'tanggal': '2025-12-05T07:30:00.000Z',
      'uid': 'nh6DNNmxjLbAXkMXpZVngsGT4I22',
    },
    {
      'tanggal': '2024-08-17T09:00:00.000Z',
      'uid': 'nh6DNNmxjLbAXkMXpZVngsGT4I22',
    },
  ];

  // Helper untuk parsing bulan ke Bahasa Indonesia
  final List<String> _namaBulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // List Dinamis untuk menyimpan Tab (Bulan Tahun yang unik)
  List<String> _dynamicTabs = [];

  @override
  void initState() {
    super.initState();
    _generateTabs();
  }

  // Fungsi untuk mengekstrak "Bulan Tahun" unik dari rawLogs
  void _generateTabs() {
    Set<String> uniqueTabs = {};
    for (var log in _rawLogs) {
      DateTime date = DateTime.parse(log['tanggal']!).toLocal();
      String tabName = "${_namaBulan[date.month]} ${date.year}";
      uniqueTabs.add(tabName);
    }
    _dynamicTabs = uniqueTabs.toList();
  }

  // Fungsi memformat tanggal (Contoh: "20 Apr 2026, 14:15 WIB")
  String _formatDateTime(String isoString) {
    DateTime date = DateTime.parse(isoString).toLocal();
    String namaBulanSingkat = _namaBulan[date.month].substring(0, 3);
    String jam = date.hour.toString().padLeft(2, '0');
    String menit = date.minute.toString().padLeft(2, '0');
    return "${date.day} $namaBulanSingkat ${date.year}, $jam:$menit WIB";
  }

  @override
  Widget build(BuildContext context) {
    final int selectedTabIndex = context.select<DashboardSheetProvider, int>(
      (p) => p.selectedTabIndex,
    );

    // Filter log sesuai tab yang dipilih
    List<Map<String, String>> filteredLogs = _rawLogs.where((log) {
      DateTime date = DateTime.parse(log['tanggal']!).toLocal();
      String logTabName = "${_namaBulan[date.month]} ${date.year}";
      return logTabName == _dynamicTabs[selectedTabIndex];
    }).toList();

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        context.read<DashboardSheetProvider>().setSheetExtent(
          notification.extent,
        );
        return true;
      },
      child: DraggableScrollableSheet(
        // Sesuaikan dengan variable static Anda atau hardcode 0.5 jika error
        initialChildSize: DashboardSheetProvider.minSheetSize,
        minChildSize: DashboardSheetProvider.minSheetSize,
        maxChildSize: DashboardSheetProvider.maxSheetSize,
        snap: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // ZONA BISA DI-DRAG (Handle, Title, & Tabs)
                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        // Drag Handle
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF475569),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Riwayat Akses",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // TABS (Gaya Livin' - Underline Style)
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            // Garis bawah abu-abu pembatas tab keseluruhan
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF334155),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: List.generate(_dynamicTabs.length, (
                                index,
                              ) {
                                final isSelected = selectedTabIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<DashboardSheetProvider>()
                                        .setSelectedTabIndex(index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          // Garis biru penanda aktif
                                          color: isSelected
                                              ? const Color(0xFF3B82F6)
                                              : Colors.transparent,
                                          width: 2.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      _dynamicTabs[index],
                                      // Muncul dinamis: "April 2026", dll
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF94A3B8),
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ZONA TIDAK BISA DI-DRAG (ListView Content)
                Expanded(
                  child: filteredLogs.isEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada data akses.",
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          itemCount: filteredLogs.length,
                          itemBuilder: (context, index) {
                            final log = filteredLogs[index];
                            final formattedDate = _formatDateTime(
                              log['tanggal']!,
                            );

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF0F172A,
                                ).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Ikon Checkmark Sederhana Pengganti Masuk/Keluar
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.greenAccent,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Akses Gerbang",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Label Verified / Sukses
                                  const Text(
                                    "Sukses",
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DynamicFloatingActionButton extends StatelessWidget {
  const DynamicFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool showFab = context.select<DashboardSheetProvider, bool>(
      (p) => p.showFab,
    );
    return Positioned(
      bottom: 24,
      right: 24,
      child: AnimatedOpacity(
        opacity: showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: AnimatedScale(
          scale: showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF3B82F6),
            elevation: 8,
            onPressed: showFab
                ? () {
                    debugPrint("Navigasi ke Scanner Screen dari FAB");
                    context.goNamed("qr_scan_screen");
                  }
                : null,
            child: const Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
