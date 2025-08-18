import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteContentWidget extends StatelessWidget {
  final String quoteText;
  final String authorName;
  final String fontFamily;
  final double fontSize;
  final Color textColor;
  final bool showAuthor;

  const QuoteContentWidget({
    super.key,
    required this.quoteText,
    required this.authorName,
    this.fontFamily = 'Inter',
    this.fontSize = 18.0,
    this.textColor = Colors.white,
    this.showAuthor = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _copyToClipboard(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Quote text
            Text(
              '"$quoteText"',
              textAlign: TextAlign.center,
              style: _getTextStyle(),
              maxLines: null,
            ),
            if (showAuthor && authorName.isNotEmpty) ...[
              SizedBox(height: 3.h),
              // Author name
              Text(
                '— $authorName',
                textAlign: TextAlign.center,
                style: _getAuthorStyle(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  TextStyle _getTextStyle() {
    switch (fontFamily.toLowerCase()) {
      case 'playfair':
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.4,
          letterSpacing: 0.5,
        );
      case 'merriweather':
        return GoogleFonts.merriweather(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.4,
          letterSpacing: 0.3,
        );
      case 'lora':
        return GoogleFonts.lora(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.4,
          letterSpacing: 0.2,
        );
      case 'crimson':
        return GoogleFonts.crimsonText(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.4,
          letterSpacing: 0.3,
        );
      default:
        return GoogleFonts.inter(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.4,
          letterSpacing: 0.2,
        );
    }
  }

  TextStyle _getAuthorStyle() {
    return GoogleFonts.inter(
      fontSize: (fontSize - 2).sp,
      fontWeight: FontWeight.w500,
      color: textColor.withValues(alpha: 0.9),
      fontStyle: FontStyle.italic,
      letterSpacing: 0.5,
    );
  }

  void _copyToClipboard(BuildContext context) {
    final textToCopy = showAuthor && authorName.isNotEmpty
        ? '"$quoteText" — $authorName'
        : '"$quoteText"';

    Clipboard.setData(ClipboardData(text: textToCopy));
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Quote copied to clipboard',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
