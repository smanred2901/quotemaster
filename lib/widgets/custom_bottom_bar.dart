import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  material3,
  classic,
  floating,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final CustomBottomBarVariant variant;
  final Color? backgroundColor;
  final double? elevation;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = CustomBottomBarVariant.material3,
    this.backgroundColor,
    this.elevation,
    this.showLabels = true,
  });

  static const List<_BottomNavItem> _navItems = [
    _BottomNavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
      route: '/home-screen',
    ),
    _BottomNavItem(
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
      label: 'Categories',
      route: '/category-quotes-screen',
    ),
    _BottomNavItem(
      icon: Icons.favorite_border,
      selectedIcon: Icons.favorite,
      label: 'Favorites',
      route: '/favorites-screen',
    ),
    _BottomNavItem(
      icon: Icons.edit_outlined,
      selectedIcon: Icons.edit,
      label: 'Create',
      route: '/quote-editor-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case CustomBottomBarVariant.material3:
        return _buildMaterial3NavigationBar(context);
      case CustomBottomBarVariant.floating:
        return _buildFloatingNavigationBar(context);
      case CustomBottomBarVariant.classic:
      default:
        return _buildClassicBottomNavigationBar(context);
    }
  }

  Widget _buildMaterial3NavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _handleNavigation(context, index),
        backgroundColor:
            backgroundColor ?? theme.navigationBarTheme.backgroundColor,
        elevation: elevation ?? theme.navigationBarTheme.elevation,
        surfaceTintColor: Colors.transparent,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        destinations: _navItems.map((item) {
          final isSelected = _navItems.indexOf(item) == currentIndex;
          return NavigationDestination(
            icon: Icon(
              item.icon,
              size: 24,
            ),
            selectedIcon: Icon(
              item.selectedIcon,
              size: 24,
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClassicBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavigation(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        elevation: elevation ?? 8.0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        showSelectedLabels: showLabels,
        showUnselectedLabels: showLabels,
        items: _navItems.map((item) {
          final isSelected = _navItems.indexOf(item) == currentIndex;
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Icon(
                isSelected ? item.selectedIcon : item.icon,
                size: 24,
              ),
            ),
            label: item.label,
            tooltip: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFloatingNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;

            return GestureDetector(
              onTap: () => _handleNavigation(context, index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      size: 24,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    if (showLabels) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the selected route
    final selectedItem = _navItems[index];
    Navigator.pushNamedAndRemoveUntil(
      context,
      selectedItem.route,
      (route) => route.isFirst,
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
