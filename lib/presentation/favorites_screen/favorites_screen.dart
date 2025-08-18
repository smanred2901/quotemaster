import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/bulk_action_toolbar.dart';
import './widgets/favorite_quote_card.dart';
import './widgets/favorites_empty_state.dart';
import './widgets/favorites_search_bar.dart';
import './widgets/sort_options_sheet.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _selectedQuotes = <int>{};

  bool _isSelectionMode = false;
  bool _isSearchActive = false;
  String _searchQuery = '';
  SortOption _currentSort = SortOption.recentlyAdded;

  // Mock data for favorite quotes
  final List<Map<String, dynamic>> _allFavoriteQuotes = [
    {
      "id": 1,
      "text":
          "The only way to do great work is to love what you do. If you haven't found it yet, keep looking. Don't settle.",
      "author": "Steve Jobs",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "favoritedAt": DateTime.now().subtract(const Duration(hours: 2)),
      "category": "Motivation"
    },
    {
      "id": 2,
      "text":
          "Life is what happens to you while you're busy making other plans.",
      "author": "John Lennon",
      "backgroundImage":
          "https://images.unsplash.com/photo-1469474968028-56623f02e42e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "favoritedAt": DateTime.now().subtract(const Duration(days: 1)),
      "category": "Life"
    },
    {
      "id": 3,
      "text":
          "Success is not final, failure is not fatal: it is the courage to continue that counts.",
      "author": "Winston Churchill",
      "backgroundImage":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "favoritedAt": DateTime.now().subtract(const Duration(days: 3)),
      "category": "Success"
    },
    {
      "id": 4,
      "text":
          "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Eleanor Roosevelt",
      "backgroundImage":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "favoritedAt": DateTime.now().subtract(const Duration(days: 5)),
      "category": "Dreams"
    },
    {
      "id": 5,
      "text":
          "It is during our darkest moments that we must focus to see the light.",
      "author": "Aristotle",
      "backgroundImage":
          "https://images.unsplash.com/photo-1469474968028-56623f02e42e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "favoritedAt": DateTime.now().subtract(const Duration(days: 7)),
      "category": "Inspiration"
    },
    {
      "id": 6,
      "text": "The way to get started is to quit talking and begin doing.",
      "author": "Walt Disney",
      "backgroundImage":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "favoritedAt": DateTime.now().subtract(const Duration(days: 10)),
      "category": "Action"
    },
  ];

  List<Map<String, dynamic>> get _filteredQuotes {
    List<Map<String, dynamic>> filtered = _allFavoriteQuotes;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((quote) {
        final text = (quote["text"] as String? ?? "").toLowerCase();
        final author = (quote["author"] as String? ?? "").toLowerCase();
        final query = _searchQuery.toLowerCase();
        return text.contains(query) || author.contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_currentSort) {
      case SortOption.recentlyAdded:
        filtered.sort((a, b) {
          final aTime = a["favoritedAt"] as DateTime? ?? DateTime.now();
          final bTime = b["favoritedAt"] as DateTime? ?? DateTime.now();
          return bTime.compareTo(aTime);
        });
        break;
      case SortOption.alphabetical:
        filtered.sort((a, b) {
          final aText = (a["text"] as String? ?? "").toLowerCase();
          final bText = (b["text"] as String? ?? "").toLowerCase();
          return aText.compareTo(bText);
        });
        break;
      case SortOption.byAuthor:
        filtered.sort((a, b) {
          final aAuthor = (a["author"] as String? ?? "").toLowerCase();
          final bAuthor = (b["author"] as String? ?? "").toLowerCase();
          return aAuthor.compareTo(bAuthor);
        });
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedQuotes.clear();
      }
    });
  }

  void _toggleQuoteSelection(int quoteId) {
    setState(() {
      if (_selectedQuotes.contains(quoteId)) {
        _selectedQuotes.remove(quoteId);
      } else {
        _selectedQuotes.add(quoteId);
      }
    });
  }

  void _onQuoteTap(Map<String, dynamic> quote) {
    if (_isSelectionMode) {
      _toggleQuoteSelection(quote["id"] as int);
    } else {
      Navigator.pushNamed(
        context,
        '/quote-detail-screen',
        arguments: quote,
      );
    }
  }

  void _onQuoteLongPress(Map<String, dynamic> quote) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedQuotes.add(quote["id"] as int);
      });
    }
  }

  void _removeFromFavorites(int quoteId) {
    setState(() {
      _allFavoriteQuotes.removeWhere((quote) => quote["id"] == quoteId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Removed from favorites"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            // In a real app, this would restore the quote
          },
        ),
      ),
    );
  }

  void _removeSelectedQuotes() {
    if (_selectedQuotes.isEmpty) return;

    final count = _selectedQuotes.length;
    setState(() {
      _allFavoriteQuotes
          .removeWhere((quote) => _selectedQuotes.contains(quote["id"]));
      _selectedQuotes.clear();
      _isSelectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Removed $count quote${count == 1 ? '' : 's'} from favorites"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            // In a real app, this would restore the quotes
          },
        ),
      ),
    );
  }

  void _shareSelectedQuotes() {
    if (_selectedQuotes.isEmpty) return;

    final selectedQuoteTexts = _allFavoriteQuotes
        .where((quote) => _selectedQuotes.contains(quote["id"]))
        .map((quote) => "${quote["text"]} - ${quote["author"]}")
        .join('\n\n');

    // In a real app, this would use the share package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Sharing ${_selectedQuotes.length} quote${_selectedQuotes.length == 1 ? '' : 's'}"),
      ),
    );

    setState(() {
      _selectedQuotes.clear();
      _isSelectionMode = false;
    });
  }

  void _createCollection() {
    if (_selectedQuotes.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Created collection with ${_selectedQuotes.length} quote${_selectedQuotes.length == 1 ? '' : 's'}"),
      ),
    );

    setState(() {
      _selectedQuotes.clear();
      _isSelectionMode = false;
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsSheet(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
        },
      ),
    );
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
    final filteredQuotes = _filteredQuotes;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isSearchActive
            ? null
            : Text(
                "Favorites",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
        centerTitle: !_isSearchActive,
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _toggleSelectionMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
        actions: _isSelectionMode
            ? [
                TextButton(
                  onPressed: _selectedQuotes.length == filteredQuotes.length
                      ? () {
                          setState(() {
                            _selectedQuotes.clear();
                          });
                        }
                      : () {
                          setState(() {
                            _selectedQuotes.addAll(
                              filteredQuotes.map((quote) => quote["id"] as int),
                            );
                          });
                        },
                  child: Text(
                    _selectedQuotes.length == filteredQuotes.length
                        ? "Deselect All"
                        : "Select All",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
            : [
                if (!_isSearchActive) ...[
                  IconButton(
                    onPressed: _toggleSearch,
                    icon: CustomIconWidget(
                      iconName: 'search',
                      color: theme.colorScheme.onSurface,
                      size: 22,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'sort':
                          _showSortOptions();
                          break;
                        case 'select':
                          _toggleSelectionMode();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'sort',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'sort',
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            const Text('Sort'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'select',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'checklist',
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            const Text('Select'),
                          ],
                        ),
                      ),
                    ],
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: theme.colorScheme.onSurface,
                      size: 22,
                    ),
                  ),
                ],
              ],
      ),
      body: Column(
        children: [
          // Search bar
          if (_isSearchActive)
            FavoritesSearchBar(
              initialQuery: _searchQuery,
              onSearchChanged: _onSearchChanged,
              onClear: _clearSearch,
              isActive: _isSearchActive,
            ),

          // Main content
          Expanded(
            child: filteredQuotes.isEmpty
                ? _searchQuery.isNotEmpty
                    ? _buildNoSearchResults()
                    : FavoritesEmptyState(
                        onDiscoverQuotes: _navigateToHome,
                      )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Simulate refresh
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {});
                    },
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(2.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 2.w,
                      ),
                      itemCount: filteredQuotes.length,
                      itemBuilder: (context, index) {
                        final quote = filteredQuotes[index];
                        final quoteId = quote["id"] as int;

                        return Dismissible(
                          key: Key('quote_$quoteId'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 4.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomIconWidget(
                              iconName: 'delete',
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Remove from favorites?'),
                                content: const Text(
                                    'This quote will be removed from your favorites.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                          color: theme.colorScheme.error),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            _removeFromFavorites(quoteId);
                          },
                          child: FavoriteQuoteCard(
                            quote: quote,
                            onTap: () => _onQuoteTap(quote),
                            onLongPress: () => _onQuoteLongPress(quote),
                            onFavoriteToggle: () =>
                                _removeFromFavorites(quoteId),
                            isSelected: _selectedQuotes.contains(quoteId),
                            isSelectionMode: _isSelectionMode,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomSheet: _isSelectionMode
          ? BulkActionToolbar(
              selectedCount: _selectedQuotes.length,
              onRemoveSelected: _removeSelectedQuotes,
              onShareSelected: _shareSelectedQuotes,
              onCreateCollection: _createCollection,
              onCancel: _toggleSelectionMode,
            )
          : null,
    );
  }

  Widget _buildNoSearchResults() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              "No results found",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Try searching with different keywords",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
