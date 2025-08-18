import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ColorTabWidget extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;

  const ColorTabWidget({
    super.key,
    required this.onColorSelected,
    required this.selectedColor,
  });

  @override
  State<ColorTabWidget> createState() => _ColorTabWidgetState();
}

class _ColorTabWidgetState extends State<ColorTabWidget> {
  final List<Color> solidColors = [
    Colors.black,
    Colors.white,
    const Color(0xFF2C3E50),
    const Color(0xFF34495E),
    const Color(0xFFE67E22),
    const Color(0xFF27AE60),
    const Color(0xFFF39C12),
    const Color(0xFFE74C3C),
    const Color(0xFF9B59B6),
    const Color(0xFF3498DB),
    const Color(0xFF1ABC9C),
    const Color(0xFFF1C40F),
    const Color(0xFF95A5A6),
    const Color(0xFF7F8C8D),
    const Color(0xFFBDC3C7),
    const Color(0xFFECF0F1),
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFF45B7D1),
    const Color(0xFF96CEB4),
    const Color(0xFFFECA57),
    const Color(0xFFFF9FF3),
    const Color(0xFF54A0FF),
    const Color(0xFF5F27CD),
  ];

  final List<List<Color>> gradientOptions = [
    [const Color(0xFF667eea), const Color(0xFF764ba2)], // Purple Blue
    [const Color(0xFFf093fb), const Color(0xFFf5576c)], // Pink Red
    [const Color(0xFF4facfe), const Color(0xFF00f2fe)], // Blue Cyan
    [const Color(0xFF43e97b), const Color(0xFF38f9d7)], // Green Teal
    [const Color(0xFFffecd2), const Color(0xFFfcb69f)], // Peach Orange
    [const Color(0xFFa8edea), const Color(0xFFfed6e3)], // Mint Pink
    [const Color(0xFFffeaa7), const Color(0xFFdda0dd)], // Yellow Purple
    [const Color(0xFFfbc2eb), const Color(0xFFa6c1ee)], // Pink Blue
    [const Color(0xFFfd79a8), const Color(0xFFfdcb6e)], // Pink Yellow
    [const Color(0xFF6c5ce7), const Color(0xFFa29bfe)], // Purple Lavender
    [const Color(0xFF00b894), const Color(0xFF00cec9)], // Teal Turquoise
    [const Color(0xFFe17055), const Color(0xFFfdcb6e)], // Orange Yellow
  ];

  final List<Color> textColors = [
    Colors.white,
    Colors.black,
    const Color(0xFF2C3E50),
    const Color(0xFF34495E),
    const Color(0xFFE67E22),
    const Color(0xFF27AE60),
    const Color(0xFFF39C12),
    const Color(0xFFE74C3C),
    const Color(0xFF9B59B6),
    const Color(0xFF3498DB),
    const Color(0xFF1ABC9C),
    const Color(0xFFF1C40F),
    const Color(0xFF8E44AD),
    const Color(0xFFD35400),
    const Color(0xFF16A085),
    const Color(0xFFC0392B),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.all(4.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text Colors',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 1,
              ),
              itemCount: textColors.length,
              itemBuilder: (context, index) {
                final color = textColors[index];
                final isSelected = widget.selectedColor == color;

                return GestureDetector(
                  onTap: () => widget.onColorSelected(color),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : color == Colors.white
                                ? AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3)
                                : Colors.transparent,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: color == Colors.white ||
                                      color == const Color(0xFFECF0F1) ||
                                      color == const Color(0xFFF1C40F)
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : Colors.white,
                              size: 4.w,
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            Text(
              'Solid Colors',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 1,
              ),
              itemCount: solidColors.length,
              itemBuilder: (context, index) {
                final color = solidColors[index];
                final isSelected = widget.selectedColor == color;

                return GestureDetector(
                  onTap: () => widget.onColorSelected(color),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : color == Colors.white
                                ? AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3)
                                : Colors.transparent,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: color == Colors.white ||
                                      color == const Color(0xFFECF0F1) ||
                                      color == const Color(0xFFF1C40F)
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : Colors.white,
                              size: 4.w,
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            Text(
              'Gradient Colors',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 2.0,
              ),
              itemCount: gradientOptions.length,
              itemBuilder: (context, index) {
                final gradientColors = gradientOptions[index];
                final primaryColor = gradientColors[0];
                final isSelected = widget.selectedColor == primaryColor;

                return GestureDetector(
                  onTap: () => widget.onColorSelected(primaryColor),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(2.w),
                      border: isSelected
                          ? Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              width: 3,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 4.w,
                              ),
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
