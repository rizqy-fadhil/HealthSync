import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/neubrutalism_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/health_data_store.dart';
import '../../widgets/common/neu_button.dart';
import '../main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      HealthDataStore.clear(); // ← Clear stale data from previous session

      if (!mounted) return;

      // Navigate to MainPage and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
        (route) => false,
      );
    } on DioException catch (e) {
      if (!mounted) return;
      final message = _extractErrorMessage(e);
      _showNeuErrorSnackBar(message);
    } catch (e) {
      if (!mounted) return;
      _showNeuErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Extract a user-friendly error message from a DioException.
  String _extractErrorMessage(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      // Laravel validation errors
      if (data is Map && data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
          return firstError.toString();
        }
      }
      // Laravel single message
      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }
      return 'Server error (${e.response!.statusCode})';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out!';
      case DioExceptionType.connectionError:
        return 'No internet connection!';
      default:
        return 'Something went wrong!';
    }
  }

  /// Neubrutalist error SnackBar — Electric Yellow, thick border, sharp corners.
  void _showNeuErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeuColors.yellow,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: const BorderSide(color: NeuColors.black, width: 4.0),
        ),
        content: Text(
          '⚠️  $message',
          style: neuText(size: 14),
        ),
      ),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 28),
                      _buildNameField(),
                      const SizedBox(height: 16),
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 16),
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: NeuButton(
                          label: 'SIGN UP!',
                          color: NeuColors.pink,
                          fontSize: 20,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          isLoading: _isLoading,
                          onPressed: _handleRegister,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLoginFooter(),
                    ],
                  ),
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
          Text(
            'HEALTH\nSYNC',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
              color: NeuColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Title ─────────────────────────────────────
  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'JOIN\nUS!',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: NeuColors.black,
            height: 0.95,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: NeuColors.yellow,
            border: Border.all(color: NeuColors.black, width: 3),
          ),
          child: Text(
            'CREATE YOUR ACCOUNT',
            style: neuText(size: 13, letterSpacing: 1.5),
          ),
        ),
      ],
    );
  }

  // ─── Name Field ────────────────────────────────
  Widget _buildNameField() {
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
            '👤  FULL NAME',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: NeuColors.mint,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: NeuColors.white,
            border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
            boxShadow: const [
              BoxShadow(
                color: NeuColors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: _nameController,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: NeuColors.black,
            ),
            decoration: InputDecoration(
              hintText: 'John Doe',
              hintStyle: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: NeuColors.black.withAlpha(40),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name is required!';
              if (v.trim().length < 2) return 'Name is too short!';
              return null;
            },
          ),
        ),
      ],
    );
  }

  // ─── Email Field ──────────────────────────────
  Widget _buildEmailField() {
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
          decoration: BoxDecoration(
            color: NeuColors.white,
            border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
            boxShadow: const [
              BoxShadow(
                color: NeuColors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: NeuColors.black,
            ),
            decoration: InputDecoration(
              hintText: 'your@email.com',
              hintStyle: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: NeuColors.black.withAlpha(40),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required!';
              if (!v.contains('@')) return 'Enter a valid email!';
              return null;
            },
          ),
        ),
      ],
    );
  }

  // ─── Password Field ───────────────────────────
  Widget _buildPasswordField() {
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
            '🔒  PASSWORD',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: NeuColors.pink,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: NeuColors.white,
            border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
            boxShadow: const [
              BoxShadow(
                color: NeuColors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: NeuColors.black,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: NeuColors.black.withAlpha(40),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  color: NeuColors.mint,
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: NeuColors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required!';
              if (v.length < 8) return 'Min. 8 characters!';
              return null;
            },
          ),
        ),
      ],
    );
  }

  // ─── Confirm Password Field ───────────────────
  Widget _buildConfirmPasswordField() {
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
            '🔐  CONFIRM PASSWORD',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: NeuColors.mint,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: NeuColors.white,
            border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
            boxShadow: const [
              BoxShadow(
                color: NeuColors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: NeuColors.black,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: NeuColors.black.withAlpha(40),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  color: NeuColors.yellow,
                  child: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: NeuColors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Confirm your password!';
              if (v != _passwordController.text) return 'Passwords don\'t match!';
              return null;
            },
          ),
        ),
      ],
    );
  }

  // ─── Login Footer ─────────────────────────────
  Widget _buildLoginFooter() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: NeuColors.yellow,
            border: Border.all(color: NeuColors.black, width: 3),
            boxShadow: const [
              BoxShadow(
                color: NeuColors.black,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'HAVE AN ACCOUNT?',
                style: neuText(size: 13, letterSpacing: 1),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: NeuColors.black,
                ),
                child: Text(
                  'LOGIN',
                  style: neuText(size: 13, color: NeuColors.yellow, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
