import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _taglineController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _taglineOpacityAnimation;
  late Animation<Offset> _taglineSlideAnimation;

  bool _isInitialized = false;
  String _loadingStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Tagline animation controller
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Tagline opacity animation
    _taglineOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeIn,
    ));

    // Tagline slide animation
    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _startInitialization() async {
    try {
      // Start logo animation immediately
      _logoController.forward();

      // Wait for logo animation to reach 60% completion
      await Future.delayed(const Duration(milliseconds: 900));

      // Start tagline animation
      _taglineController.forward();

      // Simulate initialization tasks
      await _performInitializationTasks();

      // Ensure minimum splash duration
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        _navigateToHome();
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _loadingStatus = 'Loading cached content...';
        });

        // Still navigate to home even if some initialization fails
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          _navigateToHome();
        }
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    // Simulate loading cached quotes
    setState(() {
      _loadingStatus = 'Loading quotes...';
    });
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulate checking network connectivity
    setState(() {
      _loadingStatus = 'Checking connectivity...';
    });
    await Future.delayed(const Duration(milliseconds: 400));

    // Simulate initializing services
    setState(() {
      _loadingStatus = 'Preparing categories...';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _loadingStatus = 'Ready!';
      _isInitialized = true;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home-screen');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                AppTheme.lightTheme.colorScheme.secondary,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Section
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Opacity(
                              opacity: _logoOpacityAnimation.value,
                              child: _buildLogo(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 4.h),

                      // Tagline Section
                      AnimatedBuilder(
                        animation: _taglineController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _taglineSlideAnimation,
                            child: Opacity(
                              opacity: _taglineOpacityAnimation.value,
                              child: _buildTagline(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Loading Section
                _buildLoadingSection(),

                SizedBox(height: 6.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'format_quote',
            color: Colors.white,
            size: 12.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'QM',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 6.w,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagline() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Text(
            'QuoteMaster',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 8.w,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Inspire • Create • Share',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w400,
              fontSize: 4.w,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Container(
            width: 20.w,
            height: 0.3.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading indicator
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Loading status text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _loadingStatus,
            key: ValueKey(_loadingStatus),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
              fontSize: 3.5.w,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 1.h),

        // Progress dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: _isInitialized ? 2.w : 1.w,
              height: _isInitialized ? 2.w : 1.w,
              decoration: BoxDecoration(
                color: _isInitialized
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(1.w),
              ),
            );
          }),
        ),
      ],
    );
  }
}
