import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/neubrutalism_theme.dart';
import 'home/home_page.dart';
import 'add_log/add_log_page.dart';
import 'history/history_page.dart';
import '../../../core/utils/health_data_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await HealthDataStore.fetchLogs();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  void _openAddLog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddLogPage(
          onLogSaved: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onAddLog: _openAddLog),
      HistoryPage(onAddLog: _openAddLog),
    ];

    return Scaffold(
      backgroundColor: NeuColors.background,
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: NeuColors.black))
          : IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: _NeuBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        onAddTap: _openAddLog,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Neubrutalism Bottom Nav Bar
// ─────────────────────────────────────────────
class _NeuBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const _NeuBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: NeuColors.white,
        border: Border(
          top: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
        ),
      ),
      child: Row(
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'HOME',
            isActive: currentIndex == 0,
            activeColor: NeuColors.yellow,
            onTap: () => onTap(0),
          ),
          // FAB-style center Add button
          Expanded(
            child: GestureDetector(
              onTap: onAddTap,
              child: Center(
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: neuDecoration(
                    color: NeuColors.pink,
                    shadowX: 4,
                    shadowY: 4,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: NeuColors.black,
                    size: 34,
                  ),
                ),
              ),
            ),
          ),
          _NavItem(
            icon: Icons.history_rounded,
            label: 'HISTORY',
            isActive: currentIndex == 1,
            activeColor: NeuColors.mint,
            onTap: () => onTap(1),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: isActive ? activeColor : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: NeuColors.black),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: NeuColors.black,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
