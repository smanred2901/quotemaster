import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/background_tab_widget.dart';
import './widgets/color_tab_widget.dart';
import './widgets/font_tab_widget.dart';
import './widgets/layout_tab_widget.dart';
import './widgets/quote_canvas_widget.dart';

class QuoteEditorScreen extends StatefulWidget {
  const QuoteEditorScreen({super.key});

  @override
  State<QuoteEditorScreen> createState() => _QuoteEditorScreenState();
}

class _QuoteEditorScreenState extends State<QuoteEditorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final FocusNode _quoteFocusNode = FocusNode();
  final FocusNode _authorFocusNode = FocusNode();

  // Quote customization properties
  String _quoteText = '';
  String _authorName = '';
  Color? _backgroundColor = const Color(0xFF667eea);
  String? _backgroundImageUrl;
  String _fontFamily = 'Inter';
  double _fontSize = 18.0;
  bool _isBold = false;
  bool _isItalic = false;
  Color _textColor = Colors.white;
  TextAlign _textAlignment = TextAlign.center;
  bool _showAuthor = true;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _tabData = [
    {"title": "Backgrounds", "icon": "palette"},
    {"title": "Fonts", "icon": "text_fields"},
    {"title": "Colors", "icon": "color_lens"},
    {"title": "Layout", "icon": "format_align_center"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabData.length, vsync: this);
    _quoteController.addListener(_onQuoteTextChanged);
    _authorController.addListener(_onAuthorTextChanged);

    // Set initial values
    _quoteText = 'The only way to do great work is to love what you do.';
    _authorName = 'Steve Jobs';
    _quoteController.text = _quoteText;
    _authorController.text = _authorName;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quoteController.dispose();
    _authorController.dispose();
    _quoteFocusNode.dispose();
    _authorFocusNode.dispose();
    super.dispose();
  }

  void _onQuoteTextChanged() {
    setState(() {
      _quoteText = _quoteController.text;
    });
  }

  void _onAuthorTextChanged() {
    setState(() {
      _authorName = _authorController.text;
    });
  }

  void _onBackgroundColorSelected(Color color) {
    setState(() {
      _backgroundColor = color;
      _backgroundImageUrl = null;
    });
    HapticFeedback.lightImpact();
  }

  void _onBackgroundImageSelected(String imageUrl) {
    setState(() {
      _backgroundImageUrl = imageUrl;
      _backgroundColor = null;
    });
    HapticFeedback.lightImpact();
  }

  void _onFontSelected(String fontFamily) {
    setState(() {
      _fontFamily = fontFamily;
    });
    HapticFeedback.lightImpact();
  }

  void _onFontSizeChanged(double fontSize) {
    setState(() {
      _fontSize = fontSize;
    });
  }

  void _onBoldToggle(bool isBold) {
    setState(() {
      _isBold = isBold;
    });
    HapticFeedback.lightImpact();
  }

  void _onItalicToggle(bool isItalic) {
    setState(() {
      _isItalic = isItalic;
    });
    HapticFeedback.lightImpact();
  }

  void _onTextColorSelected(Color color) {
    setState(() {
      _textColor = color;
    });
    HapticFeedback.lightImpact();
  }

  void _onAlignmentChanged(TextAlign alignment) {
    setState(() {
      _textAlignment = alignment;
    });
    HapticFeedback.lightImpact();
  }

  void _onAuthorVisibilityToggle(bool showAuthor) {
    setState(() {
      _showAuthor = showAuthor;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _saveQuote() async {
    if (_quoteText.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a quote to save",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate saving process
      await Future.delayed(const Duration(seconds: 2));

      Fluttertoast.showToast(
        msg: "Quote saved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      HapticFeedback.mediumImpact();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save quote. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetEditor() {
    setState(() {
      _quoteText = '';
      _authorName = '';
      _backgroundColor = const Color(0xFF667eea);
      _backgroundImageUrl = null;
      _fontFamily = 'Inter';
      _fontSize = 18.0;
      _isBold = false;
      _isItalic = false;
      _textColor = Colors.white;
      _textAlignment = TextAlign.center;
      _showAuthor = true;
    });

    _quoteController.clear();
    _authorController.clear();

    Fluttertoast.showToast(
      msg: "Editor reset",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Quote Editor',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
            onPressed: _resetEditor,
          ),
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveQuote,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 4.w,
                      height: 4.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Save',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quote Canvas
          QuoteCanvasWidget(
            quoteText: _quoteText,
            authorName: _authorName,
            backgroundColor: _backgroundColor,
            backgroundImageUrl: _backgroundImageUrl,
            fontFamily: _fontFamily,
            fontSize: _fontSize,
            isBold: _isBold,
            isItalic: _isItalic,
            textColor: _textColor,
            textAlignment: _textAlignment,
            showAuthor: _showAuthor,
          ),

          // Text Input Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                TextField(
                  controller: _quoteController,
                  focusNode: _quoteFocusNode,
                  maxLines: 3,
                  maxLength: 280,
                  decoration: InputDecoration(
                    hintText: 'Enter your quote here...',
                    labelText: 'Quote Text',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'format_quote',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                    counterStyle: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: _authorController,
                  focusNode: _authorFocusNode,
                  maxLength: 50,
                  decoration: InputDecoration(
                    hintText: 'Author name (optional)',
                    labelText: 'Author',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                    counterStyle: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppTheme.lightTheme.colorScheme.primary,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              indicatorWeight: 2,
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
              tabs: _tabData.map((tab) {
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: tab["icon"] as String,
                        size: 4.w,
                        color: _tabController.index == _tabData.indexOf(tab)
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 2.w),
                      Text(tab["title"] as String),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BackgroundTabWidget(
                  onColorSelected: _onBackgroundColorSelected,
                  onImageSelected: _onBackgroundImageSelected,
                  selectedColor: _backgroundColor,
                  selectedImageUrl: _backgroundImageUrl,
                ),
                FontTabWidget(
                  onFontSelected: _onFontSelected,
                  onFontSizeChanged: _onFontSizeChanged,
                  onBoldToggle: _onBoldToggle,
                  onItalicToggle: _onItalicToggle,
                  selectedFont: _fontFamily,
                  fontSize: _fontSize,
                  isBold: _isBold,
                  isItalic: _isItalic,
                ),
                ColorTabWidget(
                  onColorSelected: _onTextColorSelected,
                  selectedColor: _textColor,
                ),
                LayoutTabWidget(
                  onAlignmentChanged: _onAlignmentChanged,
                  onAuthorVisibilityToggle: _onAuthorVisibilityToggle,
                  textAlignment: _textAlignment,
                  showAuthor: _showAuthor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
