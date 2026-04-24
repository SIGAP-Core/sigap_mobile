import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sigap_mobile/features/auth/provider/driver_provider.dart';
import 'package:sigap_mobile/features/dashboard/bloc/access_logs_bloc.dart';
import 'package:sigap_mobile/features/dashboard/models/access_log_model.dart';
import 'package:sigap_mobile/features/dashboard/provider/dashboard_sheet_provider.dart';
import 'package:sigap_mobile/app/provider/drawer_provider.dart';
import 'package:sigap_mobile/shared/values/lists.dart';

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

  @override
  Widget build(BuildContext context) {
    final driver = context.watch<DriverProvider>().driver;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Hamburger Menu
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.read<DrawerProvider>().toggleDrawer();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: Color(0xFF3B82F6), // Blue Accent
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo, Selamat Datang!",
                style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                driver?.name ?? "...",
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
      ],
    );
  }
}

class DigitalCardDriverLicense extends StatelessWidget {
  const DigitalCardDriverLicense({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = context.watch<DriverProvider>().driver;

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
          Text(
            driver?.license ?? "X XXXX XXX",
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
            Icon(Icons.qr_code_scanner, color: Color(0xFF0F172A), size: 24),
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.read<AccessLogsBloc>().add(LoadAccessLogs(uid: user.uid));
      }
    });
  }

  // Fungsi untuk mengekstrak "Bulan Tahun" unik dari rawLogs
  List<String> _generateTabs(List<AccessLogModel> logs) {
    Set<String> uniqueTabs = {};
    bool hasInvalidData = false;

    for (var log in logs) {
      if (log.tanggal != null) {
        uniqueTabs.add(
          "${Lists.namaBulan[log.tanggal!.month]} ${log.tanggal!.year}",
        );
      } else {
        hasInvalidData = true;
      }
    }

    List<String> tabs = uniqueTabs.toList();
    tabs.sort((a, b) => b.compareTo(a)); // Terbaru di kiri
    if (hasInvalidData) tabs.add("Data Invalid");

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
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
                // ZONA BISA DI-DRAG (Handle, Title)
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // Supaya Live ada di kanan
                            children: [
                              const Text(
                                "Riwayat Akses",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Label Live Update
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.redAccent.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.redAccent,
                                      size: 8,
                                    ), // Titik merah
                                    SizedBox(width: 4),
                                    Text(
                                      "LIVE",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // ZONA TIDAK BISA DI-DRAG (ListView & Tab Content)
                Expanded(
                  child: BlocBuilder<AccessLogsBloc, AccessLogsState>(
                    builder: (context, state) {
                      if (state is AccessLogsLoading) {
                        // MENAMPILKAN SHIMMER TABS DAN LIST
                        return const ShimmerLoadingView();
                      }

                      if (state is AccessLogsLoaded) {
                        if (state.logs.isEmpty) {
                          return const AccessLogsEmpty();
                        }

                        // --- KALKULASI TAB DINAMIS ---
                        final dynamicTabs = _generateTabs(state.logs);
                        final int selectedIndex = context
                            .select<DashboardSheetProvider, int>(
                              (p) => p.selectedTabIndex,
                            );

                        // Safety check jika selected index melebihi jumlah tab
                        final safeIndex = selectedIndex < dynamicTabs.length
                            ? selectedIndex
                            : 0;
                        final activeTab = dynamicTabs[safeIndex];

                        // --- FILTER LOG SESUAI TAB ---
                        final filteredLogs = state.logs.where((log) {
                          if (log.tanggal != null) {
                            String logTabName =
                                "${Lists.namaBulan[log.tanggal!.month]} ${log.tanggal!.year}";
                            return logTabName == activeTab;
                          }
                          return activeTab == "Data Invalid";
                        }).toList();

                        // --- RENDER TABS DAN LIST ---
                        return Column(
                          children: [
                            _buildDynamicTabs(context, dynamicTabs, safeIndex),
                            Expanded(
                              child: AccessLogs(filteredLogs: filteredLogs),
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
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

  Widget _buildDynamicTabs(
    BuildContext context,
    List<String> tabs,
    int selectedIndex,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF334155), width: 1.5),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedIndex == index;
            final isInvalid = tabs[index] == "Data Invalid";
            final accentColor = isInvalid
                ? Colors.orangeAccent
                : const Color(0xFF3B82F6);

            return GestureDetector(
              onTap: () => context
                  .read<DashboardSheetProvider>()
                  .setSelectedTabIndex(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? accentColor : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ShimmerLoadingView extends StatelessWidget {
  const ShimmerLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer Tabs (3 Kotak horizontal)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: List.generate(
              3,
                  (index) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFF334155),
                  highlightColor: const Color(0xFF475569),
                  child: Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Divider(color: Color(0xFF334155), height: 1, thickness: 1.5),

        // Shimmer untuk List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFF334155),
                  highlightColor: const Color(0xFF475569),
                  child: Row(
                    children: [
                      // Skeleton Ikon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Skeleton Teks
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: double.infinity, height: 16, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(width: 120, height: 12, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Skeleton Status
                      Container(width: 40, height: 14, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AccessLogs extends StatelessWidget {
  final List<AccessLogModel> filteredLogs;

  const AccessLogs({super.key, required this.filteredLogs});

  String _formatDateTime(DateTime date) {
    String namaBulanSingkat = Lists.namaBulan[date.month].substring(0, 3);
    String jam = date.hour.toString().padLeft(2, '0');
    String menit = date.minute.toString().padLeft(2, '0');
    return "${date.day} $namaBulanSingkat ${date.year}, $jam:$menit WIB";
  }

  // --- LOGIKA LABEL WAKTU RELATIF ---
  (String, Color)? _getDateBadge(DateTime date) {
    final now = DateTime.now();
    // Menghilangkan unsur jam, menit, detik agar perbandingan murni beda hari (kalender)
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    final int diffInDays = today.difference(targetDate).inDays;

    if (diffInDays == 0) {
      return ("Hari Ini", const Color(0xFF3B82F6)); // Biru Accent
    } else if (diffInDays == 1) {
      return ("Kemarin", const Color(0xFFA855F7)); // Ungu
    } else if (diffInDays == 2) {
      return ("Kemarin Lusa", const Color(0xFFF59E0B)); // Oranye/Amber
    }

    // Lebih dari 2 hari (tanpa badge)
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: filteredLogs.length,
      itemBuilder: (context, index) {
        final log = filteredLogs[index];

        // INVALID CARD
        if (log.tanggal == null) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.orangeAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Format Data Invalid",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Tanggal: ${log.rawTanggal ?? 'Unknown'}",
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // --- KALKULASI LABEL WAKTU ---
        final badgeInfo = _getDateBadge(log.tanggal!);

        // NORMAL LOG CARD
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.1),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Akses Gerbang",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // --- TANGGAL & BADGE ---
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8, // Jarak antara teks tanggal dan badge
                      runSpacing: 4, // Jarak jika teks turun baris (layar kecil)
                      children: [
                        Text(
                          _formatDateTime(log.tanggal!),
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                        // Render Badge jika badgeInfo tidak null
                        if (badgeInfo != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeInfo.$2.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: badgeInfo.$2.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              badgeInfo.$1,
                              style: TextStyle(
                                color: badgeInfo.$2,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
    );
  }
}

class AccessLogsEmpty extends StatelessWidget {
  const AccessLogsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Tidak ada data akses.",
        style: TextStyle(color: Color(0xFF94A3B8)),
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
