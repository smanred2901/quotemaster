import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuoteActionsWidget extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onEditPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onSharePressed;
  final VoidCallback onDownloadPressed;

  const QuoteActionsWidget({
    super.key,
    required this.isFavorite,
    required this.onEditPressed,
    required this.onFavoritePressed,
    required this.onSharePressed,
    required this.onDownloadPressed,
  });

  @override
  State<QuoteActionsWidget> createState() => _QuoteActionsWidgetState();
}

class _QuoteActionsWidgetState extends State<QuoteActionsWidget>
    with TickerProviderStateMixin {
  late AnimationController _favoriteController;
  late Animation<double> _favoriteAnimation;

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: 'edit',
              label: 'Edit Design',
              onPressed: widget.onEditPressed,
              theme: theme,
            ),
            _buildFavoriteButton(theme),
            _buildActionButton(
              icon: 'share',
              label: 'Share',
              onPressed: widget.onSharePressed,
              theme: theme,
            ),
            _buildActionButton(
              icon: 'download',
              label: 'Download',
              onPressed: widget.onDownloadPressed,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _favoriteController.forward().then((_) {
          _favoriteController.reverse();
        });
        widget.onFavoritePressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: widget.isFavorite
              ? Colors.red.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isFavorite
                ? Colors.red.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _favoriteAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _favoriteAnimation.value,
                  child: CustomIconWidget(
                    iconName:
                        widget.isFavorite ? 'favorite' : 'favorite_border',
                    color: widget.isFavorite ? Colors.red : Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
            SizedBox(height: 0.5.h),
            Text(
              widget.isFavorite ? 'Favorited' : 'Favorite',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: widget.isFavorite ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
