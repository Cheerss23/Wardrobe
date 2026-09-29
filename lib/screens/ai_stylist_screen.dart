import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';
import 'shop_this_look_screen.dart';
import 'try_on_processing_screen.dart';
import 'try_on_studio_screen.dart';
import 'product_detail_screen.dart';

class AIStylistScreen extends StatefulWidget {
  const AIStylistScreen({super.key});

  @override
  State<AIStylistScreen> createState() => _AIStylistScreenState();
}

class _AIStylistScreenState extends State<AIStylistScreen> {
  String _selectedOccasion = 'Campus';
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, dynamic>> _occasions = const [
    {'name': 'Campus', 'icon': Icons.school_rounded, 'image': 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Office', 'icon': Icons.business_center_rounded, 'image': 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Date', 'icon': Icons.favorite_rounded, 'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Travel', 'icon': Icons.flight_takeoff_rounded, 'image': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Hangout', 'icon': Icons.local_cafe_rounded, 'image': 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Formal', 'icon': Icons.military_tech_rounded, 'image': 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Daily', 'icon': Icons.wb_sunny_rounded, 'image': 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Sporty', 'icon': Icons.fitness_center_rounded, 'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&auto=format&fit=crop&q=80'},
  ];

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _openAskFitlyChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer<AppState>(
          builder: (context, appState, child) {
            final messages = appState.chatMessages;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  gradient: AppColors.purpleAiGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ask Fitly AI',
                                    style: GoogleFonts.fraunces(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Personal Stylist Real-Time Assistant',
                                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),

                    // Quick prompt pills
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _buildPromptPill(appState, 'I want to wear my white shirt tomorrow'),
                          _buildPromptPill(appState, 'Baju apa yang cocok untuk besok?'),
                          _buildPromptPill(appState, 'Cari outfit hitam di bawah Rp500.000'),
                          _buildPromptPill(appState, 'Rekomendasi outfit kencan santai'),
                          _buildPromptPill(appState, 'Cocokkan dengan sepatu putihku'),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),

                    // Messages List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, idx) {
                          final msg = messages[idx];
                          return _buildChatMessageBubble(context, msg, appState);
                        },
                      ),
                    ),

                    // Input Bar
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        border: Border(top: BorderSide(color: AppColors.border)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              decoration: InputDecoration(
                                hintText: 'Tanyakan gaya, budget, atau acara...',
                                hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.tertiaryText),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onSubmitted: (val) {
                                if (val.trim().isNotEmpty) {
                                  appState.sendUserChatMessage(val.trim());
                                  _chatController.clear();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: AppColors.primaryPurple,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                              onPressed: () {
                                if (_chatController.text.trim().isNotEmpty) {
                                  appState.sendUserChatMessage(_chatController.text.trim());
                                  _chatController.clear();
                                }
                              },
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
      },
    );
  }

  Widget _buildPromptPill(AppState appState, String prompt) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(prompt),
        labelStyle: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w600),
        backgroundColor: AppColors.primaryPurpleLight,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => appState.sendUserChatMessage(prompt),
      ),
    );
  }

  Widget _buildChatMessageBubble(BuildContext context, ChatMessage msg, AppState appState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: msg.isUser ? AppColors.primaryPurple : AppColors.softSurface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              msg.text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: msg.isUser ? Colors.white : AppColors.primaryText,
                height: 1.3,
              ),
            ),
          ),
          // Attached Outfit Recommendation in Chat
          if (msg.attachedOutfit != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShopThisLookScreen(outfit: msg.attachedOutfit!)),
                );
              },
              child: Container(
                width: 260,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(msg.attachedOutfit!.image, height: 120, width: double.infinity, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      msg.attachedOutfit!.title,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp${(msg.attachedOutfit!.effectivePrice ~/ 1000)}.000 • ${msg.attachedOutfit!.matchScore}% Match',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ShopThisLookScreen(outfit: msg.attachedOutfit!)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text('Shop This Look', style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          // Attached Products in Chat
          if (msg.attachedProducts != null && msg.attachedProducts!.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: msg.attachedProducts!.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final p = msg.attachedProducts![idx];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                      );
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(p.image, height: 60, width: 100, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 4),
                          Text(p.name, maxLines: 1, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(p.formattedPrice, style: GoogleFonts.inter(fontSize: 10, color: AppColors.primaryPurple, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          // Attached 3-Look Stylist Options
          if (msg.stylistLookOptions != null && msg.stylistLookOptions!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...msg.stylistLookOptions!.map((look) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 280,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            look.title,
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurpleLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${look.matchScore}% Match',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primaryPurple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Weather: ${look.weatherCompatibility}',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                    ),
                    Text(
                      'Est. Price: ${look.estimatedPrice == 0 ? "Rp0 (All Owned)" : look.formattedEstimatedPrice}',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryPurple),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: look.itemNames.map((name) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            children: [
                              Icon(
                                name.contains('Owned') ? Icons.check_circle_rounded : Icons.add_shopping_cart_rounded,
                                size: 12,
                                color: name.contains('Owned') ? AppColors.primaryGreen : AppColors.primaryPurple,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: name.contains('Owned') ? FontWeight.normal : FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // "Try This Look"
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context); // Close chat
                              final mainProduct = look.missingItems.isNotEmpty
                                  ? look.missingItems.first
                                  : appState.products[0];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TryOnProcessingScreen(
                                    newProduct: mainProduct,
                                    selectedWardrobe: look.ownedItems,
                                    fitScore: look.matchScore,
                                    occasion: 'Everyday',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                            label: Text(
                              'Try This Look',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        if (look.missingItems.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          // "Shop Missing Items"
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close chat
                                for (final item in look.missingItems) {
                                  appState.addToCart(item, 'L', 'Default');
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryPurple),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                'Shop Missing',
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryPurple),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentOutfit = appState.getOutfitForOccasion(_selectedOccasion);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
          children: [
            // Title & Subtitle Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Stylist',
                      style: GoogleFonts.fraunces(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      'Asisten fashion & kurator gaya pribadimu',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                // Ask Fitly Chat Trigger Button
                ElevatedButton.icon(
                  onPressed: () => _openAskFitlyChat(context),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Ask Fitly'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Section 8: Choose Your Occasion
            Text(
              'Mau berpakaian untuk acara apa?',
              style: GoogleFonts.fraunces(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _occasions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, idx) {
                  final occ = _occasions[idx];
                  final name = occ['name'] as String;
                  final isSelected = _selectedOccasion.toLowerCase() == name.toLowerCase();

                  return InkWell(
                    onTap: () {
                      setState(() => _selectedOccasion = name);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 78,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryPurpleLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPurple : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            occ['icon'] as IconData,
                            color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
                            size: 24,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppColors.primaryPurple : AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Recommended Style for Selected Occasion Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
                        child: AspectRatio(
                          aspectRatio: 1.4,
                          child: Image.network(
                            currentOutfit.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.softSurface),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${currentOutfit.matchScore}% Match • $_selectedOccasion',
                                style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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
                        Text(
                          currentOutfit.title,
                          style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentOutfit.weatherNote,
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
                        ),
                        const SizedBox(height: 12),
                        // CTAs: Shop This Look (Primary) > Try This Look (Secondary)
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                appState.startTryOnWithLook(currentOutfit.items);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TryOnStudioScreen()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryPurple),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                              child: Text(
                                'Try This Look',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ShopThisLookScreen(outfit: currentOutfit)),
                                  );
                                },
                                icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                                label: Text('Shop Look • Rp${(currentOutfit.effectivePrice ~/ 1000)}.000'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPurple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 27: AI Mix & Match (Wardrobe + Fitly Products)
            Text(
              'Complete Your Look (Mix & Match)',
              style: GoogleFonts.fraunces(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Kamu memiliki 2 item di lemari:',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildOwnedItemChip('Kemeja Linen Putih'),
                      const SizedBox(width: 8),
                      _buildOwnedItemChip('Celana Jeans Denim'),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.border),
                  Row(
                    children: [
                      const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryPurple, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Item pelengkap rekomendasi AI:',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Missing piece buyable card
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          appState.products[10].image, // Cuban Chain
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.products[10].name,
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              appState.products[10].formattedPrice,
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryPurple, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: appState.products[10])),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Beli', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section: Trending Styles For You
            Text(
              'Trending Styles For You',
              style: GoogleFonts.fraunces(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: appState.curatedOutfits.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, idx) {
                  final outfit = appState.curatedOutfits[idx];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ShopThisLookScreen(outfit: outfit)),
                      );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              outfit.image,
                              height: 110,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  outfit.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Rp${(outfit.effectivePrice ~/ 1000)}.000',
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w700),
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
        ),
      ),
    );
  }

  Widget _buildOwnedItemChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.softSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '✓ $title',
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryText),
      ),
    );
  }
}
