import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: _buildDrawerItems(context),
            ),
            _buildDrawerFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'format_quote',
              color: Colors.white,
              size: 8.w,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'QuoteMaster',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Inspire your day',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItems(BuildContext context) {
    final drawerItems = [
      {
        'icon': 'home',
        'title': 'Home',
        'route': '/home-screen',
      },
      {
        'icon': 'favorite',
        'title': 'Favorites',
        'route': '/favorites-screen',
      },
      {
        'icon': 'category',
        'title': 'Categories',
        'route': '/category-quotes-screen',
      },
      {
        'icon': 'edit',
        'title': 'Create Quote',
        'route': '/quote-editor-screen',
      },
      {
        'icon': 'settings',
        'title': 'Settings',
        'route': '/settings-screen',
      },
    ];

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      children: drawerItems
          .map((item) => _buildDrawerItem(
                context,
                item['icon'] as String,
                item['title'] as String,
                item['route'] as String,
              ))
          .toList(),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String icon, String title, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: ListTile(
        leading: Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (!isSelected) {
            Navigator.pushNamed(context, route);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selected: isSelected,
        selectedTileColor:
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          SizedBox(height: 1.h),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'star_rate',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 5.w,
            ),
            title: Text(
              'Rate Us',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              _showRateDialog(context);
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'contact_support',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            title: Text(
              'Contact Us',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              _showContactDialog(context);
            },
          ),
          SizedBox(height: 1.h),
          Text(
            'Version 1.0.0',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate QuoteMaster'),
        content: const Text(
            'Enjoying QuoteMaster? Please take a moment to rate us on the app store!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open app store rating
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Us'),
        content: const Text(
            'Have feedback or questions? We\'d love to hear from you!\n\nEmail: support@quotemaster.com'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open email client
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }
}
