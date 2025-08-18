import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/quote_context_menu_widget.dart';
import './widgets/quotes_grid_widget.dart';

class CategoryQuotesScreen extends StatefulWidget {
  const CategoryQuotesScreen({super.key});

  @override
  State<CategoryQuotesScreen> createState() => _CategoryQuotesScreenState();
}

class _CategoryQuotesScreenState extends State<CategoryQuotesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _quotes = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _categoryName = "Motivational";
  int _currentPage = 1;
  bool _hasMoreData = true;
  Map<String, dynamic>? _selectedQuote;

  // Mock quotes data
  final List<Map<String, dynamic>> _allQuotes = [
    {
      "id": 1,
      "text":
          "The only way to do great work is to love what you do. Stay hungry, stay foolish, and never settle for mediocrity.",
      "author": "Steve Jobs",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#FF6B6B",
      "isFavorite": false,
    },
    {
      "id": 2,
      "text":
          "Success is not final, failure is not fatal: it is the courage to continue that counts.",
      "author": "Winston Churchill",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1519904981063-b0cf448d479e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#4ECDC4",
      "isFavorite": true,
    },
    {
      "id": 3,
      "text":
          "Believe you can and you're halfway there. The mind is everything. What you think you become.",
      "author": "Theodore Roosevelt",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#45B7D1",
      "isFavorite": false,
    },
    {
      "id": 4,
      "text":
          "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Eleanor Roosevelt",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1519904981063-b0cf448d479e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#96CEB4",
      "isFavorite": false,
    },
    {
      "id": 5,
      "text":
          "It is during our darkest moments that we must focus to see the light.",
      "author": "Aristotle",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#FFEAA7",
      "isFavorite": true,
    },
    {
      "id": 6,
      "text":
          "Don't watch the clock; do what it does. Keep going. Time is precious, make it count.",
      "author": "Sam Levenson",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1519904981063-b0cf448d479e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#DDA0DD",
      "isFavorite": false,
    },
    {
      "id": 7,
      "text":
          "The way to get started is to quit talking and begin doing. Action is the foundational key to all success.",
      "author": "Walt Disney",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#74B9FF",
      "isFavorite": false,
    },
    {
      "id": 8,
      "text":
          "Life is what happens to you while you're busy making other plans. Embrace every moment.",
      "author": "John Lennon",
      "category": "Motivational",
      "backgroundImage":
          "https://images.unsplash.com/photo-1519904981063-b0cf448d479e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": "#FD79A8",
      "isFavorite": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialQuotes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialQuotes() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _quotes = _allQuotes.take(4).toList();
      _isLoading = false;
      _currentPage = 1;
    });
  }

  Future<void> _loadMoreQuotes() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final startIndex = _currentPage * 4;
    final endIndex = (startIndex + 4).clamp(0, _allQuotes.length);

    if (startIndex < _allQuotes.length) {
      final newQuotes = _allQuotes.sublist(startIndex, endIndex);
      setState(() {
        _quotes.addAll(newQuotes);
        _currentPage++;
        _hasMoreData = endIndex < _allQuotes.length;
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshQuotes() async {
    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _quotes = _allQuotes.take(4).toList();
      _currentPage = 1;
      _hasMoreData = true;
      _isRefreshing = false;
    });

    Fluttertoast.showToast(
      msg: "Quotes refreshed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleQuoteTap(Map<String, dynamic> quote) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      '/quote-detail-screen',
      arguments: quote,
    );
  }

  void _handleQuoteLongPress(Map<String, dynamic> quote) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedQuote = quote;
    });
    _showContextMenu(quote);
  }

  void _showContextMenu(Map<String, dynamic> quote) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.w),
        child: QuoteContextMenuWidget(
          quote: quote,
          onAddToFavorites: () => _addToFavorites(quote),
          onShare: () => _shareQuote(quote),
          onEditDesign: () => _editQuoteDesign(quote),
          onDownload: () => _downloadQuote(quote),
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _addToFavorites(Map<String, dynamic> quote) {
    final index = _quotes.indexWhere((q) => q["id"] == quote["id"]);
    if (index != -1) {
      setState(() {
        _quotes[index]["isFavorite"] = !(_quotes[index]["isFavorite"] as bool);
      });

      final isFavorite = _quotes[index]["isFavorite"] as bool;
      Fluttertoast.showToast(
        msg: isFavorite ? "Added to favorites" : "Removed from favorites",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _shareQuote(Map<String, dynamic> quote) {
    final text = quote["text"] as String;
    final author = quote["author"] as String;
    final shareText = "$text\n\n- $author\n\nShared via QuoteMaster";

    Fluttertoast.showToast(
      msg: "Quote shared successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _editQuoteDesign(Map<String, dynamic> quote) {
    Navigator.pushNamed(
      context,
      '/quote-editor-screen',
      arguments: quote,
    );
  }

  void _downloadQuote(Map<String, dynamic> quote) {
    Fluttertoast.showToast(
      msg: "Quote downloaded to gallery",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleBackPressed() {
    Navigator.pop(context);
  }

  void _handleSearchPressed() {
    showSearch(
      context: context,
      delegate: _QuoteSearchDelegate(_quotes),
    );
  }

  void _navigateToQuoteMaker() {
    Navigator.pushNamed(context, '/quote-editor-screen');
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-screen',
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          CategoryHeaderWidget(
            categoryName: _categoryName,
            onBackPressed: _handleBackPressed,
            onSearchPressed: _handleSearchPressed,
          ),
          Expanded(
            child: _quotes.isEmpty && !_isLoading
                ? EmptyStateWidget(
                    onBrowseOtherCategories: _navigateToHome,
                  )
                : RefreshIndicator(
                    onRefresh: _refreshQuotes,
                    color: theme.colorScheme.primary,
                    child: QuotesGridWidget(
                      quotes: _quotes,
                      isLoading: _isLoading,
                      onLoadMore: _loadMoreQuotes,
                      onQuoteTap: _handleQuoteTap,
                      onQuoteLongPress: _handleQuoteLongPress,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToQuoteMaker,
        backgroundColor: theme.colorScheme.tertiary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _QuoteSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> quotes;

  _QuoteSearchDelegate(this.quotes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = quotes.where((quote) {
      final text = (quote["text"] as String).toLowerCase();
      final author = (quote["author"] as String).toLowerCase();
      final searchQuery = query.toLowerCase();
      return text.contains(searchQuery) || author.contains(searchQuery);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final quote = results[index];
        return ListTile(
          title: Text(
            quote["text"] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text("- ${quote["author"]}"),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/quote-detail-screen',
              arguments: quote,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? ['Motivational', 'Success', 'Life', 'Inspiration', 'Dreams']
        : quotes
            .where((quote) => (quote["text"] as String)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .take(5)
            .map((quote) => quote["text"] as String)
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
