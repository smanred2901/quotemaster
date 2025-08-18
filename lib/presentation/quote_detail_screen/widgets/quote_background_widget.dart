import 'package:flutter/material.dart';

class QuoteBackgroundWidget extends StatelessWidget {
  final String? backgroundImageUrl;
  final List<Color>? gradientColors;
  final Widget child;

  const QuoteBackgroundWidget({
    super.key,
    this.backgroundImageUrl,
    this.gradientColors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors!,
              )
            : null,
        image: backgroundImageUrl != null
            ? DecorationImage(
                image: NetworkImage(backgroundImageUrl!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.3),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: child,
      ),
    );
  }
}
