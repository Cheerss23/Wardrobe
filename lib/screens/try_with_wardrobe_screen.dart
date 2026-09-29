import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'live_fitting_mirror_screen.dart';
import 'try_on_processing_screen.dart';

class TryWithWardrobeScreen extends StatefulWidget {
  final ProductItem product;
  final WardrobePiece? preselectedWardrobeItem;

  const TryWithWardrobeScreen({
    super.key,
    required this.product,
    this.preselectedWardrobeItem,
  });

  @override
  State<TryWithWardrobeScreen> createState() => _TryWithWardrobeScreenState();
}

class _TryWithWardrobeScreenState extends State<TryWithWardrobeScreen> {
  final Set<String> _selectedWardrobeIds = {};
  String _selectedOccasion = 'Campus';
  final List<String> _occasions = ['Campus', 'Office', 'Date', 'Hangout', 'Daily'];

  bool _acceptedAiSuggestion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      setState(() {
        if (widget.preselectedWardrobeItem != null) {
          _selectedWardrobeIds.add(widget.preselectedWardrobeItem!.id);
        } else {
          // Pre-select complimentary items as defaults: White T-Shirt, Black Straight Pants, White Sneakers
          for (final piece in appState.wardrobe) {
            final name = piece.name.toLowerCase();
            if (name.contains('white oversized') ||
                name.contains('white t-shirt') ||
                name.contains('black straight') ||
                name.contains('white sneaker')) {
              _selectedWardrobeIds.add(piece.id);
            }
          }
        }
      });
    });
  }

  void _toggleItemSelection(WardrobePiece piece) {
    setState(() {
      if (_selectedWardrobeIds.contains(piece.id)) {
        _selectedWardrobeIds.remove(piece.id);
      } else {
        // Enforce 1 item per category (except accessories can have more)
        if (piece.category != 'Accessories') {
          final appState = Provider.of<AppState>(context, listen: false);
          final sameCatPieceIds = appState.wardrobe
              .where((w) => w.category == piece.category && _selectedWardrobeIds.contains(w.id))
              .map((w) => w.id)
              .toList();
          for (final id in sameCatPieceIds) {
            _selectedWardrobeIds.remove(id);
          }
        }
        _selectedWardrobeIds.add(piece.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedPieces = appState.wardrobe.where((w) => _selectedWardrobeIds.contains(w.id)).toList();

    // AI Outfit Compatibility Calculation
    final compatibility = appState.calculateOutfitCompatibility(
      newProduct: widget.product,
      selectedWardrobe: selectedPieces,
      occasion: _selectedOccasion,
    );

    final int matchScore = compatibility['score'] as int? ?? 94;
    final List<String> reasons = (compatibility['reasons'] as List<String>?) ?? [];
    final String? aiSuggestion = compatibility['suggestion'] as String?;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete Your Look',
              style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            Text(
              'Choose items you already own',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_in_ar_rounded, color: AppColors.primaryPurple),
            tooltip: 'Live Preview (AR)',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LiveFittingMirrorScreen(product: widget.product),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. NEW PRODUCT PINNED CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.image,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurpleLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'NEW PRODUCT TO TRY',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryPurple,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              widget.product.formattedPrice,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.star_rounded, size: 14, color: AppColors.ratingAmber),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.product.rating}',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${widget.product.badgeLabel ?? "94% AI Match"}',
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 2. LIVE "YOUR OUTFIT" COMBINATION PILL STRIP
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Outfit',
                        style: GoogleFonts.fraunces(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurpleLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${selectedPieces.length + 1} items combined',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Selected Wardrobe Items
                      ...selectedPieces.map((p) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primaryGreen),
                                const SizedBox(width: 4),
                                Text(
                                  p.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      // Plus sign
                      const Text('+', style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
                      // New Product
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurpleLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primaryPurple),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars_rounded, size: 14, color: AppColors.primaryPurple),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.name,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 3. AI OUTFIT COMPATIBILITY REPORT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              gradient: AppColors.purpleAiGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Outfit Compatibility',
                            style: GoogleFonts.fraunces(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurpleLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '$matchScore% Match',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Occasion Selector Pill Row
                  Row(
                    children: [
                      Text(
                        'Occasion: ',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _occasions.map((occ) {
                              final isSelected = _selectedOccasion == occ;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                  label: Text(occ),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    if (val) setState(() => _selectedOccasion = occ);
                                  },
                                  selectedColor: AppColors.primaryPurple,
                                  backgroundColor: AppColors.background,
                                  labelStyle: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : AppColors.primaryText,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  showCheckmark: false,
                                  padding: EdgeInsets.zero,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),

                  // Reasons List
                  Text(
                    'Why this outfit works:',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...reasons.map(
                    (reason) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_rounded, color: AppColors.primaryGreen, size: 16),
                          const SizedBox(width: 8),
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

                  // Optional AI Suggestions Card
                  if (aiSuggestion != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFD566)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_rounded, size: 16, color: Color(0xFFD48806)),
                              const SizedBox(width: 6),
                              Text(
                                'AI Suggestion',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD48806),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            aiSuggestion,
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryText),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _acceptedAiSuggestion = true;
                                    // Swap black sneakers with white sneakers if present
                                    final blackShoes = appState.wardrobe.where((w) => w.id == 'w_shoe2').toList();
                                    final whiteShoes = appState.wardrobe.where((w) => w.id == 'w_shoe1').toList();
                                    if (blackShoes.isNotEmpty) _selectedWardrobeIds.remove(blackShoes.first.id);
                                    if (whiteShoes.isNotEmpty) _selectedWardrobeIds.add(whiteShoes.first.id);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Saran AI diterima: Menggunakan White Sneakers!'),
                                      backgroundColor: AppColors.primaryPurpleDark,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPurple,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  _acceptedAiSuggestion ? 'Suggestion Applied' : 'Accept Suggestion',
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Mempertahankan outfit pilihanmu.'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.border),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Keep My Outfit',
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 4. CATEGORIZED WARDROBE SELECTION INTERFACE
            Text(
              'My Wardrobe Pieces',
              style: GoogleFonts.fraunces(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to select or unselect items from your wardrobe to try together',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 14),

            _buildCategorySection('TOPS', appState.getWardrobeByCategory('Tops')),
            const SizedBox(height: 16),
            _buildCategorySection('BOTTOMS', appState.getWardrobeByCategory('Bottoms')),
            const SizedBox(height: 16),
            _buildCategorySection('SHOES', appState.getWardrobeByCategory('Shoes')),
            const SizedBox(height: 16),
            _buildCategorySection('ACCESSORIES', appState.getWardrobeByCategory('Accessories')),

            const SizedBox(height: 100), // Spacing for bottom bar
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Supporting Live AR shortcut
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveFittingMirrorScreen(product: widget.product),
                    ),
                  );
                },
                icon: const Icon(Icons.view_in_ar_rounded, size: 18, color: AppColors.primaryPurple),
                label: Text(
                  'Live AR',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryPurple,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryPurple),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(width: 10),

              // Primary Action: Try This Outfit (Triggers virtual Try-On generation)
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TryOnProcessingScreen(
                            newProduct: widget.product,
                            selectedWardrobe: selectedPieces,
                            occasion: _selectedOccasion,
                            fitScore: matchScore,
                            reasons: reasons,
                          ),
                        ),
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
                        const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Try This Outfit',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildCategorySection(String title, List<WardrobePiece> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.secondaryText,
                letterSpacing: 0.6,
              ),
            ),
            Text(
              '${items.where((i) => _selectedWardrobeIds.contains(i.id)).length} selected',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, idx) {
              final piece = items[idx];
              final isSelected = _selectedWardrobeIds.contains(piece.id);

              return InkWell(
                onTap: () => _toggleItemSelection(piece),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryPurple : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryPurple.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              piece.image,
                              height: 85,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Text(
                              piece.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? AppColors.primaryPurple : AppColors.primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Checkmark Indicator
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryPurple : Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSelected ? Icons.check : Icons.add,
                            size: 12,
                            color: Colors.white,
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
    );
  }
}
