import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'outfit_match_screen.dart';

class StylistAssistantScreen extends StatefulWidget {
  const StylistAssistantScreen({super.key});

  @override
  State<StylistAssistantScreen> createState() => _StylistAssistantScreenState();
}

class _StylistAssistantScreenState extends State<StylistAssistantScreen> {
  String selectedOccasion = 'Campus';
  String selectedVibe = 'Casual';
  String selectedBudget = 'Under Rp200K';

  bool useWardrobe = true;
  bool useHistory = true;
  bool usePhoto = false;

  final occasions = ['Campus', 'Hangout', 'Date', 'Office', 'Formal', 'Everyday'];
  final vibes = ['Casual', 'Streetwear', 'Minimal', 'Smart Casual', 'Formal', 'Trendy'];
  final budgets = ['Under Rp200K', 'Rp200K-500K', 'Rp500K+'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Stylist'),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Text(
            "Let's create your look",
            style: GoogleFonts.bodoniModa(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Tell me where you're headed, and I'll curate a bespoke outfit blending your personal wardrobe and smart picks.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // Generate Look CTA
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OutfitMatchScreen()),
              );
            },
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            label: const Text('Create My Look'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
