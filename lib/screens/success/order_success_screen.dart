import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../models/order.dart';
import '../home/home_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final Order order;
  const OrderSuccessScreen({super.key, required this.order});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _contentController;
  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<double> _ringScale;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _checkScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.2)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 40),
    ]).animate(_checkController);

    _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _checkController,
          curve: const Interval(0, 0.4, curve: Curves.easeIn)),
    );

    _ringScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeOutBack),
    );

    _contentFade = CurvedAnimation(
        parent: _contentController, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic));

    // Sequence the animations
    _checkController.forward().then((_) {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero celebration section
                    _buildHeroSection(),
                    const SizedBox(height: 8),
                    // Content
                    FadeTransition(
                      opacity: _contentFade,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildOrderSummaryCard(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom actions
            FadeTransition(
              opacity: _contentFade,
              child: _buildBottomActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryContainer.withOpacity(0.2),
            AppColors.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          // Animated checkmark circle
          AnimatedBuilder(
            animation: _checkController,
            builder: (_, __) {
              return SizedBox(
                width: 128,
                height: 128,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow ring
                    Transform.scale(
                      scale: _ringScale.value,
                      child: Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Middle ring
                    Transform.scale(
                      scale: _ringScale.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Main icon
                    Opacity(
                      opacity: _checkOpacity.value,
                      child: Transform.scale(
                        scale: _checkScale.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.onPrimary,
                            size: 44,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Order #${widget.order.orderId} Placed!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.onSecondaryFixed,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Arrival badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Arriving in 20–30 mins',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSecondaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B40).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                  bottom:
                      BorderSide(color: AppColors.surfaceContainerHigh)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Summary',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '${widget.order.itemCount} items',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          // Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...widget.order.items.take(3).map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    '${item.quantity}x',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      item.name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    item.unit,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '₹${item.subtotal.toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    )),
                if (widget.order.items.length > 3)
                  Text(
                    '+${widget.order.items.length - 3} more items',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.outline,
                    ),
                  ),
              ],
            ),
          ),
          // Total
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border(
                  top: BorderSide(color: AppColors.surfaceContainerHigh)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '₹${widget.order.total.toStringAsFixed(0)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        border: Border(
            top: BorderSide(color: AppColors.surfaceContainerHigh)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B40).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.my_location_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Track Order',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, animation, __) => const HomeScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurfaceVariant,
                side: BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Back to Home',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
