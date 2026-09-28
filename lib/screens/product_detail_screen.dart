import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductItem? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String selectedSize;
  late String selectedColor;

  @override
  void initState() {
    super.initState();
    final p = widget.product ?? _defaultProduct;
    selectedSize = p.sizes.isNotEmpty ? p.sizes[1] : 'M';
    selectedColor = 'Black';
  }

  static const ProductItem _defaultProduct = ProductItem(
    id: 'p1',
    name: 'Oversized Black Tee',
    seller: 'Localwear',
    price: 129000,
    formattedPrice: 'Rp129.000',
    image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
    category: 'Tops',
    rating: 4.8,
    badgeLabel: 'Matches your style',
    matchReason: 'Matches your preferred casual style & relaxed silhouette.',
    matchPercentage: 94,
    description: 'Heavyweight 24s combed cotton with relaxed drop shoulder fit. Handcrafted by Localwear UMKM Bandung.',
    sizes: ['S', 'M', 'L', 'XL'],
  );

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final product = widget.product ?? appState.products[0];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              product.seller,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
            Text(
              'UMKM Partner',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              appState.isSaved(product.id)
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: appState.isSaved(product.id)
                  ? AppColors.primaryGreen
                  : AppColors.primaryText,
            ),
            onPressed: () => appState.toggleSave(product.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              appState.addToCart(product, selectedSize, selectedColor);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added ${product.name} to Cart!'),
                  backgroundColor: AppColors.primaryGreen,
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'View Cart',
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
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            label: Text(
              'Add to cart • ${product.formattedPrice}',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Product Main Image Card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Image.network(
                product.image,
                height: 320,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title & Seller Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.fraunces(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Seller: ${product.seller}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                        Text(
                          ' ${product.rating}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                product.formattedPrice,
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Why AI Picked This Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 18, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Text(
                      'Why AI picked this',
                      style: GoogleFonts.fraunces(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildAIPickReason('Matches your style'),
                _buildAIPickReason('Works with your wardrobe (White Sneakers & Denim)'),
                _buildAIPickReason('Fits your budget (Under Rp200K target)'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Available Sizes Selection
          Text(
            'Available Sizes',
            style: GoogleFonts.fraunces(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: product.sizes.map((sz) {
              final isSelected = selectedSize == sz;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = sz;
                  });
                },
                child: Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryGreen : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      sz,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.primaryText,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Description Section
          Text(
            'Description',
            style: GoogleFonts.fraunces(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAIPickReason(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
