import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BulkActionToolbar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onRemoveSelected;
  final VoidCallback? onShareSelected;
  final VoidCallback? onCreateCollection;
  final VoidCallback? onCancel;

  const BulkActionToolbar({
    super.key,
    required this.selectedCount,
    this.onRemoveSelected,
    this.onShareSelected,
    this.onCreateCollection,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Cancel button
            TextButton(
              onPressed: onCancel,
              child: Text(
                "Cancel",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            // Selected count
            Expanded(
              child: Text(
                "$selectedCount selected",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 2.w),
            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Share button
                IconButton(
                  onPressed: selectedCount > 0 ? onShareSelected : null,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: selectedCount > 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                    size: 22,
                  ),
                  tooltip: "Share selected",
                ),
                // Create collection button
                IconButton(
                  onPressed: selectedCount > 0 ? onCreateCollection : null,
                  icon: CustomIconWidget(
                    iconName: 'collections_bookmark',
                    color: selectedCount > 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                    size: 22,
                  ),
                  tooltip: "Create collection",
                ),
                // Remove button
                IconButton(
                  onPressed: selectedCount > 0 ? onRemoveSelected : null,
                  icon: CustomIconWidget(
                    iconName: 'delete_outline',
                    color: selectedCount > 0
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                    size: 22,
                  ),
                  tooltip: "Remove from favorites",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
