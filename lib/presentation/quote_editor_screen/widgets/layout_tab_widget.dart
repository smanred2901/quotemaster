import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LayoutTabWidget extends StatefulWidget {
  final Function(TextAlign) onAlignmentChanged;
  final Function(bool) onAuthorVisibilityToggle;
  final TextAlign textAlignment;
  final bool showAuthor;

  const LayoutTabWidget({
    super.key,
    required this.onAlignmentChanged,
    required this.onAuthorVisibilityToggle,
    required this.textAlignment,
    required this.showAuthor,
  });

  @override
  State<LayoutTabWidget> createState() => _LayoutTabWidgetState();
}

class _LayoutTabWidgetState extends State<LayoutTabWidget> {
  final List<Map<String, dynamic>> alignmentOptions = [
    {"alignment": TextAlign.left, "icon": "format_align_left", "label": "Left"},
    {
      "alignment": TextAlign.center,
      "icon": "format_align_center",
      "label": "Center"
    },
    {
      "alignment": TextAlign.right,
      "icon": "format_align_right",
      "label": "Right"
    },
    {
      "alignment": TextAlign.justify,
      "icon": "format_align_justify",
      "label": "Justify"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Text Alignment',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.w,
              childAspectRatio: 2.5,
            ),
            itemCount: alignmentOptions.length,
            itemBuilder: (context, index) {
              final option = alignmentOptions[index];
              final alignment = option["alignment"] as TextAlign;
              final iconName = option["icon"] as String;
              final label = option["label"] as String;
              final isSelected = widget.textAlignment == alignment;

              return GestureDetector(
                onTap: () => widget.onAlignmentChanged(alignment),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: isSelected ? 2 : 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: iconName,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        label,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          Text(
            'Author Display',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Show Author Name',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Display the author name below the quote text',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 3.w),
                Switch(
                  value: widget.showAuthor,
                  onChanged: widget.onAuthorVisibilityToggle,
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveThumbColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  inactiveTrackColor: AppTheme
                      .lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Preview your changes in real-time on the canvas above',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
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
}
