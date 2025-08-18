import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  centered,
  minimal,
  search,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final VoidCallback? onSearchTap;
  final String? searchHint;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = false,
    this.onSearchTap,
    this.searchHint = 'Search quotes...',
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      centerTitle: _shouldCenterTitle(),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.search:
        return GestureDetector(
          onTap: onSearchTap ?? () => _navigateToSearch(context),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    searchHint!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case CustomAppBarVariant.minimal:
        return null;
      default:
        return title != null
            ? Text(
                title!,
                style: GoogleFonts.inter(
                  fontSize: variant == CustomAppBarVariant.centered ? 18 : 20,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor ?? theme.appBarTheme.foregroundColor,
                ),
              )
            : null;
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (variant == CustomAppBarVariant.minimal) return null;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> defaultActions = [];

    // Add navigation-specific actions based on current route
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case '/home-screen':
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 22),
            onPressed: () => Navigator.pushNamed(context, '/favorites-screen'),
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 22),
            onPressed: () => _showMoreOptions(context),
            tooltip: 'More options',
          ),
        ]);
        break;
      case '/category-quotes-screen':
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.search, size: 22),
            onPressed: () => _navigateToSearch(context),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 22),
            onPressed: () => Navigator.pushNamed(context, '/favorites-screen'),
            tooltip: 'Favorites',
          ),
        ]);
        break;
      case '/quote-detail-screen':
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.share, size: 22),
            onPressed: () => _shareQuote(context),
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 22),
            onPressed: () => _toggleFavorite(context),
            tooltip: 'Add to favorites',
          ),
        ]);
        break;
      case '/favorites-screen':
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.search, size: 22),
            onPressed: () => _navigateToSearch(context),
            tooltip: 'Search',
          ),
        ]);
        break;
    }

    if (actions != null) {
      defaultActions.addAll(actions!);
    }

    return defaultActions.isNotEmpty ? defaultActions : null;
  }

  bool _shouldCenterTitle() {
    switch (variant) {
      case CustomAppBarVariant.centered:
        return true;
      case CustomAppBarVariant.minimal:
        return false;
      default:
        return centerTitle;
    }
  }

  void _navigateToSearch(BuildContext context) {
    // For now, show a simple search interface
    showSearch(
      context: context,
      delegate: _QuoteSearchDelegate(),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                // Show about dialog
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareQuote(BuildContext context) {
    // Implement quote sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _toggleFavorite(BuildContext context) {
    // Implement favorite toggle
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to favorites')),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _QuoteSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Motivational quotes'),
          onTap: () {
            query = 'Motivational quotes';
            showResults(context);
          },
        ),
        ListTile(
          title: const Text('Life quotes'),
          onTap: () {
            query = 'Life quotes';
            showResults(context);
          },
        ),
        ListTile(
          title: const Text('Success quotes'),
          onTap: () {
            query = 'Success quotes';
            showResults(context);
          },
        ),
      ],
    );
  }
}
