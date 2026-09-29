import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'wardrobe_screen.dart';
import 'profile_screen.dart';
import 'saved_screen.dart';
import 'cart_screen.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    DiscoverScreen(),
    WardrobeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Guard against index out of range if index was 4 previously
    final safeIndex = appState.currentTabIndex.clamp(0, _screens.length - 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: AppColors.purpleAiGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'FITLY',
              style: GoogleFonts.fraunces(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              appState.savedProductIds.isNotEmpty
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: appState.savedProductIds.isNotEmpty ? AppColors.discountBadge : AppColors.primaryText,
            ),
            tooltip: 'Wishlist',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedScreen()),
              );
            },
          ),
          IconButton(
            icon: Badge(
              label: Text('${appState.cartCount}'),
              isLabelVisible: appState.cartCount > 0,
              backgroundColor: AppColors.primaryPurple,
              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryText),
            ),
            tooltip: 'Keranjang Belanja',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: safeIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: safeIndex,
          onDestinationSelected: (idx) => appState.setTabIndex(idx),
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryPurpleLight,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryPurple),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded, color: AppColors.primaryPurple),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.checkroom_outlined),
              selectedIcon: Icon(Icons.checkroom_rounded, color: AppColors.primaryPurple),
              label: 'Wardrobe',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryPurple),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
