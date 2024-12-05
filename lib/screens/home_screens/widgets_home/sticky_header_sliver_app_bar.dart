import 'package:flutter/cupertino.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.childBuilder,
  });

  final double minHeight;
  final double maxHeight;
  final Widget Function(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
    double minExtent,
    double maxExtent,
  ) childBuilder;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: childBuilder(
        context,
        shrinkOffset,
        overlapsContent,
        minExtent,
        maxExtent,
      ),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        childBuilder != oldDelegate.childBuilder;
  }
}
