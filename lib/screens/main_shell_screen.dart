import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'wardrobe_screen.dart';
import 'ai_start_screen.dart';
import 'saved_screen.dart';
import 'orders_screen.dart';
import 'cart_screen.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    WardrobeScreen(),
    AIStartScreen(),
    SavedScreen(),
    OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.checkroom_rounded,
                color: AppColors.primaryGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Wardrobe Sense',
              style: GoogleFonts.fraunces(
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${appState.cartCount}'),
              isLabelVisible: appState.cartCount > 0,
              backgroundColor: AppColors.primaryGreen,
              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryText),
            ),
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
        index: appState.currentTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: NavigationBar(
          selectedIndex: appState.currentTabIndex,
          onDestinationSelected: (idx) => appState.setTabIndex(idx),
          backgroundColor: AppColors.card,
          indicatorColor: AppColors.lightGreen,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryGreen),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.checkroom_outlined),
              selectedIcon: Icon(Icons.checkroom_rounded, color: AppColors.primaryGreen),
              label: 'Wardrobe',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome, color: AppColors.primaryGreen),
              label: 'AI Stylist',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline_rounded),
              selectedIcon: Icon(Icons.bookmark_rounded, color: AppColors.primaryGreen),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primaryGreen),
              label: 'Orders',
            ),
          ],
        ),
      ),
    );
  }
}
