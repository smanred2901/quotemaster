import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FontTabWidget extends StatefulWidget {
  final Function(String) onFontSelected;
  final Function(double) onFontSizeChanged;
  final Function(bool) onBoldToggle;
  final Function(bool) onItalicToggle;
  final String selectedFont;
  final double fontSize;
  final bool isBold;
  final bool isItalic;

  const FontTabWidget({
    super.key,
    required this.onFontSelected,
    required this.onFontSizeChanged,
    required this.onBoldToggle,
    required this.onItalicToggle,
    required this.selectedFont,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
  });

  @override
  State<FontTabWidget> createState() => _FontTabWidgetState();
}

class _FontTabWidgetState extends State<FontTabWidget> {
  final List<Map<String, dynamic>> fontOptions = [
    {"name": "Inter", "displayName": "Inter", "style": "Modern"},
    {"name": "Roboto", "displayName": "Roboto", "style": "Clean"},
    {"name": "Open Sans", "displayName": "Open Sans", "style": "Friendly"},
    {"name": "Lato", "displayName": "Lato", "style": "Humanist"},
    {"name": "Montserrat", "displayName": "Montserrat", "style": "Geometric"},
    {"name": "Poppins", "displayName": "Poppins", "style": "Rounded"},
    {"name": "Playfair Display", "displayName": "Playfair", "style": "Elegant"},
    {
      "name": "Dancing Script",
      "displayName": "Dancing Script",
      "style": "Handwriting"
    },
    {"name": "Merriweather", "displayName": "Merriweather", "style": "Serif"},
    {"name": "Source Sans Pro", "displayName": "Source Sans", "style": "Tech"},
    {"name": "Oswald", "displayName": "Oswald", "style": "Bold"},
    {"name": "Raleway", "displayName": "Raleway", "style": "Sophisticated"},
  ];

  TextStyle _getFontStyle(String fontName) {
    switch (fontName) {
      case "Inter":
        return GoogleFonts.inter();
      case "Roboto":
        return GoogleFonts.roboto();
      case "Open Sans":
        return GoogleFonts.openSans();
      case "Lato":
        return GoogleFonts.lato();
      case "Montserrat":
        return GoogleFonts.montserrat();
      case "Poppins":
        return GoogleFonts.poppins();
      case "Playfair Display":
        return GoogleFonts.playfairDisplay();
      case "Dancing Script":
        return GoogleFonts.dancingScript();
      case "Merriweather":
        return GoogleFonts.merriweather();
      case "Source Sans Pro":
        return GoogleFonts.sourceSans3();
      case "Oswald":
        return GoogleFonts.oswald();
      case "Raleway":
        return GoogleFonts.raleway();
      default:
        return GoogleFonts.inter();
    }
  }

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
              'Font Family',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Choose from ${fontOptions.length} beautiful fonts',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 14.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: fontOptions.length,
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
                itemBuilder: (context, index) {
                  final font = fontOptions[index];
                  final fontName = font["name"] as String;
                  final displayName = font["displayName"] as String;
                  final styleDesc = font["style"] as String;
                  final isSelected = widget.selectedFont == fontName;

                  return GestureDetector(
                    onTap: () => widget.onFontSelected(fontName),
                    child: Container(
                      width: 28.w,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: isSelected ? 2 : 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Aa',
                            style: _getFontStyle(fontName).copyWith(
                              fontSize: 20.sp,
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            displayName,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            styleDesc,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                              fontSize: 8.sp,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Text(
                  'Font Size',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    '${widget.fontSize.toInt()}px',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thumbColor: AppTheme.lightTheme.colorScheme.primary,
                overlayColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                trackHeight: 1.2.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.w),
              ),
              child: Slider(
                value: widget.fontSize,
                min: 12.0,
                max: 56.0,
                divisions: 44,
                onChanged: widget.onFontSizeChanged,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Font Style',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onBoldToggle(!widget.isBold),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: widget.isBold
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: widget.isBold
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: widget.isBold ? 2 : 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'format_bold',
                            color: widget.isBold
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Bold',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: widget.isBold
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight: widget.isBold
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onItalicToggle(!widget.isItalic),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: widget.isItalic
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: widget.isItalic
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: widget.isItalic ? 2 : 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'format_italic',
                            color: widget.isItalic
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Italic',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: widget.isItalic
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              fontStyle: widget.isItalic
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
