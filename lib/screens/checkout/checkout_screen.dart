import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../success/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _paymentMethod = 'cod';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    final orderId = 'QB-${(10000 + DateTime.now().millisecond * 9 % 90000)}';
    final order = Order(
      orderId: orderId,
      items: List.from(cart.items),
      total: cart.total,
      address: _addressController.text,
      paymentMethod: _paymentMethod,
      placedAt: DateTime.now(),
    );
    cart.clearCart();
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            OrderSuccessScreen(order: order),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (_, cart, __) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Delivery Details'),
                        const SizedBox(height: 12),
                        _buildAddressCard(),
                        const SizedBox(height: 28),
                        _sectionTitle('Payment Method'),
                        const SizedBox(height: 12),
                        _buildPaymentOptions(),
                        const SizedBox(height: 28),
                        _sectionTitle('Order Summary'),
                        const SizedBox(height: 12),
                        _buildOrderSummary(cart),
                      ],
                    ),
                  ),
                ),
                _buildPlaceOrderButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
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
          // Map placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2EC66E), Color(0xFF006D37)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: Colors.white, size: 36),
                        const SizedBox(height: 4),
                        Text(
                          'Delivery Location',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.home_rounded,
                              color: AppColors.onPrimary, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Home',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Apt, Suite, Building, Floor...',
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.primaryContainer, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.error),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your delivery address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 14, color: AppColors.outline),
                    const SizedBox(width: 4),
                    Text(
                      'Delivery arriving in ~20–30 mins',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      children: [
        Expanded(
          child: _PaymentOption(
            icon: Icons.payments_rounded,
            label: 'Cash on\nDelivery',
            isSelected: _paymentMethod == 'cod',
            onTap: () => setState(() => _paymentMethod = 'cod'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PaymentOption(
            icon: Icons.credit_card_rounded,
            label: 'Online\nPayment',
            isSelected: _paymentMethod == 'online',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Online Payment — Coming Soon!'),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
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
          _Row('Subtotal (${cart.items.length} items)',
              '₹${cart.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _Row(
            'Delivery Fee',
            cart.deliveryFee == 0
                ? 'FREE'
                : '₹${cart.deliveryFee.toStringAsFixed(0)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.outlineVariant),
          ),
          Row(
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
                '₹${cart.total.toStringAsFixed(0)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        border: Border(
            top: BorderSide(color: AppColors.surfaceVariant, width: 1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B40).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimaryContainer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            shadowColor: AppColors.primaryContainer.withOpacity(0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Place Order',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, color: AppColors.onSurfaceVariant)),
        Text(value,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface)),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 72,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryFixed
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.onSecondaryFixed
                  : AppColors.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.onSecondaryFixed
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
