import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuoteCanvasWidget extends StatelessWidget {
  final String quoteText;
  final String authorName;
  final Color? backgroundColor;
  final String? backgroundImageUrl;
  final String fontFamily;
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final Color textColor;
  final TextAlign textAlignment;
  final bool showAuthor;

  const QuoteCanvasWidget({
    super.key,
    required this.quoteText,
    required this.authorName,
    this.backgroundColor,
    this.backgroundImageUrl,
    required this.fontFamily,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.textColor,
    required this.textAlignment,
    required this.showAuthor,
  });

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

  List<Shadow> _getTextShadow() {
    if (backgroundImageUrl != null) {
      return [
        Shadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 4,
          offset: const Offset(2, 2),
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.h,
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.w),
        child: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color:
                    backgroundColor ?? AppTheme.lightTheme.colorScheme.surface,
                gradient: backgroundColor != null
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          backgroundColor!,
                          backgroundColor!.withValues(alpha: 0.8),
                          backgroundColor!.withValues(alpha: 0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      )
                    : null,
              ),
              child: backgroundImageUrl != null
                  ? CustomImageWidget(
                      imageUrl: backgroundImageUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),

            // Enhanced overlay for better text readability
            if (backgroundImageUrl != null)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),

            // Quote content with improved layout
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: textAlignment == TextAlign.left
                    ? CrossAxisAlignment.start
                    : textAlignment == TextAlign.right
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.center,
                children: [
                  // Quote icon for visual enhancement
                  if (quoteText.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 3.h),
                      child: CustomIconWidget(
                        iconName: 'format_quote',
                        size: 10.w,
                        color: textColor.withValues(alpha: 0.3),
                      ),
                    ),

                  // Quote text with enhanced styling
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 35.h,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          quoteText.isNotEmpty
                              ? quoteText
                              : 'Enter your quote here...',
                          style: _getFontStyle(fontFamily).copyWith(
                            fontSize: fontSize.sp,
                            fontWeight:
                                isBold ? FontWeight.bold : FontWeight.w400,
                            fontStyle:
                                isItalic ? FontStyle.italic : FontStyle.normal,
                            color: quoteText.isNotEmpty
                                ? textColor
                                : textColor.withValues(alpha: 0.5),
                            height: 1.5,
                            letterSpacing:
                                fontFamily == 'Playfair Display' ? 0.5 : 0,
                            shadows: _getTextShadow(),
                          ),
                          textAlign: textAlignment,
                        ),
                      ),
                    ),
                  ),

                  // Author name with improved styling
                  if (showAuthor && authorName.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Container(
                      width: double.infinity,
                      alignment: textAlignment == TextAlign.left
                          ? Alignment.centerLeft
                          : textAlignment == TextAlign.right
                              ? Alignment.centerRight
                              : Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: backgroundImageUrl != null
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Text(
                          '— $authorName',
                          style: _getFontStyle(fontFamily).copyWith(
                            fontSize: (fontSize * 0.75).sp,
                            fontWeight: FontWeight.w500,
                            color: textColor.withValues(alpha: 0.85),
                            fontStyle: FontStyle.italic,
                            shadows: _getTextShadow(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Enhanced border with subtle gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
