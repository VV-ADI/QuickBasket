import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../cart/cart_screen.dart';
import '../login/register_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.secondary,
      elevation: 4,
      shadowColor: Colors.black26,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.onPrimary),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Text('QuickBasket',
          style: GoogleFonts.plusJakartaSans(
              fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onPrimary)),
      actions: [
        Consumer<CartProvider>(
          builder: (_, cart, __) => Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.onPrimary),
                onPressed: () {
                  setState(() => _selectedNavIndex = 2);
                  Navigator.of(context).push(_slideRoute(const CartScreen()));
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 6, top: 6,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(cart.itemCount),
                      width: 18, height: 18,
                      decoration: const BoxDecoration(
                          color: AppColors.tertiaryContainer, shape: BoxShape.circle),
                      child: Center(
                        child: Text('${cart.itemCount}',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10, fontWeight: FontWeight.w800,
                                color: AppColors.onTertiaryContainer)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final initials = auth.name.isNotEmpty
        ? auth.name.trim().split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').take(2).join()
        : 'U';

    return Drawer(
      backgroundColor: AppColors.surfaceContainerLowest,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.onSecondaryFixed],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.primaryContainer, AppColors.primary]),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: Center(
                    child: Text(initials,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 22, fontWeight: FontWeight.w800,
                            color: AppColors.onPrimary)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(auth.name.isNotEmpty ? auth.name : 'Guest',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 18, fontWeight: FontWeight.w800,
                        color: AppColors.onPrimary)),
                if (auth.email.isNotEmpty)
                  Text(auth.email,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: 8),
            _DrawerItem(icon: Icons.home_rounded, label: 'Home', onTap: () => Navigator.pop(context)),
            _DrawerItem(
              icon: Icons.shopping_cart_outlined, label: 'My Cart',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(_slideRoute(const CartScreen()));
              },
            ),
            _DrawerItem(
              icon: Icons.person_outline_rounded, label: 'Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(_slideRoute(const ProfileScreen()));
              },
            ),
            const Divider(indent: 16, endIndent: 16, color: AppColors.surfaceContainerHigh),
            _DrawerItem(
              icon: Icons.logout_rounded, label: 'Log Out',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
                context.read<CartProvider>().clearCart();
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, a, __) => const RegisterScreen(),
                    transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                  (r) => false,
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('QuickBasket v1.0.0',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outlineVariant)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildSearchBar()),
        SliverToBoxAdapter(child: _buildCategoryChips()),
        _buildProductGrid(),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.search_rounded, color: AppColors.outline, size: 22),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (val) => context.read<ProductProvider>().setSearchQuery(val),
                style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search for fresh groceries...',
                  hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.outlineVariant, fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            // Clear button
            Consumer<ProductProvider>(
              builder: (_, provider, __) {
                if (provider.searchQuery.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.outline),
                  onPressed: () {
                    _searchController.clear();
                    provider.setSearchQuery('');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Consumer<ProductProvider>(
      builder: (_, provider, __) {
        return SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: AppConstants.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = AppConstants.categories[i];
              final isSelected = provider.selectedCategory == cat;
              return _CategoryChip(
                label: cat, isSelected: isSelected,
                onTap: () => provider.selectCategory(cat),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (_, provider, __) {
        final products = provider.filteredProducts;
        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(children: [
                  const Icon(Icons.search_off_rounded, size: 64, color: AppColors.outlineVariant),
                  const SizedBox(height: 16),
                  Text('No products found',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppColors.outline)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      provider.setSearchQuery('');
                      provider.selectCategory('All');
                    },
                    child: Text('Clear filters',
                        style: GoogleFonts.plusJakartaSans(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.72,
              crossAxisSpacing: 12, mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => _AnimatedProductCard(product: products[i], index: i),
              childCount: products.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Consumer<CartProvider>(
      builder: (_, cart, __) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.home_rounded, label: 'Home', isSelected: _selectedNavIndex == 0,
                      onTap: () => setState(() => _selectedNavIndex = 0)),
                  _CartNavItem(
                    badgeCount: cart.itemCount, isSelected: _selectedNavIndex == 2,
                    onTap: () {
                      setState(() => _selectedNavIndex = 2);
                      Navigator.of(context).push(_slideRoute(const CartScreen()));
                    },
                  ),
                  _NavItem(
                    icon: Icons.person_rounded, label: 'Profile', isSelected: _selectedNavIndex == 3,
                    onTap: () {
                      setState(() => _selectedNavIndex = 3);
                      Navigator.of(context).push(_slideRoute(const ProfileScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PageRoute _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

// Temporary placeholder used only by drawer logout — avoids circular import
class _LogoutPlaceholder extends StatelessWidget {
  const _LogoutPlaceholder();
  @override
  Widget build(BuildContext context) {
    // Immediately redirect to register
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => _RegisterBridge()),
      );
    });
    return const Scaffold(backgroundColor: AppColors.surfaceContainerLowest);
  }
}

class _RegisterBridge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lazy import to avoid circular dependency
    return const _RegisterScreenWrapper();
  }
}

class _RegisterScreenWrapper extends StatelessWidget {
  const _RegisterScreenWrapper();
  @override
  Widget build(BuildContext context) {
    // We use a builder so the import stays local
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) {
          // This triggers app restart by returning to the register screen
          // We rebuild via Navigator.pushAndRemoveUntil already done in drawer
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.onSecondaryFixed : AppColors.secondaryFixed,
          borderRadius: BorderRadius.circular(100),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.onSecondaryFixed.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
        ),
        child: Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.onPrimary : AppColors.onSecondaryFixed)),
      ),
    );
  }
}

// ─── Animated Product Card ────────────────────────────────────────────────────
class _AnimatedProductCard extends StatefulWidget {
  final Product product;
  final int index;
  const _AnimatedProductCard({required this.product, required this.index});
  @override
  State<_AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<_AnimatedProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: Duration(milliseconds: 350 + widget.index * 40));
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.index * 35), () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: ProductCard(product: widget.product)));
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────
class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _bounce;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.82).chain(CurveTween(curve: Curves.easeIn)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.12).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 30),
    ]).animate(_bounce);
  }

  @override
  void dispose() { _bounce.dispose(); super.dispose(); }

  void _add() { _bounce.forward(from: 0); context.read<CartProvider>().addProduct(widget.product); }
  void _remove() => context.read<CartProvider>().removeProduct(widget.product);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, cart, __) {
        final qty = cart.quantityOf(widget.product.id);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: const Color(0xFF0D1B40).withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 4))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity, color: AppColors.surfaceContainer,
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imageUrl, fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppColors.surfaceContainer,
                        highlightColor: AppColors.surfaceContainerHighest,
                        child: Container(color: AppColors.surfaceContainer),
                      ),
                      errorWidget: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported_outlined, color: AppColors.outline, size: 28)),
                    ),
                  ),
                ),
                if (widget.product.badge != null)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(100)),
                      child: Text(widget.product.badge!.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.onTertiaryContainer, letterSpacing: 0.5)),
                    ),
                  ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.product.name,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurface),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(widget.product.unit,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('₹${widget.product.price.toStringAsFixed(0)}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                    child: qty == 0
                        ? ScaleTransition(
                            scale: _bounceAnim,
                            child: GestureDetector(
                              key: const ValueKey('add'),
                              onTap: _add,
                              child: Container(
                                width: 32, height: 32,
                                decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                                child: const Icon(Icons.add_rounded, color: AppColors.onPrimaryContainer, size: 18),
                              ),
                            ),
                          )
                        : Container(
                            key: const ValueKey('stepper'),
                            height: 32,
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              GestureDetector(onTap: _remove, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.remove_rounded, size: 16, color: AppColors.onPrimary))),
                              Text('$qty', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onPrimary)),
                              GestureDetector(onTap: _add, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.add_rounded, size: 16, color: AppColors.onPrimary))),
                            ]),
                          ),
                  ),
                ]),
              ]),
            ),
          ]),
        );
      },
    );
  }
}

// ─── Nav Items ────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 24, color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

class _CartNavItem extends StatelessWidget {
  final int badgeCount;
  final bool isSelected;
  final VoidCallback onTap;
  const _CartNavItem({required this.badgeCount, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(clipBehavior: Clip.none, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.shopping_cart_rounded, size: 24, color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
            const SizedBox(height: 2),
            Text('Cart', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant)),
          ]),
        ),
        if (badgeCount > 0)
          Positioned(
            top: 2, right: 8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Container(
                key: ValueKey(badgeCount),
                width: 18, height: 18,
                decoration: const BoxDecoration(color: AppColors.tertiaryContainer, shape: BoxShape.circle),
                child: Center(child: Text('$badgeCount', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.onTertiaryContainer))),
              ),
            ),
          ),
      ]),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.onSurface;
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: c)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
