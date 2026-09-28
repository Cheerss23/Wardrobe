import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'ai_generating_screen.dart';
import 'ai_style_profile_screen.dart';

class AIStartScreen extends StatelessWidget {
  const AIStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final List<String> occasions = ['Campus', 'Hangout', 'Date', 'Office', 'Formal', 'Everyday'];
    final List<String> styles = ['Casual', 'Streetwear', 'Minimal', 'Smart Casual', 'Classic'];
    final List<String> budgets = ['Under Rp200K', 'Rp200K–500K', 'Rp500K–1M', 'Flexible'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'AI Stylist',
          style: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryGreen),
            tooltip: 'Style Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIStyleProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              'Create a look that fits your day.',
              style: GoogleFonts.fraunces(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Specify your occasion and preferences for AI personalization.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 24),

            // Section 1: Occasion
            _buildSectionHeader('Occasion'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: occasions.map((occ) {
                final isSelected = appState.selectedOccasion == occ;
                return ChoiceChip(
                  label: Text(occ),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) appState.setOccasion(occ);
                  },
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: AppColors.card,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.primaryText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryGreen : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Section 2: Style
            _buildSectionHeader('Style'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: styles.map((st) {
                final isSelected = appState.selectedStyle == st;
                return ChoiceChip(
                  label: Text(st),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) appState.setStyle(st);
                  },
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: AppColors.card,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.primaryText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryGreen : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Section 3: Budget
            _buildSectionHeader('Budget'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: budgets.map((bg) {
                final isSelected = appState.selectedBudget == bg;
                return ChoiceChip(
                  label: Text(bg),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) appState.setBudget(bg);
                  },
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: AppColors.card,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.primaryText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryGreen : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Section 4: Personalization Checkboxes
            _buildSectionHeader('Personalization'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: appState.useWardrobePreference,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (val) => appState.toggleWardrobePref(val ?? true),
                    title: Text(
                      'My wardrobe',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    subtitle: Text(
                      'Prioritize pieces you already own',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  CheckboxListTile(
                    value: appState.usePurchaseHistoryPreference,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (val) => appState.toggleHistoryPref(val ?? true),
                    title: Text(
                      'Purchase history',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    subtitle: Text(
                      'Match with past favorite styles & fits',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // CTA Button: Generate my outfit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIGeneratingScreen()),
                  );
                },
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: Text(
                  'Generate my outfit',
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
            const SizedBox(height: 12),

            // Style Profile Quick Button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIStyleProfileScreen()),
                  );
                },
                icon: const Icon(Icons.tune_rounded, size: 16, color: AppColors.primaryGreen),
                label: Text(
                  'View AI Style Profile Data',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.fraunces(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
    );
  }
}
