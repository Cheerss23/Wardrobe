import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';
import 'live_fitting_mirror_screen.dart';
import 'try_with_wardrobe_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductItem? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _activeImageIndex = 0;
  late String _selectedSize;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    final p = widget.product ?? _defaultProduct;
    _selectedSize = p.sizes.isNotEmpty ? p.sizes.first : 'M';
    _selectedColor = p.colors.isNotEmpty ? p.colors.first : 'Black';
  }

  static const ProductItem _defaultProduct = ProductItem(
    id: 'p1',
    name: 'Oversized Combed Black Tee',
    seller: 'Localwear Bandung',
    brand: 'Localwear',
    price: 129000,
    formattedPrice: 'Rp129.000',
    originalPrice: 169000,
    formattedOriginalPrice: 'Rp169.000',
    discountPercentage: 24,
    image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
    category: 'Tops',
    description: 'Heavyweight 24s combed cotton with relaxed drop shoulder fit.',
  );

  void _showFindMySizeModal(BuildContext context, AppState appState, ProductItem product) {
    int tempHeight = appState.userHeightCm;
    int tempWeight = appState.userWeightKg;
    String recommendedSize = appState.getRecommendedSizeForProduct(product);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurpleLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppColors.primaryPurple, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Size Recommendation',
                            style: GoogleFonts.fraunces(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 10),

                  // Prediction Result Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurpleLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            recommendedSize,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ukuran Paling Pas: Size $recommendedSize',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryPurpleDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Tingkat akurasi 94% berdasarkan siluet boxy & proporsi tubuhmu.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Measurement Quick Adjusters
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.softSurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tinggi Badan', style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText)),
                              Text('$tempHeight cm', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.softSurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Berat Badan', style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText)),
                              Text('$tempWeight kg', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSize = recommendedSize;
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ukuran diubah ke Size $recommendedSize sesuai rekomendasi AI!'),
                            backgroundColor: AppColors.primaryPurpleDark,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Pilih Ukuran Ini (Size $recommendedSize)',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final product = widget.product ?? appState.products[0];
    final images = product.allImages;
    final isSaved = appState.isSaved(product.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          product.brand.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppColors.primaryPurple,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isSaved ? AppColors.discountBadge : AppColors.primaryText,
            ),
            tooltip: 'Wishlist',
            onPressed: () => appState.toggleSave(product.id),
          ),
          IconButton(
            icon: Badge(
              label: Text('${appState.cartCount}'),
              isLabelVisible: appState.cartCount > 0,
              backgroundColor: AppColors.primaryPurple,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          // Image Gallery with Swipe & Indicator
          SizedBox(
            height: 380,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (idx) => setState(() => _activeImageIndex = idx),
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.softSurface,
                        child: const Icon(Icons.image, size: 64, color: AppColors.tertiaryText),
                      ),
                    );
                  },
                ),
                // Indicator dots
                if (images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (idx) {
                        final isAct = _activeImageIndex == idx;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isAct ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isAct ? AppColors.primaryPurple : Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                // Match Badge
                if (product.matchPercentage != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${product.matchPercentage}% Match dengan Gayari',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Main Info Container
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seller & Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.seller,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          ' (${product.soldCount})',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Product Title
                Text(
                  product.name,
                  style: GoogleFonts.fraunces(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Price and Discount
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      product.formattedPrice,
                      style: GoogleFonts.fraunces(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    if (product.formattedOriginalPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        product.formattedOriginalPrice!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.tertiaryText,
                        ),
                      ),
                    ],
                    if (product.discountPercentage != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.discountBadge,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${product.discountPercentage}%',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                if (product.matchReason != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurpleLight.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.primaryPurple, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product.matchReason!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primaryText,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Color & Size Selector Container
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Color Selector
                Text(
                  'Warna: $_selectedColor',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: product.colors.map((c) {
                    final isSel = _selectedColor == c;
                    return ChoiceChip(
                      label: Text(c),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setState(() => _selectedColor = c);
                      },
                      selectedColor: AppColors.primaryPurpleLight,
                      labelStyle: GoogleFonts.inter(
                        color: isSel ? AppColors.primaryPurple : AppColors.primaryText,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSel ? AppColors.primaryPurple : AppColors.border,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),

                // Size Selector Header with "Find My Size"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ukuran: $_selectedSize',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    // "Find My Size" AI button
                    InkWell(
                      onTap: () => _showFindMySizeModal(context, appState, product),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.straighten_rounded, size: 16, color: AppColors.primaryPurple),
                            const SizedBox(width: 4),
                            Text(
                              'Find My Size (AI)',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: product.sizes.map((s) {
                    final isSel = _selectedSize == s;
                    return ChoiceChip(
                      label: Text(s),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setState(() => _selectedSize = s);
                      },
                      selectedColor: AppColors.primaryPurple,
                      labelStyle: GoogleFonts.inter(
                        color: isSel ? Colors.white : AppColors.primaryText,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSel ? AppColors.primaryPurple : AppColors.border,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Product Details & Specifications
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deskripsi Produk',
                  style: GoogleFonts.fraunces(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                _buildSpecItem('Material', product.material),
                _buildSpecItem('Kategori', product.category),
                _buildSpecItem('Gaya', product.styleCategory),
                _buildSpecItem('Pengiriman', 'Dikirim dalam 24 jam dari Bandung'),
                _buildSpecItem('Garansi', '7 Hari Pengembalian Bebas Biaya'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Try With My Wardrobe Feature Banner (Product Discovery + Wardrobe Compatibility)
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          gradient: AppColors.purpleAiGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.checkroom_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Try With My Wardrobe',
                              style: GoogleFonts.fraunces(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              'Cocokkan dengan pakaian yang sudah kamu miliki di lemari',
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'AI Fitly akan menganalisis keserasian warna, gaya, dan cuaca jika ${product.name} dipadukan dengan koleksi lemarimu.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryText, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TryWithWardrobeScreen(product: product),
                              ),
                            );
                          },
                          icon: const Icon(Icons.auto_awesome, size: 16, color: AppColors.primaryPurple),
                          label: Text(
                            'Try With My Wardrobe',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryPurple),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LiveFittingMirrorScreen(product: product),
                            ),
                          );
                        },
                        icon: const Icon(Icons.view_in_ar_rounded, color: AppColors.primaryPurple),
                        tooltip: 'Live Preview (AR)',
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryPurpleLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Complete The Look Section (Cross-selling)
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Complete The Look',
                      style: GoogleFonts.fraunces(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      'Kombinasi Rekomendasi AI',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: appState.products.where((p) => p.id != product.id).take(4).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, idx) {
                      final item = appState.products.where((p) => p.id != product.id).toList()[idx];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: item),
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                                child: Image.network(
                                  item.image,
                                  height: 90,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      item.formattedPrice,
                                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Sticky Bottom Conversion Hierarchy Bar
      // Buy Now (Primary) > Add to Cart (Secondary) > Try With My Wardrobe (Supporting)
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Supporting Action: Try With My Wardrobe
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TryWithWardrobeScreen(product: product),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.softSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.checkroom_rounded, color: AppColors.primaryPurple, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      'Try In Wardrobe',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Secondary Commerce Action: Add to Cart
            InkWell(
              onTap: () {
                appState.addToCart(product, _selectedSize, _selectedColor);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} (Size $_selectedSize) ditambahkan!'),
                    backgroundColor: AppColors.primaryPurpleDark,
                    action: SnackBarAction(
                      label: 'Lihat Keranjang',
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_shopping_cart_rounded, color: AppColors.primaryPurple, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      'Keranjang',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Primary Commerce Action: Buy Now (Dominates visually)
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    appState.addToCart(product, _selectedSize, _selectedColor);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Beli Sekarang',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryText),
            ),
          ),
        ],
      ),
    );
  }
}
