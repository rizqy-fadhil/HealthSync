import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/neubrutalism_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/health_data_store.dart';
import '../../widgets/common/neu_button.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '';
  String _userEmail = '';
  bool _isLoading = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getSavedUser();
    if (user != null && mounted) {
      setState(() {
        _userName = user['name'] as String? ?? 'USER';
        _userEmail = user['email'] as String? ?? '';
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);

    await AuthService.logout();
    HealthDataStore.clear(); // ← Clear cached logs so next user starts fresh

    if (!mounted) return;

    // Navigate to LoginPage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: NeuColors.black),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                      child: Column(
                        children: [
                          _buildAvatar(),
                          const SizedBox(height: 24),
                          _buildNameBlock(),
                          const SizedBox(height: 16),
                          _buildEmailBlock(),
                          const SizedBox(height: 16),
                          _buildJoinedBlock(),
                          const SizedBox(height: 40),
                          _buildLogoutButton(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: NeuColors.mint,
        border: Border(
          bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeuColors.black,
                border: Border.all(color: NeuColors.black, width: 2),
              ),
              child: const Icon(Icons.arrow_back, color: NeuColors.mint, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'PROFILE',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: NeuColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Avatar ───────────────────────────────────
  Widget _buildAvatar() {
    final initials = _userName.isNotEmpty
        ? _userName.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';

    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: NeuColors.pink,
        border: Border.all(color: NeuColors.black, width: 4),
        boxShadow: const [
          BoxShadow(
            color: NeuColors.black,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: NeuColors.black,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  // ─── Name Block ───────────────────────────────
  Widget _buildNameBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: NeuColors.black,
            border: Border(
              bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
            ),
          ),
          child: Text(
            '👤  NAME',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: NeuColors.mint,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: NeuColors.yellow,
            border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
            boxShadow: const [
              BoxShadow(
                color: NeuColors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            _userName.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: NeuColors.black,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Email Block ──────────────────────────────
  Widget _buildEmailBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: NeuColors.black,
            border: Border(
              bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
            ),
          ),
          child: Text(
            '📧  EMAIL',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: NeuColors.yellow,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: NeuColors.yellow,
            border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
            boxShadow: const [
              BoxShadow(
                color: NeuColors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            _userEmail.isNotEmpty ? _userEmail.toLowerCase() : 'NO EMAIL',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: NeuColors.black,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Joined Block ─────────────────────────────
  Widget _buildJoinedBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: NeuColors.white,
        border: Border.all(color: NeuColors.black, width: 3),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded, size: 18, color: NeuColors.black),
          const SizedBox(width: 10),
          Text(
            'HEALTHSYNC MEMBER',
            style: neuText(size: 13, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }

  // ─── Logout Button ────────────────────────────
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: NeuButton(
        label: 'LOGOUT',
        color: NeuColors.pink,
        fontSize: 20,
        padding: const EdgeInsets.symmetric(vertical: 20),
        isLoading: _isLoggingOut,
        onPressed: _handleLogout,
      ),
    );
  }
}
