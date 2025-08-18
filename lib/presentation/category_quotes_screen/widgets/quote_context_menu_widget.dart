import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuoteContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> quote;
  final VoidCallback onAddToFavorites;
  final VoidCallback onShare;
  final VoidCallback onEditDesign;
  final VoidCallback onDownload;
  final VoidCallback onClose;

  const QuoteContextMenuWidget({
    super.key,
    required this.quote,
    required this.onAddToFavorites,
    required this.onShare,
    required this.onEditDesign,
    required this.onDownload,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Quote Options',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            context,
            icon: 'favorite_border',
            title: 'Add to Favorites',
            onTap: () {
              HapticFeedback.lightImpact();
              onAddToFavorites();
              onClose();
            },
          ),
          _buildMenuItem(
            context,
            icon: 'share',
            title: 'Share Quote',
            onTap: () {
              HapticFeedback.lightImpact();
              onShare();
              onClose();
            },
          ),
          _buildMenuItem(
            context,
            icon: 'edit',
            title: 'Edit Design',
            onTap: () {
              HapticFeedback.lightImpact();
              onEditDesign();
              onClose();
            },
          ),
          _buildMenuItem(
            context,
            icon: 'download',
            title: 'Download',
            onTap: () {
              HapticFeedback.lightImpact();
              onDownload();
              onClose();
            },
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.onSurface,
              size: 22,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
