import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'ai_recommendation_screen.dart';

class AIAlternativeLooksScreen extends StatelessWidget {
  const AIAlternativeLooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alternatives = [
      {
        'title': 'Urban Street',
        'match': 92,
        'image': 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600&auto=format&fit=crop&q=80',
        'items': ['Vintage Denim Jacket (Kita Apparel)', 'Black Heavyweight Hoodie (Owned)', 'White Canvas Sneakers (Owned)'],
        'price': 'Rp245.000',
        'vibe': 'Layered streetwear look with vintage denim texture',
      },
      {
        'title': 'Dark Minimal',
        'match': 89,
        'image': 'https://images.unsplash.com/photo-1516826957135-700dedea698c?w=600&auto=format&fit=crop&q=80',
        'items': ['Oversized Black Tee (Localwear)', 'Cream Tailored Trousers (Owned)', 'Silver Cuban Chain (Owned)'],
        'price': 'Rp129.000',
        'vibe': 'Monochrome high-contrast aesthetic with understated accessories',
      },
      {
        'title': 'Clean Casual',
        'match': 86,
        'image': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=600&auto=format&fit=crop&q=80',
        'items': ['Minimalist Linen Shirt (Ruang Basic)', 'Relaxed Denim Jeans (Owned)', 'White Canvas Sneakers (Owned)'],
        'price': 'Rp175.000',
        'vibe': 'Effortless resort-casual look in warm natural tones',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Other looks for you',
          style: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              'Alternative Outfits',
              style: GoogleFonts.fraunces(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Select any alternative look that matches your mood today.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 20),

            ...alternatives.map((alt) {
              final title = alt['title'] as String;
              final match = alt['match'] as int;
              final image = alt['image'] as String;
              final items = alt['items'] as List<String>;
              final price = alt['price'] as String;
              final vibe = alt['vibe'] as String;

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                          child: Image.network(
                            image,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.auto_awesome, size: 12, color: AppColors.primaryGreen),
                                const SizedBox(width: 4),
                                Text(
                                  '$match% match',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                price,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vibe,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: AppColors.border),
                          const SizedBox(height: 10),
                          ...items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline_rounded,
                                        size: 14, color: AppColors.primaryGreen),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AIRecommendationScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.softSurface,
                                foregroundColor: AppColors.primaryText,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: const BorderSide(color: AppColors.border),
                                ),
                              ),
                              child: Text(
                                'Select this look',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
