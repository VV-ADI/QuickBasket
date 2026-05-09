import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthProvider>().setPhoneNumber(_phoneController.text);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const OtpScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      // Logo
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryContainer.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_basket_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Welcome',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSecondaryFixed,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your mobile number to sign in or\ncreate an account.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.outline,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mobile Number',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                // Country code
                                Container(
                                  height: 56,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppColors.outlineVariant),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '+91',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSecondaryFixed,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.expand_more,
                                          size: 20, color: AppColors.outline),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Number input
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSecondaryFixed,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      hintText: '000 000 0000',
                                      filled: true,
                                      fillColor: AppColors.surfaceContainerLowest,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.outlineVariant),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.outlineVariant),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.primary, width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.error),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Please enter your number';
                                      }
                                      if (val.length != 10) {
                                        return 'Enter a valid 10-digit number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Send OTP Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.onSecondaryFixed,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Text(
                                  'Send OTP',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Divider
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(color: AppColors.outlineVariant)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'SECURE VERIFICATION',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.outline,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const Expanded(
                              child: Divider(color: AppColors.outlineVariant)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Trust badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TrustBadge(
                              icon: Icons.lock_outline_rounded,
                              label: 'SSL Secured'),
                          const SizedBox(width: 24),
                          _TrustBadge(
                              icon: Icons.verified_user_outlined,
                              label: 'OTP Verified'),
                          const SizedBox(width: 24),
                          _TrustBadge(
                              icon: Icons.flash_on_rounded,
                              label: 'Fast Delivery'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}
