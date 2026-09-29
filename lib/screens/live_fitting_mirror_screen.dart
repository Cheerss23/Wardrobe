import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';

class LiveFittingMirrorScreen extends StatefulWidget {
  final ProductItem? product;

  const LiveFittingMirrorScreen({super.key, this.product});

  @override
  State<LiveFittingMirrorScreen> createState() => _LiveFittingMirrorScreenState();
}

class _LiveFittingMirrorScreenState extends State<LiveFittingMirrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Tops', 'Bottoms', 'Outerwear', 'Shoes'];

  bool _isFrontCamera = true;
  bool _isFlashOn = false;
  double _fitConfidence = 94.0;
  final String _recommendedSize = 'Size M';
  Timer? _metricsTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Subtle realistic fluctuation for live tracking HUD
    _metricsTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _fitConfidence = 93.5 + (timer.tick % 4) * 0.8;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _metricsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Viewport Simulation Background
          Positioned.fill(
            child: Container(
              color: const Color(0xFF141416),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle simulated live background person silhouette
                  Opacity(
                    opacity: 0.85,
                    child: Image.network(
                      appState.selectedAvatar.imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  ),

                  // AR Grid Scan Overlay Pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ARGridPainter(pulseValue: _pulseAnimation.value),
                    ),
                  ),

                  // AR Body Tracking Target Bounds
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 280,
                      height: 480,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryGreen.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Stack(
                        children: [
                          // 4 Corner Brackets
                          Positioned(
                            top: 0,
                            left: 0,
                            child: _CornerBracket(isTop: true, isLeft: true),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: _CornerBracket(isTop: true, isLeft: false),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: _CornerBracket(isTop: false, isLeft: true),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: _CornerBracket(isTop: false, isLeft: false),
                          ),

                          // Live Body Tracking Keypoints
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _TrackingNode(label: 'Head / Posture'),
                                _TrackingNode(label: 'Shoulder Span: 44cm'),
                                _TrackingNode(label: 'Waist Alignment: 78cm'),
                                _TrackingNode(label: 'Hip & Inseam'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Top Controls & AR Status Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // AR Live Pulsing Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryGreen.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'AR LIVE MIRROR',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Flip & Flash Controls
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: Icon(
                            _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white, size: 20),
                          onPressed: () => setState(() => _isFrontCamera = !_isFrontCamera),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Live Fitting Floating HUD (Real-time fit analytics)
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.accessibility_new_rounded, color: AppColors.primaryGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _recommendedSize,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${_fitConfidence.toStringAsFixed(1)}% Match',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Stand 1.5m away • Body tracking locked',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Controls: Category selector, Garment cards & Snapshot CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 14, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Selector Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: _categories.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final name = entry.value;
                        final isSel = idx == _selectedCategoryIndex;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => _selectedCategoryIndex = idx),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primaryGreen : Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                name,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Garment Carousel for selected category
                  SizedBox(
                    height: 80,
                    child: _buildGarmentCarousel(appState),
                  ),
                  const SizedBox(height: 18),

                  // Action buttons: Capture, Save Look, and Shop This Look
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Capture snapshot
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Foto AR tersimpan ke galeri look!'),
                                backgroundColor: AppColors.primaryPurpleDark,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 22),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.18),
                            padding: const EdgeInsets.all(12),
                          ),
                          tooltip: 'Capture',
                        ),
                        const SizedBox(width: 8),

                        // Save Look
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Look tersimpan ke wishlist!'),
                                backgroundColor: AppColors.primaryPurpleDark,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 22),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.18),
                            padding: const EdgeInsets.all(12),
                          ),
                          tooltip: 'Save Look',
                        ),
                        const SizedBox(width: 8),

                        // Primary Action: Shop This Look (Commerce CTA)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final activeItem = widget.product ??
                                  (appState.activeTryOnGarments.isNotEmpty
                                      ? appState.activeTryOnGarments.first
                                      : appState.products[0]);
                              appState.addToCart(activeItem, 'L', 'Default');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                            label: Text(
                              'Shop This Look',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGarmentCarousel(AppState appState) {
    final cat = _categories[_selectedCategoryIndex];
    final items = appState.products.where((p) => p.category == cat).toList();

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No pieces available in $cat',
          style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = appState.activeTryOnGarments.any((g) => g.id == item.id);

        return GestureDetector(
          onTap: () {
            appState.setTryOnGarment(item);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Switched to ${item.name} in AR Live Mirror!'),
                duration: const Duration(milliseconds: 1200),
                backgroundColor: AppColors.primaryGreen,
              ),
            );
          },
          child: Container(
            width: 180,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryGreen.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : Colors.white.withValues(alpha: 0.2),
                width: isSelected ? 1.8 : 1.0,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.formattedPrice,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isSelected ? AppColors.primaryGreen : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrackingNode extends StatelessWidget {
  final String label;
  const _TrackingNode({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerBracket({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: AppColors.primaryGreen, width: 3) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: AppColors.primaryGreen, width: 3) : BorderSide.none,
          left: isLeft ? const BorderSide(color: AppColors.primaryGreen, width: 3) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: AppColors.primaryGreen, width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}

class _ARGridPainter extends CustomPainter {
  final double pulseValue;
  _ARGridPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withValues(alpha: 0.04 * pulseValue)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ARGridPainter oldDelegate) =>
      oldDelegate.pulseValue != pulseValue;
}
