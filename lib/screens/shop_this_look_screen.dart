import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';
import 'cart_screen.dart';
import 'try_on_studio_screen.dart';
import 'product_detail_screen.dart';

class ShopThisLookScreen extends StatefulWidget {
  final OutfitRecommendation outfit;

  const ShopThisLookScreen({
    super.key,
    required this.outfit,
  });

  @override
  State<ShopThisLookScreen> createState() => _ShopThisLookScreenState();
}

class _ShopThisLookScreenState extends State<ShopThisLookScreen> {
  late Set<String> _selectedProductIds;
  final Map<String, String> _selectedSizes = {};

  @override
  void initState() {
    super.initState();
    // Default: select all items that are not already owned
    _selectedProductIds = widget.outfit.items
        .where((item) => !item.isOwned)
        .map((item) => item.id)
        .toSet();

    for (final item in widget.outfit.items) {
      _selectedSizes[item.id] = item.sizes.first;
    }
  }

  int get _selectedItemsSubtotal {
    int total = 0;
    for (final item in widget.outfit.items) {
      if (_selectedProductIds.contains(item.id)) {
        total += item.price;
      }
    }
    return total;
  }

  int get _bundleDiscount {
    // If all buyable items selected, apply 10% bundle discount
    final buyableCount = widget.outfit.items.where((i) => !i.isOwned).length;
    if (_selectedProductIds.length >= buyableCount && buyableCount > 1) {
      return (_selectedItemsSubtotal * widget.outfit.bundleDiscountPercentage) ~/ 100;
    }
    return 0;
  }

  int get _finalTotal => _selectedItemsSubtotal - _bundleDiscount;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final outfit = widget.outfit;
    final isSaved = appState.isOutfitSaved(outfit.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Shop This Look',
          style: GoogleFonts.fraunces(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? AppColors.primaryPurple : AppColors.primaryText,
            ),
            tooltip: 'Simpan Outfit',
            onPressed: () => appState.toggleSaveOutfit(outfit.id),
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
          // Hero Outfit Showcase Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
                        child: AspectRatio(
                          aspectRatio: 1.25,
                          child: Image.network(
                            outfit.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.softSurface,
                              child: const Icon(Icons.image, size: 48, color: AppColors.tertiaryText),
                            ),
                          ),
                        ),
                      ),
                      // AI Match & Occasion Badges
                      Positioned(
                        top: 12,
                        left: 12,
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
                              const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${outfit.matchScore}% Match',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            outfit.occasion,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          outfit.title,
                          style: GoogleFonts.fraunces(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny_outlined, size: 15, color: AppColors.warning),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                outfit.weatherNote,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Why match reasons
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurpleLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_awesome, color: AppColors.primaryPurple, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Kenapa AI merekomendasikan look ini:',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: AppColors.primaryPurple,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ...outfit.whyMatchReasons.map(
                                (reason) => Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                          reason,
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
          ),

          // Items Selection Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item dalam Look ini (${outfit.items.length})',
                  style: GoogleFonts.fraunces(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  'Bisa pilih sebagian',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // Checklist of Outfit Items
          ...outfit.items.map((item) {
            final isOwned = item.isOwned;
            final isChecked = _selectedProductIds.contains(item.id);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOwned ? AppColors.softSurface.withValues(alpha: 0.6) : AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isChecked ? AppColors.primaryPurple.withValues(alpha: 0.5) : AppColors.border,
                    width: isChecked ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Checkbox or Owned Badge
                    if (!isOwned)
                      Checkbox(
                        value: isChecked,
                        activeColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedProductIds.add(item.id);
                            } else {
                              _selectedProductIds.remove(item.id);
                            }
                          });
                        },
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 16, color: AppColors.success),
                      ),

                    const SizedBox(width: 8),

                    // Thumbnail
                    GestureDetector(
                      onTap: () {
                        if (!isOwned) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: item),
                            ),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.image,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            color: AppColors.softSurface,
                            child: const Icon(Icons.image),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Item Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.brand,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              if (isOwned) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Sudah Dimiliki',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isOwned ? 'Gratis (Dari Lemari)' : item.formattedPrice,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isOwned ? AppColors.secondaryText : AppColors.primaryText,
                                ),
                              ),
                              // Size Picker for Buyable item
                              if (!isOwned)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.softSurface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedSizes[item.id] ?? item.sizes.first,
                                      isDense: true,
                                      iconSize: 16,
                                      items: item.sizes.map((s) {
                                        return DropdownMenuItem(
                                          value: s,
                                          child: Text(
                                            'Size $s',
                                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedSizes[item.id] = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Supporting Try-On Option Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurpleLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_enhance_rounded, color: AppColors.primaryPurple, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ragu dengan proporsinya?',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          'Lihat simulasi visual fitting di tubuhmu sebelum checkout.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      appState.startTryOnWithLook(widget.outfit.items);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TryOnStudioScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      side: const BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Try This Look',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Conversion Bar
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Breakdown Line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total (${_selectedProductIds.length} item dipilih)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Rp${(_finalTotal ~/ 1000)}.000',
                          style: GoogleFonts.fraunces(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        if (_bundleDiscount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.discountBadge,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Hemat ${_bundleDiscount ~/ 1000}K',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                // Add All to Cart Button (Secondary)
                OutlinedButton.icon(
                  onPressed: _selectedProductIds.isEmpty
                      ? null
                      : () {
                          for (final item in widget.outfit.items) {
                            if (_selectedProductIds.contains(item.id)) {
                              appState.addToCart(
                                item,
                                _selectedSizes[item.id] ?? item.sizes.first,
                                item.colors.first,
                              );
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua item outfit telah masuk ke keranjang!'),
                              backgroundColor: AppColors.primaryPurpleDark,
                            ),
                          );
                        },
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                  label: const Text('Add All'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Primary Conversion CTA: Buy Complete Look
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedProductIds.isEmpty
                    ? null
                    : () {
                        // Add selected items to cart then navigate directly to Checkout
                        for (final item in widget.outfit.items) {
                          if (_selectedProductIds.contains(item.id)) {
                            appState.addToCart(
                              item,
                              _selectedSizes[item.id] ?? item.sizes.first,
                              item.colors.first,
                            );
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Beli Sekarang (Checkout)',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
}
