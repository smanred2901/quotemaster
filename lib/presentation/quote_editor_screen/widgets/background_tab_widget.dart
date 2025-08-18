import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BackgroundTabWidget extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Function(String) onImageSelected;
  final Color? selectedColor;
  final String? selectedImageUrl;

  const BackgroundTabWidget({
    super.key,
    required this.onColorSelected,
    required this.onImageSelected,
    this.selectedColor,
    this.selectedImageUrl,
  });

  @override
  State<BackgroundTabWidget> createState() => _BackgroundTabWidgetState();
}

class _BackgroundTabWidgetState extends State<BackgroundTabWidget> {
  final List<Color> gradientColors = [
    const Color(0xFF667eea),
    const Color(0xFFf093fb),
    const Color(0xFF4facfe),
    const Color(0xFF00f2fe),
    const Color(0xFF43e97b),
    const Color(0xFF38f9d7),
    const Color(0xFFffecd2),
    const Color(0xFFfcb69f),
    const Color(0xFFa8edea),
    const Color(0xFFfed6e3),
    const Color(0xFFffeaa7),
    const Color(0xFFdda0dd),
    const Color(0xFFfd79a8),
    const Color(0xFF6c5ce7),
    const Color(0xFF00b894),
    const Color(0xFFe17055),
  ];

  final List<Map<String, dynamic>> backgroundImages = [
    {
      "id": 1,
      "url":
          "https://images.pexels.com/photos/1323712/pexels-photo-1323712.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Mountain"
    },
    {
      "id": 2,
      "url":
          "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Sunset"
    },
    {
      "id": 3,
      "url":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80",
      "category": "Nature"
    },
    {
      "id": 4,
      "url":
          "https://images.pixabay.com/photo/2017/08/10/02/05/tiles-2619332_960_720.jpg",
      "category": "Abstract"
    },
    {
      "id": 5,
      "url":
          "https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Ocean"
    },
    {
      "id": 6,
      "url":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&q=80",
      "category": "Forest"
    },
    {
      "id": 7,
      "url":
          "https://images.pixabay.com/photo/2016/08/11/23/48/mountains-1587287_960_720.jpg",
      "category": "Landscape"
    },
    {
      "id": 8,
      "url":
          "https://images.pexels.com/photos/1287145/pexels-photo-1287145.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Sky"
    },
    {
      "id": 9,
      "url":
          "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800&q=80",
      "category": "Desert"
    },
    {
      "id": 10,
      "url":
          "https://images.pixabay.com/photo/2017/02/01/22/02/mountains-2031539_960_720.jpg",
      "category": "Snow"
    },
    {
      "id": 11,
      "url":
          "https://images.pexels.com/photos/1526814/pexels-photo-1526814.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Flowers"
    },
    {
      "id": 12,
      "url":
          "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=800&q=80",
      "category": "Water"
    },
    {
      "id": 13,
      "url":
          "https://images.pixabay.com/photo/2016/02/13/12/26/aurora-1197753_960_720.jpg",
      "category": "Aurora"
    },
    {
      "id": 14,
      "url":
          "https://images.pexels.com/photos/1670187/pexels-photo-1670187.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Field"
    },
    {
      "id": 15,
      "url":
          "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&q=80",
      "category": "Minimal"
    },
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
              'Gradient Colors',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 8.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: gradientColors.length,
                separatorBuilder: (context, index) => SizedBox(width: 2.w),
                itemBuilder: (context, index) {
                  final color = gradientColors[index];
                  final isSelected = widget.selectedColor == color;

                  return GestureDetector(
                    onTap: () => widget.onColorSelected(color),
                    child: Container(
                      width: 12.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color,
                            color.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2.w),
                        border: isSelected
                            ? Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 2,
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
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 3.w,
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Background Images',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Choose from 15 curated backgrounds',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 0.8,
              ),
              itemCount: backgroundImages.length,
              itemBuilder: (context, index) {
                final image = backgroundImages[index];
                final imageUrl = image["url"] as String;
                final isSelected = widget.selectedImageUrl == imageUrl;

                return GestureDetector(
                  onTap: () => widget.onImageSelected(imageUrl),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: isSelected ? 2 : 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: Stack(
                        children: [
                          CustomImageWidget(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'check',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 5.w,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 1.w,
                            left: 1.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Text(
                                image["category"] as String,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
