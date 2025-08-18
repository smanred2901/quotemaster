import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/category_quotes_screen/category_quotes_screen.dart';
import '../presentation/quote_editor_screen/quote_editor_screen.dart';
import '../presentation/favorites_screen/favorites_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/quote_detail_screen/quote_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String categoryQuotes = '/category-quotes-screen';
  static const String quoteEditor = '/quote-editor-screen';
  static const String favorites = '/favorites-screen';
  static const String home = '/home-screen';
  static const String quoteDetail = '/quote-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    categoryQuotes: (context) => const CategoryQuotesScreen(),
    quoteEditor: (context) => const QuoteEditorScreen(),
    favorites: (context) => const FavoritesScreen(),
    home: (context) => const HomeScreen(),
    quoteDetail: (context) => const QuoteDetailScreen(),
    // TODO: Add your other routes here
  };
}
