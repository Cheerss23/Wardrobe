import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'try_on_result_screen.dart';

class TryOnProcessingScreen extends StatefulWidget {
  final ProductItem? newProduct;
  final List<WardrobePiece> selectedWardrobe;
  final String occasion;
  final int fitScore;
  final List<String> reasons;

  const TryOnProcessingScreen({
    super.key,
    this.newProduct,
    this.selectedWardrobe = const [],
    this.occasion = 'Campus',
    this.fitScore = 94,
    this.reasons = const [],
  });

  @override
  State<TryOnProcessingScreen> createState() => _TryOnProcessingScreenState();
}

class _TryOnProcessingScreenState extends State<TryOnProcessingScreen> {
  int _currentStep = 0;
  Timer? _timer;

  late final List<String> _processingSteps;

  @override
  void initState() {
    super.initState();
    final productName = widget.newProduct?.name ?? 'garment';
    _processingSteps = [
      'Analyzing body posture & silhouette keypoints',
      'Fitting "$productName" with selected wardrobe pieces',
      'Simulating fabric drape, texture & realistic lighting',
      'Rendering photorealistic look on your avatar',
    ];
    _startGeneration();
  }

  void _startGeneration() {
    _timer = Timer.periodic(const Duration(milliseconds: 850), (timer) {
      if (mounted) {
        setState(() {
          if (_currentStep < _processingSteps.length - 1) {
            _currentStep++;
          } else {
            _timer?.cancel();
            _completeAndNavigate();
          }
        });
      }
    });
  }

  void _completeAndNavigate() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);

      final targetProduct = widget.newProduct ??
          appState.products.firstWhere((p) => p.id == 'p_jacket', orElse: () => appState.products[0]);

      final targetWardrobe = widget.selectedWardrobe.isNotEmpty
          ? widget.selectedWardrobe
          : [appState.wardrobe[0], appState.wardrobe[3], appState.wardrobe[6]];

      final avatar = appState.selectedAvatar;

      // Realistic composite image representing user wearing the new product + wardrobe
      final compositeImageUrl = avatar.gender == 'Female'
          ? 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop&q=80'
          : 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&auto=format&fit=crop&q=80';

      final result = TryOnResult(
        id: 'tryon_${DateTime.now().millisecondsSinceEpoch}',
        title: '${targetProduct.name} Look',
        originalImageUrl: avatar.imageUrl,
        resultImageUrl: compositeImageUrl,
        garments: [targetProduct],
        newProduct: targetProduct,
        ownedPieces: targetWardrobe,
        fitScore: widget.fitScore,
        recommendedSize: 'Size ${avatar.recommendedSize}',
        date: 'Today, 29 Sep',
        occasion: widget.occasion,
        style: 'Smart Casual',
        weather: '28°C Sunny',
        bodyNotes:
            'Calibrated for ${avatar.bodyShape} frame (${avatar.height}). Natural drape around shoulders with proportional waist drop.',
        compatibilityReasons: widget.reasons.isNotEmpty
            ? widget.reasons
            : const [
                'Color combination works',
                'Matches your preferred style',
                'Suitable for today\'s weather',
                'Matches your wardrobe',
                'Suitable for your selected occasion',
              ],
      );

      appState.addTryOnResult(result);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TryOnResultScreen(result: result),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep + 1) / _processingSteps.length;
    final appState = Provider.of<AppState>(context);
    final avatar = appState.selectedAvatar;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Visual Combination Montage: User Photo + New Product + Wardrobe
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // User Photo
                  Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryPurple, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(avatar.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your Photo',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('+', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                  ),

                  // New Product
                  Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryPurple, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(widget.newProduct?.image ?? appState.products[0].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'New Item',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('+', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                  ),

                  // Wardrobe Items (stacked preview)
                  Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.selectedWardrobe.isNotEmpty
                                  ? widget.selectedWardrobe.first.image
                                  : appState.wardrobe[0].image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Wardrobe',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Animated Pulsing Orb
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.purpleAiGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.35),
                      blurRadius: 30,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'AI Is Generating Your Look',
                style: GoogleFonts.fraunces(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Combining user avatar with new product and selected wardrobe clothing.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Step Progress & Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${_currentStep + 1} of ${_processingSteps.length}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppColors.primaryPurpleLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _processingSteps[_currentStep],
                        key: ValueKey<int>(_currentStep),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Text(
                'AI Virtual Fitting Assistant • Fitly Commerce',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.tertiaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
