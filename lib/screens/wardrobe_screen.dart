import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'product_detail_screen.dart';
import 'try_with_wardrobe_screen.dart';
import 'try_on_processing_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  // Navigation mode: 0 = Pakaian Saya (Owned - Priority), 1 = Cari di Katalog (Explore Alternatives)
  int _selectedViewTab = 0;

  // Filter category for owned wardrobe
  String _selectedWardrobeCategory = 'All';
  final List<String> _wardrobeCategories = ['All', 'Tops', 'Bottoms', 'Shoes', 'Accessories'];

  // Filter category for catalog discovery
  String _selectedCatalogCategory = 'All';
  final List<String> _catalogCategories = ['All', 'Tops', 'Bottoms', 'Outerwear', 'Shoes', 'Accessories'];
  String _catalogSearchQuery = '';
  final TextEditingController _catalogSearchController = TextEditingController();

  // Outfit Builder Slots (User can assemble outfit to try on)
  WardrobePiece? _builderTop;
  WardrobePiece? _builderBottom;
  WardrobePiece? _builderShoes;
  WardrobePiece? _builderAccessory;

  // Today's outfit suggestion cycle index
  int _todaySuggestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Default pre-fill outfit builder with initial sensible picks on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      if (appState.wardrobe.isNotEmpty) {
        _applySuggestionToBuilder(_todaySuggestionIndex, appState);
      }
    });
  }

  @override
  void dispose() {
    _catalogSearchController.dispose();
    super.dispose();
  }

  // Preset outfit suggestions created exclusively from user's owned clothes
  List<Map<String, dynamic>> _getTodaySuggestions(AppState appState) {
    final wardrobe = appState.wardrobe;
    final top1 = wardrobe.firstWhere((w) => w.id == 'w_top1', orElse: () => wardrobe[0]);
    final top2 = wardrobe.firstWhere((w) => w.id == 'w_top2', orElse: () => wardrobe[0]);
    final top3 = wardrobe.firstWhere((w) => w.id == 'w_top3', orElse: () => wardrobe[0]);

    final bot1 = wardrobe.firstWhere((w) => w.id == 'w_bot1', orElse: () => wardrobe[3]);
    final bot2 = wardrobe.firstWhere((w) => w.id == 'w_bot2', orElse: () => wardrobe[4]);
    final bot3 = wardrobe.firstWhere((w) => w.id == 'w_bot3', orElse: () => wardrobe[5]);

    final shoe1 = wardrobe.firstWhere((w) => w.id == 'w_shoe1', orElse: () => wardrobe[6]);
    final shoe2 = wardrobe.firstWhere((w) => w.id == 'w_shoe2', orElse: () => wardrobe[7]);

    final acc1 = wardrobe.firstWhere((w) => w.id == 'w_acc1', orElse: () => wardrobe[8]);
    final acc2 = wardrobe.firstWhere((w) => w.id == 'w_acc2', orElse: () => wardrobe[9]);

    return [
      {
        'title': 'Smart Casual Minimalist',
        'weather': '28°C Cerah • Sejuk & Breathable',
        'vibe': 'Kantor, Kuliah & Pertemuan Rapi',
        'matchScore': 98,
        'description':
            'Kemeja putih katun oversized dipadukan dengan celana straight hitam dan sneakers putih. Tampilan rapi, adem, dan timeless untuk cuaca hari ini.',
        'top': top1,
        'bottom': bot1,
        'shoes': shoe1,
        'accessory': acc1,
      },
      {
        'title': 'Urban Streetwear Relaxed',
        'weather': '28°C Cerah • Gaya Santai Fleksibel',
        'vibe': 'Hangout Kafe & Jalan Sore',
        'matchScore': 96,
        'description':
            'Kaos hitam combed tebal bersama celana blue jeans dan sneakers hitam. Siluet santai yang pas untuk mobilitas tinggi dan kenyamanan maksimal.',
        'top': top2,
        'bottom': bot2,
        'shoes': shoe2,
        'accessory': acc2,
      },
      {
        'title': 'Earthy Monochrome Casual',
        'weather': '28°C Cerah • Hangat & Estetik',
        'vibe': 'Date Santai & Weekend Vibe',
        'matchScore': 95,
        'description':
            'Kemeja beige berpadu selaras dengan chinos beige dan aksen jam hitam. Perpaduan earth tone yang memberi kesan hangat dan bersih.',
        'top': top3,
        'bottom': bot3,
        'shoes': shoe1,
        'accessory': acc1,
      },
    ];
  }

  void _applySuggestionToBuilder(int index, AppState appState) {
    final suggestions = _getTodaySuggestions(appState);
    final target = suggestions[index % suggestions.length];
    setState(() {
      _builderTop = target['top'] as WardrobePiece?;
      _builderBottom = target['bottom'] as WardrobePiece?;
      _builderShoes = target['shoes'] as WardrobePiece?;
      _builderAccessory = target['accessory'] as WardrobePiece?;
    });
  }

  void _cycleNextSuggestion(AppState appState) {
    final suggestions = _getTodaySuggestions(appState);
    setState(() {
      _todaySuggestionIndex = (_todaySuggestionIndex + 1) % suggestions.length;
    });
  }

  void _assignToBuilderSlot(WardrobePiece piece) {
    setState(() {
      switch (piece.category) {
        case 'Tops':
          _builderTop = piece;
          break;
        case 'Bottoms':
          _builderBottom = piece;
          break;
        case 'Shoes':
          _builderShoes = piece;
          break;
        case 'Accessories':
        default:
          _builderAccessory = piece;
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${piece.name}" dipasang ke susunan outfit!'),
        backgroundColor: AppColors.primaryPurpleDark,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearBuilder() {
    setState(() {
      _builderTop = null;
      _builderBottom = null;
      _builderShoes = null;
      _builderAccessory = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Susunan outfit berhasil dikosongkan.'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<WardrobePiece> get _assembledPieces {
    final list = <WardrobePiece>[];
    if (_builderTop != null) list.add(_builderTop!);
    if (_builderBottom != null) list.add(_builderBottom!);
    if (_builderShoes != null) list.add(_builderShoes!);
    if (_builderAccessory != null) list.add(_builderAccessory!);
    return list;
  }

  void _tryOnAssembledOutfit() {
    final pieces = _assembledPieces;
    if (pieces.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal Atasan & Bawahan untuk mencoba outfit di ruang ganti virtual.'),
          backgroundColor: AppColors.primaryPurpleDark,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TryOnProcessingScreen(
          selectedWardrobe: pieces,
          occasion: 'Outfit Pilihan Saya',
          fitScore: 97,
          reasons: const [
            'Kombinasi hasil rancangan personal dari koleksi lemarimu',
            'Siluet tubuh proporsional dengan keseimbangan warna yang selaras',
            'Sangat cocok dan nyaman untuk cuaca cerah hari ini (28°C)',
            'Pakaian siap pakai tanpa perlu membeli item baru',
          ],
        ),
      ),
    );
  }

  void _showSlotPickerModal(BuildContext context, String category, AppState appState) {
    final availableItems = appState.wardrobe.where((w) => w.category == category).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pilih $category dari Lemari',
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (availableItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Belum ada pakaian di kategori $category.',
                      style: GoogleFonts.inter(color: AppColors.secondaryText),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: availableItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = availableItems[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(item.image, width: 48, height: 48, fit: BoxFit.cover),
                        ),
                        title: Text(
                          item.name,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${item.style} • Dipakai ${item.usedInLooksCount}x',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _assignToBuilderSlot(item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          ),
                          child: const Text('Pilih', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showAddClothingModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Digitalisasi Pakaian ke Lemari',
                style: GoogleFonts.fraunces(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'AI Fitly akan otomatis mendeteksi kategori, warna, dan jenis potongan pakaianmu.',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPurpleLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryPurple),
                ),
                title: Text('Foto Pakaian Sekarang', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                subtitle: Text('Gunakan kamera untuk mendeteksi baju', style: GoogleFonts.inter(fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  _simulateAIDigitization(appState);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPurpleLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: AppColors.primaryPurple),
                ),
                title: Text('Upload dari Galeri', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                subtitle: Text('Pilih foto pakaian yang sudah ada', style: GoogleFonts.inter(fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  _simulateAIDigitization(appState);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _simulateAIDigitization(AppState appState) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const CircularProgressIndicator(color: AppColors.primaryPurple),
              const SizedBox(height: 20),
              Text(
                'AI Menganalisis Pakaian...',
                style: GoogleFonts.fraunces(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Mendeteksi potongan, warna, dan style...',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
              ),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    Navigator.pop(context); // close loader
    final newPiece = WardrobePiece(
      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Off-White Relaxed Oxford Shirt',
      category: 'Tops',
      image: 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=600&auto=format&fit=crop&q=80',
      dateAdded: 'Today, 29 Sep',
      usedInLooksCount: 1,
      color: 'Off-White',
      style: 'Smart Casual',
    );
    appState.addWardrobePiece(newPiece);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terdeteksi: "${newPiece.name}" berhasil ditambahkan ke lemarimu!'),
        backgroundColor: AppColors.primaryPurpleDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Digital Wardrobe',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryPurple),
            tooltip: 'Tambah Pakaian ke Lemari',
            onPressed: () => _showAddClothingModal(context, appState),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Switcher / Menu Tabs: "Pakaian Saya" (Prioritized) vs "Cari di Toko / Katalog"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedViewTab = 0),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedViewTab == 0 ? AppColors.primaryPurple : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _selectedViewTab == 0
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryPurple.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.checkroom_rounded,
                              size: 17,
                              color: _selectedViewTab == 0 ? Colors.white : AppColors.secondaryText,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Pakaian Saya (${appState.wardrobe.length})',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _selectedViewTab == 0 ? Colors.white : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedViewTab = 1),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedViewTab == 1 ? AppColors.primaryPurple : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _selectedViewTab == 1
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryPurple.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.storefront_rounded,
                              size: 17,
                              color: _selectedViewTab == 1 ? Colors.white : AppColors.secondaryText,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cari di Toko / Katalog',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _selectedViewTab == 1 ? Colors.white : AppColors.secondaryText,
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

            // Tab Content
            Expanded(
              child: _selectedViewTab == 0
                  ? _buildOwnedWardrobeView(context, appState)
                  : _buildCatalogDiscoveryView(context, appState),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // VIEW 1: PAKAIAN SAYA (PRIORITIZED OWNED WARDROBE + BUILDER + TODAY'S SUGGESTION)
  // =========================================================================
  Widget _buildOwnedWardrobeView(BuildContext context, AppState appState) {
    final filteredItems = _selectedWardrobeCategory == 'All'
        ? appState.wardrobe
        : appState.wardrobe.where((w) => w.category == _selectedWardrobeCategory).toList();

    final suggestions = _getTodaySuggestions(appState);
    final todaySuggestion = suggestions[_todaySuggestionIndex % suggestions.length];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // 1. SARAN OUTFIT HARI INI (REPLACES "COMPLETE MY LOOK")
        _buildTodayOutfitSuggestionCard(context, appState, todaySuggestion),

        const SizedBox(height: 20),

        // 2. SUSUN OUTFIT SENDIRI (OUTFIT BUILDER TO TRY ON)
        _buildOutfitBuilderCard(context, appState),

        const SizedBox(height: 24),

        // 3. WARDROBE COLLECTION HEADER & STATS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Koleksi Pakaian Kamu',
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  'Prioritas pakaian yang sudah kamu miliki di lemari',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: () => _showAddClothingModal(context, appState),
              icon: const Icon(Icons.add, size: 15, color: AppColors.primaryPurple),
              label: Text(
                'Tambah',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryPurple),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _wardrobeCategories.map((cat) {
              final isSelected = _selectedWardrobeCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedWardrobeCategory = cat;
                    });
                  },
                  selectedColor: AppColors.primaryPurple,
                  backgroundColor: AppColors.surface,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.primaryText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryPurple : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Wardrobe Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredItems.length + 1, // +1 for Add Pakaian Card
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            if (index == filteredItems.length) {
              return _buildAddPakaianGridCard(context, appState);
            }
            final piece = filteredItems[index];
            return _buildOwnedPieceGridCard(context, piece);
          },
        ),

        const SizedBox(height: 36),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // CARD: SARAN OUTFIT HARI INI
  // -------------------------------------------------------------------------
  Widget _buildTodayOutfitSuggestionCard(
    BuildContext context,
    AppState appState,
    Map<String, dynamic> suggestion,
  ) {
    final top = suggestion['top'] as WardrobePiece;
    final bottom = suggestion['bottom'] as WardrobePiece;
    final shoes = suggestion['shoes'] as WardrobePiece;
    final accessory = suggestion['accessory'] as WardrobePiece;
    final comboPieces = [top, bottom, shoes, accessory];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Top Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryPurpleLight.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
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
                      child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Saran Outfit Hari Ini',
                      style: GoogleFonts.fraunces(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurpleDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 12, color: AppColors.primaryPurple),
                      const SizedBox(width: 4),
                      Text(
                        '${suggestion['matchScore']}% Match',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weather and occasion subtitle
                Row(
                  children: [
                    const Icon(Icons.thermostat_outlined, size: 14, color: AppColors.secondaryText),
                    const SizedBox(width: 4),
                    Text(
                      suggestion['weather'] as String,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion['title'] as String,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                ),
                const SizedBox(height: 6),
                Text(
                  suggestion['description'] as String,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText, height: 1.35),
                ),

                const SizedBox(height: 14),

                // Thumbnails of owned pieces in this look
                Row(
                  children: comboPieces.map((piece) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                piece.image,
                                height: 50,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              piece.category,
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primaryPurple),
                              maxLines: 1,
                            ),
                            Text(
                              piece.name,
                              style: GoogleFonts.inter(fontSize: 9, color: AppColors.primaryText),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Actions: "Coba Outfit Hari Ini" & "Pasang ke Susunan" & "Ganti Saran"
                Row(
                  children: [
                    // Primary Try On CTA
                    Expanded(
                      flex: 4,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TryOnProcessingScreen(
                                selectedWardrobe: comboPieces,
                                occasion: 'Gaya Hari Ini',
                                fitScore: suggestion['matchScore'] as int,
                                reasons: [
                                  suggestion['description'] as String,
                                  'Proporsi siluet sesuai bentuk tubuh',
                                  'Kombinasi warna monokromatis seimbang',
                                  'Seluruh pakaian merupakan koleksi lemarimu',
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome, size: 15, color: Colors.white),
                        label: Text(
                          'Coba Outfit Hari Ini',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Load into Builder button
                    IconButton.outlined(
                      onPressed: () {
                        _applySuggestionToBuilder(_todaySuggestionIndex, appState);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saran outfit hari ini dimasukkan ke kotak susun outfit.'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primaryPurple),
                      tooltip: 'Bawa ke Susun Outfit',
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

                    // Next/Shuffle Suggestion
                    IconButton.outlined(
                      onPressed: () => _cycleNextSuggestion(appState),
                      icon: const Icon(Icons.shuffle_rounded, size: 18, color: AppColors.primaryText),
                      tooltip: 'Ganti Saran Lain',
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // CARD: SUSUN OUTFIT SENDIRI (OUTFIT BUILDER)
  // -------------------------------------------------------------------------
  Widget _buildOutfitBuilderCard(BuildContext context, AppState appState) {
    final assembledCount = _assembledPieces.length;

    return Container(
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
          // Builder Title & Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.style_rounded, size: 18, color: AppColors.primaryPurple),
                      const SizedBox(width: 6),
                      Text(
                        'Susun Outfit Kamu',
                        style: GoogleFonts.fraunces(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pilih item dari lemarimu untuk dipadukan & dicoba',
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _assembledPieces.isEmpty ? null : _clearBuilder,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      'Reset',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: _assembledPieces.isEmpty ? AppColors.secondaryText : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.auto_fix_high_rounded, size: 18, color: AppColors.primaryPurple),
                    tooltip: 'Acak AI Outfit',
                    onPressed: () {
                      _cycleNextSuggestion(appState);
                      _applySuggestionToBuilder(_todaySuggestionIndex, appState);
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 4 Interactive Slots Row: Atasan, Bawahan, Sepatu, Aksesoris
          Row(
            children: [
              Expanded(
                child: _buildBuilderSlotItem(
                  context: context,
                  label: 'Atasan',
                  category: 'Tops',
                  piece: _builderTop,
                  appState: appState,
                  onRemove: () => setState(() => _builderTop = null),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBuilderSlotItem(
                  context: context,
                  label: 'Bawahan',
                  category: 'Bottoms',
                  piece: _builderBottom,
                  appState: appState,
                  onRemove: () => setState(() => _builderBottom = null),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBuilderSlotItem(
                  context: context,
                  label: 'Sepatu',
                  category: 'Shoes',
                  piece: _builderShoes,
                  appState: appState,
                  onRemove: () => setState(() => _builderShoes = null),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBuilderSlotItem(
                  context: context,
                  label: 'Aksesoris',
                  category: 'Accessories',
                  piece: _builderAccessory,
                  appState: appState,
                  onRemove: () => setState(() => _builderAccessory = null),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Status & Try On CTA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: assembledCount >= 2 ? AppColors.primaryGreen : Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$assembledCount/4 Item Terpasang',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        assembledCount >= 2 ? 'Kombinasi siap dicoba di avatar' : 'Tambahkan atasan & bawahan',
                        style: GoogleFonts.inter(fontSize: 10, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _tryOnAssembledOutfit,
                  icon: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                  label: Text(
                    'Coba Outfit Ini',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilderSlotItem({
    required BuildContext context,
    required String label,
    required String category,
    required WardrobePiece? piece,
    required AppState appState,
    required VoidCallback onRemove,
  }) {
    if (piece == null) {
      // Empty Slot
      return InkWell(
        onTap: () => _showSlotPickerModal(context, category, appState),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline_rounded, size: 22, color: AppColors.primaryPurple),
              const SizedBox(height: 6),
              Text(
                '+ $label',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              Text(
                'Pilih',
                style: GoogleFonts.inter(fontSize: 9, color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      );
    }

    // Filled Slot
    return Stack(
      children: [
        InkWell(
          onTap: () => _showSlotPickerModal(context, category, appState),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 96,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryPurple, width: 1.5),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    piece.image,
                    height: 52,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  piece.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 9, color: AppColors.primaryPurple, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        // Remove 'x' button
        Positioned(
          top: 3,
          right: 3,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // CARDS: GRID OF OWNED WARDROBE
  // -------------------------------------------------------------------------
  Widget _buildOwnedPieceGridCard(BuildContext context, WardrobePiece item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                child: Image.network(
                  item.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'MILIK SAYA',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item.usedInLooksCount}x pakai',
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.category} • ${item.style}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
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
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _assignToBuilderSlot(item),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurpleLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 13, color: AppColors.primaryPurple),
                        const SizedBox(width: 4),
                        Text(
                          'Pasang ke Outfit',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPakaianGridCard(BuildContext context, AppState appState) {
    return InkWell(
      onTap: () => _showAddClothingModal(context, appState),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primaryPurple,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryPurpleLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                size: 26,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tambah Pakaian',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
            Text(
              'Scan AI lemarimu',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // VIEW 2: CARI DI TOKO / KATALOG (EXPLORE ALTERNATIVES)
  // =========================================================================
  Widget _buildCatalogDiscoveryView(BuildContext context, AppState appState) {
    final query = _catalogSearchQuery.toLowerCase().trim();
    final products = appState.products.where((p) {
      final matchesCategory = _selectedCatalogCategory == 'All' || p.category == _selectedCatalogCategory;
      final matchesQuery = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.brand.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.secondaryText, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _catalogSearchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari produk baru untuk dipadukan...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _catalogSearchQuery = val;
                    });
                  },
                ),
              ),
              if (_catalogSearchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _catalogSearchController.clear();
                    setState(() => _catalogSearchQuery = '');
                  },
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Catalog Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _catalogCategories.map((cat) {
              final isSelected = _selectedCatalogCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedCatalogCategory = cat;
                    });
                  },
                  selectedColor: AppColors.primaryPurple,
                  backgroundColor: AppColors.surface,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.primaryText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryPurple : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Helper header note
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryPurpleLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: AppColors.primaryPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Coba langsung produk toko ini bersama pakaian yang sudah kamu miliki di lemari.',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryPurpleDark),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Product Catalog Grid
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Tidak ada produk yang cocok dengan pencarian.',
                style: GoogleFonts.inter(color: AppColors.secondaryText),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final matchPercentage = product.matchPercentage ?? 94;

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                          child: Image.network(
                            product.image,
                            height: 125,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$matchPercentage% Match',
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
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.brand,
                            style: GoogleFonts.inter(fontSize: 10, color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.formattedPrice,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // CTA: Try with Wardrobe
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TryWithWardrobeScreen(product: product),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                              label: Text(
                                'Coba dgn Lemari',
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPurple,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Detail button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                'Lihat Detail',
                                style: GoogleFonts.inter(fontSize: 10, color: AppColors.primaryText),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

        const SizedBox(height: 36),
      ],
    );
  }
}
