import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'ai_recommendation_screen.dart';

class AIGeneratingScreen extends StatefulWidget {
  const AIGeneratingScreen({super.key});

  @override
  State<AIGeneratingScreen> createState() => _AIGeneratingScreenState();
}

class _AIGeneratingScreenState extends State<AIGeneratingScreen> {
  int currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (mounted) {
        setState(() {
          if (currentStep < 3) {
            currentStep++;
          } else {
            _timer?.cancel();
            // Automatically navigate to recommendation screen after loading
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AIRecommendationScreen()),
                );
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'text': 'Reading your wardrobe', 'done': currentStep > 0},
      {'text': 'Reviewing purchase history', 'done': currentStep > 1},
      {'text': 'Matching UMKM products', 'done': currentStep > 2},
      {'text': 'Checking colors & budget', 'done': currentStep >= 3},
    ];

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
              // AI Visual Pulsing Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Building your look',
                style: GoogleFonts.fraunces(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Finding pieces that work together.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Steps List Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    final isDone = step['done'] as bool;
                    final isCurrent = currentStep == index;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppColors.primaryGreen
                                  : (isCurrent
                                      ? AppColors.lightGreen
                                      : AppColors.softSurface),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                                  : (isCurrent
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primaryGreen,
                                          ),
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.secondaryText,
                                          ),
                                        )),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              step['text'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: (isDone || isCurrent)
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: (isDone || isCurrent)
                                    ? AppColors.primaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),
              // Skip / Force View CTA
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AIRecommendationScreen()),
                  );
                },
                child: Text(
                  'Skip to result →',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
