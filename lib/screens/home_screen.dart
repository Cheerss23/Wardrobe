import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'shop_this_look_screen.dart';
import 'cart_screen.dart';
import 'saved_screen.dart';
import 'try_on_studio_screen.dart';
import '../widgets/product_catalog_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final heroOutfit = appState.heroOutfit;
    final products = appState.products;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            // 1. Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat pagi, Rahmat 👋',
                        style: GoogleFonts.fraunces(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.wb_sunny_rounded, color: AppColors.warning, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            appState.weatherLocation,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Wishlist Shortcut
                      IconButton(
                        icon: const Icon(Icons.favorite_border_rounded, color: AppColors.primaryText),
                        tooltip: 'Wishlist',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SavedScreen()),
                          );
                        },
                      ),
                      // Cart Shortcut with Badge
                      IconButton(
                        icon: Badge(
                          label: Text('${appState.cartCount}'),
                          isLabelVisible: appState.cartCount > 0,
                          backgroundColor: AppColors.primaryPurple,
                          child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryText),
                        ),
                        tooltip: 'Keranjang',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CartScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Search Bar Shortcut (Tapping jumps to Discover tab)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: InkWell(
                onTap: () => appState.setTabIndex(1), // Switch to Discover tab
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.primaryPurple, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Cari brand, kemeja, celana, atau style...',
                        style: GoogleFonts.inter(
                          color: AppColors.tertiaryText,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurpleLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.tune_rounded, size: 16, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3. Hero Section: "Today's Style"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurpleLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppColors.primaryPurple, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Today's Style",
                            style: GoogleFonts.fraunces(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurpleLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${heroOutfit.matchScore}% Match',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Hero Outfit Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Large Outfit Photo with weather badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
                              child: AspectRatio(
                                aspectRatio: 1.45,
                                child: Image.network(
                                  heroOutfit.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.softSurface,
                                    child: const Icon(Icons.image, size: 48, color: AppColors.tertiaryText),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 14),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Cocok untuk 28°C cuaca hari ini',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Outfit Details & Items Breakdown
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                heroOutfit.title,
                                style: GoogleFonts.fraunces(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                heroOutfit.whyMatchReasons.first,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Items mini preview row
                              SizedBox(
                                height: 50,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: heroOutfit.items.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                                  itemBuilder: (context, idx) {
                                    final item = heroOutfit.items[idx];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.softSurface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: Image.network(item.image, width: 34, height: 34, fit: BoxFit.cover),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.name,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                item.isOwned ? 'Milikmu' : item.formattedPrice,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: item.isOwned ? AppColors.success : AppColors.secondaryText,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Price & CTAs: Shop This Look (Primary) > Try This Look (Secondary)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bundle Price',
                                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Rp${(heroOutfit.effectivePrice ~/ 1000)}.000',
                                            style: GoogleFonts.fraunces(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.discountBadge,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '-${heroOutfit.bundleDiscountPercentage}%',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      // Secondary CTA: Try This Look
                                      OutlinedButton(
                                        onPressed: () {
                                          appState.startTryOnWithLook(heroOutfit.items);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const TryOnStudioScreen(),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          side: const BorderSide(color: AppColors.primaryPurple),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        ),
                                        child: Text(
                                          'Try Look',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryPurple,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Primary CTA: Shop This Look (Dominates visually)
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ShopThisLookScreen(outfit: heroOutfit),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                                        label: const Text('Shop Look'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryPurple,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Section: Trending Now
            _buildSectionHeader(
              title: 'Trending Now 🔥',
              subtitle: 'Paling banyak dilihat & dibeli minggu ini',
              onSeeAll: () => appState.setTabIndex(1),
            ),
            _buildProductHorizontalList(
              context,
              products.where((p) => !p.isOwned).take(5).toList(),
              appState,
            ),

            const SizedBox(height: 24),

            // 5. Section: Best Picks For You (AI personalized)
            _buildSectionHeader(
              title: 'Best Picks For You ✨',
              subtitle: 'Cocok 90%+ dengan profil gaya casual streetwear kamu',
              onSeeAll: () => appState.setTabIndex(1),
            ),
            _buildProductHorizontalList(
              context,
              products.where((p) => (p.matchPercentage ?? 0) >= 94 && !p.isOwned).toList(),
              appState,
            ),

            const SizedBox(height: 24),

            // 6. Section: Limited Deals
            _buildSectionHeader(
              title: 'Limited Deals ⚡',
              subtitle: 'Diskon spesial hingga 33% sebelum promo berakhir',
              onSeeAll: () => appState.setTabIndex(1),
            ),
            _buildProductHorizontalList(
              context,
              products.where((p) => p.discountPercentage != null && p.discountPercentage! >= 22).toList(),
              appState,
            ),

            const SizedBox(height: 24),

            // 7. Section: Popular Brands
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Popular Brands',
                style: GoogleFonts.fraunces(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildBrandChip('Localwear', appState),
                  _buildBrandChip('Street Co.', appState),
                  _buildBrandChip('ZARA', appState),
                  _buildBrandChip('Ruang Basic', appState),
                  _buildBrandChip('Studio Monolith', appState),
                  _buildBrandChip('Kita Apparel', appState),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 8. Section: Recommended For Today's Weather (28°C Sunny)
            _buildSectionHeader(
              title: "Recommended for Today's Weather ☀️",
              subtitle: 'Material linen & combed cotton dingin untuk hari cerah',
              onSeeAll: () => appState.setTabIndex(1),
            ),
            _buildProductHorizontalList(
              context,
              products.where((p) => p.category == 'Tops' && !p.isOwned).toList(),
              appState,
            ),

            const SizedBox(height: 24),

            // 9. Section: Complete The Look Promo Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.purpleAiGradient,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'AI BUNDLE PROMO',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lengkapi Lemarimu dengan Voucher FITLY10',
                            style: GoogleFonts.fraunces(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Dapatkan diskon 10% saat membeli item pelengkap.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => appState.setTabIndex(2), // Jump to AI Stylist tab
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryPurple,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Konsultasi AI Stylist',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&auto=format&fit=crop&q=80',
                        width: 90,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'Lihat Semua',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHorizontalList(
    BuildContext context,
    List<ProductItem> items,
    AppState appState,
  ) {
    return SizedBox(
      height: 285,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final product = items[index];
          return ProductCatalogCard(
            product: product,
            width: 165,
          );
        },
      ),
    );
  }

  Widget _buildBrandChip(String brand, AppState appState) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(brand),
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          appState.setDiscoverSearchQuery(brand);
          appState.setTabIndex(1);
        },
      ),
    );
  }
}
