import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  bool _hasError = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    // Listen to focus changes to rebuild border colors
    for (final fn in _focusNodes) {
      fn.addListener(() { if (mounted) setState(() {}); });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    _shakeController.dispose();
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onChanged(String value, int index) {
    setState(() => _hasError = false);
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == 3) {
      // Last box filled — attempt verify
      FocusScope.of(context).unfocus();
      if (_otp.length == 4) _verifyOtp();
    }
  }

  void _onKeyPressed(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (_isLoading) return;
    if (_otp == AppConstants.correctOtp) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      context.read<AuthProvider>().login();
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 450),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _shakeController.forward(from: 0);
      for (final c in _controllers) { c.clear(); }
      _focusNodes[0].requestFocus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect OTP. Hint: 1234',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.read<AuthProvider>().phoneNumber;

    // NOTE: Verify button lives in bottomNavigationBar — Flutter automatically
    // adjusts it above the keyboard without any layout conflicts.
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      // resizeToAvoidBottomInset defaults to true — keyboard pushes up the body
      bottomNavigationBar: _buildVerifyButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Back
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.onSurface, size: 20),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Enter OTP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28, fontWeight: FontWeight.w800,
                  color: AppColors.onSecondaryFixed, letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A 4-digit code was sent to +91 $phone',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, color: AppColors.outline, height: 1.4),
              ),
              const SizedBox(height: 44),
              // OTP boxes — LayoutBuilder makes them auto-size to available width
              AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) {
                  final shift = _hasError
                      ? 8.0 * (0.5 - (_shakeAnim.value - 0.5).abs())
                      : 0.0;
                  return Transform.translate(
                      offset: Offset(shift * 10, 0), child: child);
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const gaps = 12.0 * 3; // 3 gaps between 4 boxes
                    final boxW = (constraints.maxWidth - gaps) / 4;
                    final boxH = (boxW * 1.1).clamp(52.0, 70.0);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (i) => _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        hasError: _hasError,
                        width: boxW,
                        height: boxH,
                        onChanged: (val) => _onChanged(val, i),
                        onKey: (ev) => _onKeyPressed(ev, i),
                      )),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('OTP resent! (Hint: 1234)',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.primary,
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Text(
                    'Resend Code',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                ),
              ),
              // Extra space so content isn't hidden behind the bottom bar
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  /// Verify button in bottomNavigationBar — stays above keyboard automatically
  Widget _buildVerifyButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isLoading || _otp.length < 4)
                ? null
                : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: AppColors.onPrimary),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Verify & Continue',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle_outline_rounded, size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// ─── OTP Box ────────────────────────────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final double width;
  final double height;
  final ValueChanged<String> onChanged;
  final Function(KeyEvent) onKey;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.width,
    required this.height,
    required this.onChanged,
    required this.onKey,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: onKey,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isFocused
              ? AppColors.surfaceContainerLowest
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasError
                ? AppColors.error
                : isFocused
                    ? AppColors.primary
                    : AppColors.outlineVariant,
            width: isFocused ? 2 : 1,
          ),
          boxShadow: isFocused
              ? [BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 10, offset: const Offset(0, 3))]
              : [],
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: AppColors.onSecondaryFixed,
          ),
          decoration: const InputDecoration(
            counterText: '', border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
