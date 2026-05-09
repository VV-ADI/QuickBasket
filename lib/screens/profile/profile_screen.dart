import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../login/register_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Profile',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Name card
            _ProfileHeader(auth: auth),
            const SizedBox(height: 24),
            // Info cards
            _SectionTitle('Account Details'),
            const SizedBox(height: 12),
            _InfoCard(items: [
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: 'Full Name',
                value: auth.name.isNotEmpty ? auth.name : '—',
              ),
              _InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: auth.email.isNotEmpty ? auth.email : '—',
              ),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Mobile',
                value: auth.phoneNumber.isNotEmpty
                    ? '+91 ${auth.phoneNumber}'
                    : '—',
              ),
            ]),
            const SizedBox(height: 24),
            _SectionTitle('App'),
            const SizedBox(height: 12),
            _InfoCard(items: [
              _SettingsRow(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsRow(
                icon: Icons.location_on_outlined,
                label: 'Saved Addresses',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.outline, size: 20),
                onTap: () {},
              ),
              _SettingsRow(
                icon: Icons.receipt_long_outlined,
                label: 'Order History',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.outline, size: 20),
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 32),
            // Logout
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout_rounded,
                    color: AppColors.error, size: 18),
                label: Text(
                  'Log Out',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.logout_rounded, size: 40, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              'Log Out?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will need to register again to\nuse QuickBasket.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AuthProvider>().logout();
                      context.read<CartProvider>().clearCart();
                      Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder: (_, animation, __) =>
                              const RegisterScreen(),
                          transitionsBuilder: (_, animation, __, child) =>
                              FadeTransition(opacity: animation, child: child),
                          transitionDuration:
                              const Duration(milliseconds: 400),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text('Log Out',
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AuthProvider auth;
  const _ProfileHeader({required this.auth});

  @override
  Widget build(BuildContext context) {
    final initials = auth.name.isNotEmpty
        ? auth.name
            .trim()
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
            .take(2)
            .join()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B40).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryContainer, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onPrimary,
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
                  auth.name.isNotEmpty ? auth.name : 'Guest',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  auth.email.isNotEmpty ? auth.email : '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: AppColors.primaryContainer, width: 1),
                  ),
                  child: Text(
                    'Verified Member',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> items;
  const _InfoCard({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B40).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              items[i],
              if (i < items.length - 1)
                const Divider(
                    height: 1,
                    indent: 56,
                    color: AppColors.surfaceContainerHigh),
            ],
          );
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.outline,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600)),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
