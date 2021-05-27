import 'dart:math';
import 'package:flutter/material.dart';

class SliverHeightHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverHeightHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    this.bgColor,
  });
  final double minHeight, maxHeight;
  final Widget child;
  final Color? bgColor;

  late double visibleMainHeight, width;

  @override
  bool shouldRebuild(SliverHeightHeaderDelegate oldDelegate) => true;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    width = MediaQuery.of(context).size.width;
    visibleMainHeight = max(maxHeight - shrinkOffset, minExtent);

    return Container(
      height: visibleMainHeight,
      width: MediaQuery.of(context).size.width,
      color: bgColor == null ? Color(0xFFFFFFFF) : bgColor,
      child: Stack(
        children: <Widget>[
          getMaxTop(),
        ],
      ),
    );
  }

  Widget getMaxTop() {
    return Positioned(
      bottom: 0.0,
      child: SizedBox(
        width: width,
        child: child,
      ),
    );
  }
}
