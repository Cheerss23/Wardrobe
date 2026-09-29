import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'product_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = const [
    'All',
    'Men',
    'Women',
    'Tops',
    'Bottoms',
    'Outerwear',
    'Shoes',
    'Accessories',
    'Bags',
  ];

  final List<String> styles = const [
    'All',
    'Casual',
    'Minimal',
    'Streetwear',
    'Smart Casual',
    'Korean Style',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortSheet(BuildContext context, AppState appState) {
    final sortOptions = [
      'AI Match',
      'Popular',
      'Price: Low to High',
      'Price: High to Low',
      'Rating',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Urutkan Produk',
                      style: GoogleFonts.fraunces(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...sortOptions.map((opt) {
                  final isSelected = appState.selectedSort == opt;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      opt,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primaryPurple : AppColors.primaryText,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primaryPurple)
                        : null,
                    onTap: () {
                      appState.setSortOption(opt);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context, AppState appState) {
    RangeValues tempRange = appState.priceRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Katalog',
                        style: GoogleFonts.fraunces(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          appState.resetDiscoverFilters();
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          'Reset',
                          style: GoogleFonts.inter(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),
                  Text(
                    'Rentang Harga',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp${(tempRange.start ~/ 1000)}.000',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      Text(
                        'Rp${(tempRange.end ~/ 1000)}.000',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: tempRange,
                    min: 50000,
                    max: 1000000,
                    divisions: 19,
                    activeColor: AppColors.primaryPurple,
                    inactiveColor: AppColors.border,
                    onChanged: (vals) {
                      setModalState(() {
                        tempRange = vals;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gaya Fashion',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: styles.map((st) {
                      final isSel = appState.selectedDiscoverStyle == st;
                      return ChoiceChip(
                        label: Text(st),
                        selected: isSel,
                        onSelected: (val) {
                          appState.setStyleFilter(val ? st : 'All');
                          setModalState(() {});
                        },
                        selectedColor: AppColors.primaryPurpleLight,
                        labelStyle: GoogleFonts.inter(
                          color: isSel ? AppColors.primaryPurple : AppColors.secondaryText,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: isSel ? AppColors.primaryPurple : AppColors.border,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        appState.setPriceRange(tempRange);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Terapkan Filter',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
    final items = appState.filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Search & Filter Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              color: AppColors.background,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => appState.setDiscoverSearchQuery(val),
                            decoration: InputDecoration(
                              hintText: 'Cari baju, celana, brand, gaya...',
                              hintStyle: GoogleFonts.inter(
                                color: AppColors.tertiaryText,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.primaryPurple,
                                size: 22,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        appState.setDiscoverSearchQuery('');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 13),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filter Button
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune_rounded, color: AppColors.primaryText),
                          tooltip: 'Filter',
                          onPressed: () => _showFilterSheet(context, appState),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Sort Button
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurpleLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.swap_vert_rounded, color: AppColors.primaryPurple),
                          tooltip: 'Sort',
                          onPressed: () => _showSortSheet(context, appState),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Category Horizontal Pills
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        final cat = categories[idx];
                        final isSelected = appState.selectedCategory == cat;
                        return InkWell(
                          onTap: () => appState.setCategory(cat),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryPurple : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryPurple : AppColors.border,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? Colors.white : AppColors.primaryText,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Active Filter Summary Line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menampilkan ${items.length} produk',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryPurple),
                      const SizedBox(width: 4),
                      Text(
                        'Urutan: ${appState.selectedSort}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Products Grid
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryPurpleLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada produk yang cocok',
                            style: GoogleFonts.fraunces(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Coba ubah kata kunci atau reset filter',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              _searchController.clear();
                              appState.resetDiscoverFilters();
                            },
                            child: const Text('Reset Filter'),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final product = items[index];
                        final isSaved = appState.isSaved(product.id);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image with Match & Wishlist Badges
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                                      child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            color: AppColors.softSurface,
                                            child: const Icon(Icons.image, color: AppColors.tertiaryText),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // AI Match Badge
                                    if (product.matchPercentage != null)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryPurple,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.auto_awesome, color: Colors.white, size: 10),
                                              const SizedBox(width: 3),
                                              Text(
                                                '${product.matchPercentage}%',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    // Discount Badge
                                    if (product.discountPercentage != null)
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.discountBadge,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '-${product.discountPercentage}%',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    // Wishlist Toggle
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          iconSize: 18,
                                          padding: const EdgeInsets.all(6),
                                          constraints: const BoxConstraints(),
                                          icon: Icon(
                                            isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                            color: isSaved ? AppColors.discountBadge : AppColors.secondaryText,
                                          ),
                                          onPressed: () => appState.toggleSave(product.id),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Product Info & CTA
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Brand & Category
                                        Row(
                                          children: [
                                            Text(
                                              product.brand.toUpperCase(),
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primaryPurple,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text('•', style: TextStyle(color: AppColors.tertiaryText, fontSize: 10)),
                                            const SizedBox(width: 4),
                                            Text(
                                              product.category,
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        // Product Title
                                        Text(
                                          product.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryText,
                                            height: 1.2,
                                          ),
                                        ),
                                        const Spacer(),
                                        // Rating & Sold
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${product.rating}',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '| ${product.soldCount}',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        // Prices & Quick Add
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.formattedPrice,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.primaryText,
                                                  ),
                                                ),
                                                if (product.formattedOriginalPrice != null)
                                                  Text(
                                                    product.formattedOriginalPrice!,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10,
                                                      decoration: TextDecoration.lineThrough,
                                                      color: AppColors.tertiaryText,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            // Quick Add Cart Button
                                            InkWell(
                                              onTap: () {
                                                appState.addToCart(
                                                  product,
                                                  product.sizes.first,
                                                  product.colors.first,
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('${product.name} ditambahkan ke keranjang!'),
                                                    duration: const Duration(seconds: 1),
                                                    backgroundColor: AppColors.primaryPurpleDark,
                                                  ),
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryPurpleLight,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.add_shopping_cart_rounded,
                                                  color: AppColors.primaryPurple,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
    );
  }
}
