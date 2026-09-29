import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'live_fitting_mirror_screen.dart';
import 'try_on_processing_screen.dart';
import 'try_on_result_screen.dart';

class TryOnStudioScreen extends StatefulWidget {
  final ProductItem? initialProduct;

  const TryOnStudioScreen({super.key, this.initialProduct});

  @override
  State<TryOnStudioScreen> createState() => _TryOnStudioScreenState();
}

class _TryOnStudioScreenState extends State<TryOnStudioScreen> {
  final ImagePicker _picker = ImagePicker();

  // Mode 1: DIY State
  String _activeSourceTab = 'UMKM Store'; // 'UMKM Store' or 'My Wardrobe'
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Tops', 'Bottoms', 'Shoes', 'Outerwear'];

  // Mode 2: Guided AI State
  String _selectedOccasion = 'All';
  String _selectedStyle = 'All';
  final List<String> _occasions = ['All', 'Campus', 'Date', 'Hangout', 'Office', 'Everyday'];
  final List<String> _styles = ['All', 'Casual', 'Smart Casual', 'Streetwear', 'Minimal'];

  // Mode 3: Autopilot State
  OutfitRecommendation? _currentAutopilotLook;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.initializeTryOnDefaults();
      if (widget.initialProduct != null) {
        appState.setTryOnGarment(widget.initialProduct!);
      }
      setState(() {
        _currentAutopilotLook = appState.getDailyAutopilotOutfit();
      });
    });
  }

  Future<void> _pickUserImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (pickedFile != null && mounted) {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setCustomUserPhoto(pickedFile.path);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo uploaded! Calibrating body profile...'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}. Using sample model avatar instead.'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeGarments = appState.activeTryOnGarments;
    final currentMode = appState.activeStylingMode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Virtual Try-On Studio',
          style: GoogleFonts.fraunces(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            // Top Header: Title, Subtitle & AR Mirror Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Stylist & Try-On',
                        style: GoogleFonts.fraunces(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Susun sendiri, dipandu AI, atau biarkan AI tentukan semua',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                // AR Live Mirror Shortcut Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LiveFittingMirrorScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.view_in_ar_rounded, size: 16, color: Colors.white),
                  label: Text(
                    'Live AR',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Step 1: User Photo / Model Avatar Card
            _buildAvatarSection(appState),
            const SizedBox(height: 20),

            // Step 2: Styling Mode Selector Header & Tabs (3 Pilihan Utama)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 2: Metode Kurasi Outfit',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3-Option Segmented Styling Mode Switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.softSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildModeTab(
                    mode: StylingMode.diy,
                    currentMode: currentMode,
                    title: 'Susun Sendiri',
                    icon: Icons.tune_rounded,
                    onTap: () => appState.setStylingMode(StylingMode.diy),
                  ),
                  _buildModeTab(
                    mode: StylingMode.guided,
                    currentMode: currentMode,
                    title: 'Dipandu AI',
                    icon: Icons.filter_vintage_outlined,
                    onTap: () => appState.setStylingMode(StylingMode.guided),
                  ),
                  _buildModeTab(
                    mode: StylingMode.autopilot,
                    currentMode: currentMode,
                    title: 'AI Tentukan',
                    icon: Icons.auto_awesome_rounded,
                    onTap: () {
                      appState.setStylingMode(StylingMode.autopilot);
                      _currentAutopilotLook ??= appState.getDailyAutopilotOutfit();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Dynamic Body based on Selected Styling Mode
            if (currentMode == StylingMode.diy)
              _buildDiyMode(appState)
            else if (currentMode == StylingMode.guided)
              _buildGuidedMode(appState)
            else
              _buildAutopilotMode(appState),

            const SizedBox(height: 20),

            // Step 3: Active Selection Fit Tray & Primary Action
            _buildActiveFitTray(appState, activeGarments),
            const SizedBox(height: 24),

            // Past Try-On Looks Gallery Section
            if (appState.tryOnHistory.isNotEmpty)
              _buildHistoryGallery(appState),
          ],
        ),
      ),
    );
  }

  // Segmented Mode Tab Helper
  Widget _buildModeTab({
    required StylingMode mode,
    required StylingMode currentMode,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = mode == currentMode;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.primaryGreen : AppColors.secondaryText,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primaryGreen : AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 1: Avatar & Photo Calibration
  // ---------------------------------------------------------------------------
  Widget _buildAvatarSection(AppState appState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
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
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person_rounded, color: AppColors.primaryGreen, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Step 1: Foto Diri / Avatar Tubuh',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Calibrated',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Active Avatar Details & Photo
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: appState.customUserPhotoPath != null
                    ? Image.file(
                        File(appState.customUserPhotoPath!),
                        width: 75,
                        height: 95,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        appState.selectedAvatar.imageUrl,
                        width: 75,
                        height: 95,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.customUserPhotoPath != null
                          ? 'Foto Pengguna Pribadi'
                          : appState.selectedAvatar.name,
                      style: GoogleFonts.fraunces(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tinggi: ${appState.selectedAvatar.height} • Rekomendasi: Size ${appState.selectedAvatar.recommendedSize}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Profil Siluet: ${appState.selectedAvatar.bodyShape}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Camera & Upload Buttons
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _pickUserImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_rounded, size: 14),
                          label: const Text('Kamera'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                            foregroundColor: AppColors.primaryGreen,
                            side: const BorderSide(color: AppColors.primaryGreen),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => _pickUserImage(ImageSource.gallery),
                          icon: const Icon(Icons.upload_rounded, size: 14),
                          label: const Text('Galeri'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                            foregroundColor: AppColors.secondaryText,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Avatar Presets Selector Row
          Text(
            'Atau pilih model avatar tubuh:',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: appState.modelAvatars.map((avatar) {
                final isSelected = appState.customUserPhotoPath == null &&
                    appState.selectedAvatar.id == avatar.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => appState.selectAvatar(avatar),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.lightGreen : AppColors.softSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGreen : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(avatar.imageUrl),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            avatar.name.split(' ').first,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.primaryGreen : AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MODE 1: SUSUN SENDIRI (MANUAL DIY MIX & MATCH)
  // ---------------------------------------------------------------------------
  Widget _buildDiyMode(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Source Switcher (UMKM Store vs My Wardrobe)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _activeSourceTab = 'UMKM Store'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeSourceTab == 'UMKM Store' ? AppColors.lightGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Katalog UMKM',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _activeSourceTab == 'UMKM Store' ? AppColors.primaryGreen : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _activeSourceTab = 'My Wardrobe'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeSourceTab == 'My Wardrobe' ? AppColors.lightGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Lemari Digital Saya',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _activeSourceTab == 'My Wardrobe' ? AppColors.primaryGreen : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Category Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final isSel = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSel,
                  onSelected: (val) => setState(() => _selectedCategory = cat),
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: AppColors.card,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                    color: isSel ? Colors.white : AppColors.primaryText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: isSel ? AppColors.primaryGreen : AppColors.border),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Garments Grid
        _buildGarmentGrid(appState),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // MODE 2: DIPANDU AI (GUIDED BY OCCASION / STYLE / CATEGORY)
  // ---------------------------------------------------------------------------
  Widget _buildGuidedMode(AppState appState) {
    final filteredLooks = appState.getFilteredOutfits(
      occasion: _selectedOccasion,
      style: _selectedStyle,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Guidance Filter Header Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune_rounded, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Tentukan Kriteria Outfit Yang Kamu Inginkan:',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Occasion Selector
              Text('Pilih Acara (Occasion):', style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText)),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _occasions.map((occ) {
                    final isSel = _selectedOccasion == occ;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(occ),
                        selected: isSel,
                        onSelected: (val) => setState(() => _selectedOccasion = occ),
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: AppColors.softSurface,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel ? Colors.white : AppColors.primaryText,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: isSel ? AppColors.primaryGreen : Colors.transparent),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Style Vibe Selector
              Text('Pilih Gaya (Vibe):', style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText)),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _styles.map((st) {
                    final isSel = _selectedStyle == st;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(st),
                        selected: isSel,
                        onSelected: (val) => setState(() => _selectedStyle = st),
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: AppColors.softSurface,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel ? Colors.white : AppColors.primaryText,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: isSel ? AppColors.primaryGreen : Colors.transparent),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Section Title: Matched AI Looks
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rekomendasi AI Sesuai Pilihanmu',
              style: GoogleFonts.fraunces(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            Text(
              '${filteredLooks.length} looks',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (filteredLooks.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              'Tidak ada rekomendasi yang cocok dengan kombinasi ini. Coba pilih "All" pada acara atau gaya.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
            ),
          )
        else
          ...filteredLooks.map((look) => _buildGuidedLookCard(appState, look)),
      ],
    );
  }

  Widget _buildGuidedLookCard(AppState appState, OutfitRecommendation look) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
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
          // Header: Title, Occasion & AI Match Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      look.title,
                      style: GoogleFonts.fraunces(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      '${look.occasion} • ${look.styleVibe}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 12, color: AppColors.primaryGreen),
                    const SizedBox(width: 4),
                    Text(
                      '${look.matchScore}% Match',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Weather badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wb_sunny_outlined, size: 14, color: Colors.orange),
                const SizedBox(width: 6),
                Text(
                  look.weatherNote,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryText, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Garment thumbnails in this look
          Row(
            children: look.items.map((item) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.softSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.image,
                          height: 60,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        item.isOwned ? 'Wardrobe' : item.formattedPrice,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: item.isOwned ? AppColors.secondaryText : AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // AI Reason
          if (look.whyMatchReasons.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle_outline, size: 14, color: AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      look.whyMatchReasons.first,
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                    ),
                  ),
                ],
              ),
            ),

          // Apply Look to Try-On Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                appState.applyOutfitToTryOn(look);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Look "${look.title}" berhasil dipasang ke Try-On!'),
                    backgroundColor: AppColors.primaryGreen,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.checkroom_rounded, size: 16, color: Colors.white),
              label: Text(
                '✦ Pasang & Coba Look Ini',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MODE 3: AI TENTUKAN SEMUA (1-CLICK FULL AI AUTOPILOT)
  // ---------------------------------------------------------------------------
  Widget _buildAutopilotMode(AppState appState) {
    final look = _currentAutopilotLook ?? appState.getDailyAutopilotOutfit();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather & Context Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.wb_sunny_rounded, color: Colors.orange, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Jakarta 28°C • Cerah',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${look.matchScore}% Match',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            look.title,
            style: GoogleFonts.fraunces(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dipilihkan otomatis oleh AI berdasarkan cuaca hari ini, preferensi gayamu, dan sinergi lemari pakaianmu.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.secondaryText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // Outfit Pieces Grid in Autopilot Look
          Row(
            children: look.items.map((item) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.softSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.image,
                          height: 70,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.isOwned ? 'Milik Sendiri' : item.formattedPrice,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: item.isOwned ? AppColors.secondaryText : AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // AI Explanation Bullet Points
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mengapa AI Memilih Look Ini:',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                ),
                const SizedBox(height: 6),
                ...look.whyMatchReasons.map((reason) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.check, size: 12, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            reason,
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Two Action Buttons: Surprise Me (Shuffle) & Apply Look
          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentAutopilotLook = appState.getRandomAIOutfit();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AI telah mengacak rekomendasi outfit baru!'),
                        duration: Duration(milliseconds: 1200),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.shuffle_rounded, size: 16, color: AppColors.primaryGreen),
                  label: Text(
                    'Acak AI',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryGreen),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    appState.applyOutfitToTryOn(look);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Outfit "${look.title}" berhasil dipasang ke Try-On!'),
                        backgroundColor: AppColors.primaryGreen,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.checkroom_rounded, size: 16, color: Colors.white),
                  label: Text(
                    '✦ Pasang ke Try-On',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3: ACTIVE TRY-ON FIT TRAY & EXECUTION BUTTONS
  // ---------------------------------------------------------------------------
  Widget _buildActiveFitTray(AppState appState, List<ProductItem> activeGarments) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.checkroom_rounded, color: AppColors.primaryGreen, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Step 3: Pakaian Siap Dicoba',
                    style: GoogleFonts.fraunces(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => appState.clearActiveTryOn(),
                child: Text(
                  'Hapus Semua',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Mini Thumbnails Strip of Selected Garments
          if (activeGarments.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.softSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Pilih pakaian di atas (susun sendiri, dipandu AI, atau otomatis) untuk dipasang di sini.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activeGarments.map((item) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(item.image),
                  ),
                  label: Text(
                    '${item.name} (${item.isOwned ? 'Wardrobe' : item.formattedPrice})',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => appState.removeTryOnGarment(item.category),
                  backgroundColor: AppColors.lightGreen,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              }).toList(),
            ),
          const SizedBox(height: 16),

          // Action 1: Generate Virtual Try-On
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TryOnProcessingScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              label: Text(
                '✦ Generate Virtual Try-On (Foto-realistis)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Action 2: Open in AR Live Mirror
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveFittingMirrorScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.view_in_ar_rounded, color: AppColors.primaryGreen, size: 18),
              label: Text(
                '🪞 Coba di Live AR Fitting Mirror',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GARMENTS GRID FOR DIY MODE
  // ---------------------------------------------------------------------------
  Widget _buildGarmentGrid(AppState appState) {
    List<ProductItem> list;
    if (_activeSourceTab == 'UMKM Store') {
      list = appState.products.where((p) => !p.isOwned).toList();
    } else {
      list = appState.wardrobe.map((w) {
        return ProductItem(
          id: w.id,
          name: w.name,
          seller: 'My Wardrobe',
          price: 0,
          formattedPrice: 'Owned',
          image: w.image,
          category: w.category,
          isOwned: true,
          description: 'Pakaian dari lemari digitalmu.',
        );
      }).toList();
    }

    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Text(
          'Tidak ada pakaian di kategori $_selectedCategory.',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.secondaryText),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.76,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        final isSelected = appState.activeTryOnGarments.any((g) => g.id == item.id || g.name == item.name);

        return GestureDetector(
          onTap: () {
            if (isSelected) {
              appState.removeTryOnGarment(item.category);
            } else {
              appState.setTryOnGarment(item);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : AppColors.border,
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        item.image,
                        height: 125,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryGreen : Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSelected ? Icons.check : Icons.add,
                          size: 14,
                          color: isSelected ? Colors.white : AppColors.primaryText,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.formattedPrice,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.isOwned ? AppColors.secondaryText : AppColors.primaryGreen,
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

  // ---------------------------------------------------------------------------
  // PAST TRY-ON GALLERY SECTION
  // ---------------------------------------------------------------------------
  Widget _buildHistoryGallery(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Riwayat Try-On Tersimpan',
              style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            Text(
              '${appState.tryOnHistory.length} saved',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: appState.tryOnHistory.length,
            itemBuilder: (context, index) {
              final res = appState.tryOnHistory[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TryOnResultScreen(result: res),
                    ),
                  );
                },
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Image.network(
                              res.resultImageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${res.fitScore}%',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              res.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              res.recommendedSize,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppColors.primaryGreen,
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
          ),
        ),
      ],
    );
  }
}
