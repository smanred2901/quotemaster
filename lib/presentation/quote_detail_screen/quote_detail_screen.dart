import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/quote_actions_widget.dart';
import './widgets/quote_app_bar_widget.dart';
import './widgets/quote_background_widget.dart';
import './widgets/quote_content_widget.dart';

class QuoteDetailScreen extends StatefulWidget {
  const QuoteDetailScreen({super.key});

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int _currentQuoteIndex = 0;
  bool _isFavorite = false;
  bool _isLoading = false;

  // Mock quote data
  final List<Map<String, dynamic>> _quotes = [
    {
      "id": 1,
      "text":
          "The only way to do great work is to love what you do. If you haven't found it yet, keep looking. Don't settle.",
      "author": "Steve Jobs",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "gradientColors": null,
      "fontFamily": "Inter",
      "fontSize": 18.0,
      "textColor": "white",
      "showAuthor": true,
      "isFavorite": false,
      "views": 1247,
      "favorites": 89,
      "dateAdded": "January 15, 2025"
    },
    {
      "id": 2,
      "text":
          "Success is not final, failure is not fatal: it is the courage to continue that counts.",
      "author": "Winston Churchill",
      "category": "Success",
      "backgroundImage":
          "https://images.unsplash.com/photo-1519904981063-b0cf448d479e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "gradientColors": null,
      "fontFamily": "Playfair",
      "fontSize": 20.0,
      "textColor": "white",
      "showAuthor": true,
      "isFavorite": true,
      "views": 2156,
      "favorites": 234,
      "dateAdded": "January 12, 2025"
    },
    {
      "id": 3,
      "text":
          "Life is what happens to you while you're busy making other plans.",
      "author": "John Lennon",
      "category": "Life",
      "backgroundImage": null,
      "gradientColors": [Color(0xFF667eea), Color(0xFF764ba2)],
      "fontFamily": "Lora",
      "fontSize": 19.0,
      "textColor": "white",
      "showAuthor": true,
      "isFavorite": false,
      "views": 892,
      "favorites": 67,
      "dateAdded": "January 10, 2025"
    },
    {
      "id": 4,
      "text":
          "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Eleanor Roosevelt",
      "category": "Dreams",
      "backgroundImage":
          "https://images.unsplash.com/photo-1469474968028-56623f02e42e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "gradientColors": null,
      "fontFamily": "Merriweather",
      "fontSize": 17.0,
      "textColor": "white",
      "showAuthor": true,
      "isFavorite": false,
      "views": 1543,
      "favorites": 178,
      "dateAdded": "January 8, 2025"
    },
    {
      "id": 5,
      "text": "In the middle of difficulty lies opportunity.",
      "author": "Albert Einstein",
      "category": "Opportunity",
      "backgroundImage": null,
      "gradientColors": [Color(0xFF11998e), Color(0xFF38ef7d)],
      "fontFamily": "Crimson",
      "fontSize": 21.0,
      "textColor": "white",
      "showAuthor": true,
      "isFavorite": true,
      "views": 987,
      "favorites": 123,
      "dateAdded": "January 5, 2025"
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _initializeQuote();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _initializeQuote() {
    // Get quote index from route arguments if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['quoteIndex'] != null) {
        setState(() {
          _currentQuoteIndex = args['quoteIndex'] as int;
          _isFavorite = _quotes[_currentQuoteIndex]['isFavorite'] as bool;
        });
      } else {
        setState(() {
          _isFavorite = _quotes[_currentQuoteIndex]['isFavorite'] as bool;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: GestureDetector(
          onHorizontalDragEnd: _handleSwipeGesture,
          child: Stack(
            children: [
              // Background and quote content
              SlideTransition(
                position: _slideAnimation,
                child: _buildQuoteContent(),
              ),

              // Top app bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: QuoteAppBarWidget(
                  onBackPressed: () => Navigator.of(context).pop(),
                  onMorePressed: () => _showMoreOptions(),
                ),
              ),

              // Bottom actions
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: QuoteActionsWidget(
                  isFavorite: _isFavorite,
                  onEditPressed: _navigateToEditor,
                  onFavoritePressed: _toggleFavorite,
                  onSharePressed: _shareQuote,
                  onDownloadPressed: _downloadQuote,
                ),
              ),

              // Loading overlay
              if (_isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteContent() {
    final currentQuote = _quotes[_currentQuoteIndex];

    return QuoteBackgroundWidget(
      backgroundImageUrl: currentQuote['backgroundImage'] as String?,
      gradientColors: currentQuote['gradientColors'] as List<Color>?,
      child: QuoteContentWidget(
        quoteText: currentQuote['text'] as String,
        authorName: currentQuote['author'] as String,
        fontFamily: currentQuote['fontFamily'] as String,
        fontSize: currentQuote['fontSize'] as double,
        textColor: _parseColor(currentQuote['textColor'] as String),
        showAuthor: currentQuote['showAuthor'] as bool,
      ),
    );
  }

  Color _parseColor(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  void _handleSwipeGesture(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    if (details.primaryVelocity! > 0) {
      // Swipe right - previous quote
      _navigateToPreviousQuote();
    } else if (details.primaryVelocity! < 0) {
      // Swipe left - next quote
      _navigateToNextQuote();
    }
  }

  void _navigateToPreviousQuote() {
    if (_currentQuoteIndex > 0) {
      _slideController.forward().then((_) {
        setState(() {
          _currentQuoteIndex--;
          _isFavorite = _quotes[_currentQuoteIndex]['isFavorite'] as bool;
        });
        _slideController.reverse();
      });
      HapticFeedback.lightImpact();
    }
  }

  void _navigateToNextQuote() {
    if (_currentQuoteIndex < _quotes.length - 1) {
      _slideController.forward().then((_) {
        setState(() {
          _currentQuoteIndex++;
          _isFavorite = _quotes[_currentQuoteIndex]['isFavorite'] as bool;
        });
        _slideController.reverse();
      });
      HapticFeedback.lightImpact();
    }
  }

  void _navigateToEditor() {
    final currentQuote = _quotes[_currentQuoteIndex];
    Navigator.pushNamed(
      context,
      '/quote-editor-screen',
      arguments: {
        'quoteData': currentQuote,
        'isEditing': true,
      },
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _quotes[_currentQuoteIndex]['isFavorite'] = _isFavorite;
    });

    Fluttertoast.showToast(
      msg: _isFavorite ? 'Added to favorites' : 'Removed from favorites',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: _isFavorite ? Colors.red : Colors.grey[600],
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _shareQuote() async {
    setState(() => _isLoading = true);

    // Simulate share processing
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    final currentQuote = _quotes[_currentQuoteIndex];
    final shareText =
        '${currentQuote['showAuthor'] ? '"${currentQuote['text']}" — ${currentQuote['author']}' : '"${currentQuote['text']}"'}\n\nShared via QuoteMaster';

    // In a real app, you would use share_plus package
    Fluttertoast.showToast(
      msg: 'Quote ready to share',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _downloadQuote() async {
    setState(() => _isLoading = true);

    // Simulate download processing
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() => _isLoading = false);

    Fluttertoast.showToast(
      msg: 'Quote saved to gallery',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _showMoreOptions() {
    final currentQuote = _quotes[_currentQuoteIndex];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Quote Information',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                _showQuoteInfo(currentQuote);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Report Quote',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'block',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Hide Similar Quotes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: 'Similar quotes will be hidden',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showQuoteInfo(Map<String, dynamic> quote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quote Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${quote['category']}'),
            const SizedBox(height: 8),
            Text('Added: ${quote['dateAdded']}'),
            const SizedBox(height: 8),
            Text('Views: ${quote['views']}'),
            const SizedBox(height: 8),
            Text('Favorites: ${quote['favorites']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Quote'),
        content: const Text('Why are you reporting this quote?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Quote reported successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}
