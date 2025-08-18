import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_grid_widget.dart';
import './widgets/category_tags_widget.dart';
import './widgets/featured_quotes_widget.dart';
import './widgets/home_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? _selectedCategoryId;
  bool _isLoading = false;

  // Mock data for featured quotes
  final List<Map<String, dynamic>> _featuredQuotes = [
    {
      "id": "1",
      "text": "The only way to do great work is to love what you do.",
      "author": "Steve Jobs",
      "category": "Motivation",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": false,
    },
    {
      "id": "2",
      "text":
          "Life is what happens to you while you're busy making other plans.",
      "author": "John Lennon",
      "category": "Life",
      "backgroundImage":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": true,
    },
    {
      "id": "3",
      "text":
          "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Eleanor Roosevelt",
      "category": "Dreams",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": false,
    },
    {
      "id": "4",
      "text":
          "It is during our darkest moments that we must focus to see the light.",
      "author": "Aristotle",
      "category": "Inspiration",
      "backgroundImage":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": false,
    },
    {
      "id": "5",
      "text":
          "Success is not final, failure is not fatal: it is the courage to continue that counts.",
      "author": "Winston Churchill",
      "category": "Success",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": true,
    },
    {
      "id": "6",
      "text": "The only impossible journey is the one you never begin.",
      "author": "Tony Robbins",
      "category": "Journey",
      "backgroundImage":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": false,
    },
  ];

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {
      "id": "all",
      "name": "All",
      "icon": "apps",
      "color": AppTheme.lightTheme.colorScheme.primary,
      "count": 1250,
    },
    {
      "id": "motivation",
      "name": "Motivation",
      "icon": "trending_up",
      "color": AppTheme.lightTheme.colorScheme.tertiary,
      "count": 245,
    },
    {
      "id": "life",
      "name": "Life",
      "icon": "favorite",
      "color": const Color(0xFFE91E63),
      "count": 189,
    },
    {
      "id": "success",
      "name": "Success",
      "icon": "star",
      "color": const Color(0xFFFF9800),
      "count": 156,
    },
    {
      "id": "love",
      "name": "Love",
      "icon": "favorite_border",
      "color": const Color(0xFFE91E63),
      "count": 134,
    },
    {
      "id": "wisdom",
      "name": "Wisdom",
      "icon": "lightbulb",
      "color": const Color(0xFF9C27B0),
      "count": 98,
    },
    {
      "id": "happiness",
      "name": "Happiness",
      "icon": "sentiment_very_satisfied",
      "color": const Color(0xFFFFEB3B),
      "count": 87,
    },
    {
      "id": "inspiration",
      "name": "Inspiration",
      "icon": "auto_awesome",
      "color": const Color(0xFF00BCD4),
      "count": 76,
    },
    {
      "id": "friendship",
      "name": "Friendship",
      "icon": "people",
      "color": const Color(0xFF4CAF50),
      "count": 65,
    },
    {
      "id": "dreams",
      "name": "Dreams",
      "icon": "bedtime",
      "color": const Color(0xFF673AB7),
      "count": 54,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = "all";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: const HomeDrawerWidget(),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  _buildCategoryTags(),
                  SizedBox(height: 3.h),
                  _buildFeaturedSection(),
                  SizedBox(height: 3.h),
                  _buildCategoriesSection(),
                  SizedBox(height: 2.h),
                  _buildBannerAd(),
                  SizedBox(height: 10.h), // Bottom padding for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 12.h,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'menu',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomIconWidget(
                iconName: 'format_quote',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              'QuoteMaster',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Widget _buildCategoryTags() {
    return CategoryTagsWidget(
      categories: _categories,
      selectedCategoryId: _selectedCategoryId,
      onCategorySelected: _handleCategorySelection,
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Quotes',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/category-quotes-screen'),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        FeaturedQuotesWidget(
          featuredQuotes: _featuredQuotes,
          onQuoteTap: _handleQuoteTap,
          onFavoriteTap: _handleFavoriteTap,
          onShareTap: _handleShareTap,
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Browse Categories',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/category-quotes-screen'),
                child: Text(
                  'See More',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        CategoryGridWidget(
          categories: _categories.skip(1).take(10).toList(),
          onCategoryTap: _handleCategoryTap,
        ),
      ],
    );
  }

  Widget _buildBannerAd() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'ads_click',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Advertisement Space',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/quote-editor-screen'),
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      foregroundColor: Colors.white,
      elevation: 4,
      child: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 7.w,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Quotes updated successfully!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleCategorySelection(Map<String, dynamic> category) {
    setState(() {
      _selectedCategoryId = category["id"] as String;
    });

    // Filter featured quotes based on selected category
    if (category["id"] != "all") {
      // Navigate to category-specific quotes
      Navigator.pushNamed(context, '/category-quotes-screen');
    }
  }

  void _handleQuoteTap(Map<String, dynamic> quote) {
    Navigator.pushNamed(context, '/quote-detail-screen');
  }

  void _handleFavoriteTap(Map<String, dynamic> quote) {
    setState(() {
      quote["isFavorite"] = !(quote["isFavorite"] as bool);
    });

    final isFavorite = quote["isFavorite"] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to favorites!' : 'Removed from favorites!',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/favorites-screen'),
        ),
      ),
    );
  }

  void _handleShareTap(Map<String, dynamic> quote) {
    final shareText = "${quote["text"]}\n\n- ${quote["author"]}";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quote copied to clipboard: "${quote["text"]}"'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: shareText));
  }

  void _handleCategoryTap(Map<String, dynamic> category) {
    Navigator.pushNamed(context, '/category-quotes-screen');
  }
}
