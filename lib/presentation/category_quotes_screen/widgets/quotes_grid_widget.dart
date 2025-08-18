import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './quote_card_widget.dart';
import './skeleton_card_widget.dart';

class QuotesGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> quotes;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final Function(Map<String, dynamic>) onQuoteTap;
  final Function(Map<String, dynamic>) onQuoteLongPress;

  const QuotesGridWidget({
    super.key,
    required this.quotes,
    required this.isLoading,
    required this.onLoadMore,
    required this.onQuoteTap,
    required this.onQuoteLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        padding: EdgeInsets.all(3.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 3.w,
          childAspectRatio: 3 / 4,
        ),
        itemCount: quotes.length + (isLoading ? 4 : 0),
        itemBuilder: (context, index) {
          if (index >= quotes.length) {
            return const SkeletonCardWidget();
          }

          final quote = quotes[index];
          return QuoteCardWidget(
            quote: quote,
            onTap: () => onQuoteTap(quote),
            onLongPress: () => onQuoteLongPress(quote),
          );
        },
      ),
    );
  }
}
