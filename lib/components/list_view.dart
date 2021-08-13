import 'package:flutter/material.dart';
import 'package:navigator/utile/utile.dart';

class PageListView extends StatefulWidget {
  final itemCount;
  final Function(
    BuildContext context,
    int index,
    double scrollPosition,
  ) builderFunction;

  final Function(int index) onItemTap;

  PageListView({
    required this.builderFunction,
    required this.itemCount,
    required this.onItemTap,
  });

  @override
  PageListViewSate createState() => PageListViewSate();
}

class PageListViewSate extends State<PageListView> {
  final scrollController = ScrollController();
  double scrollPosition = 1;
  int selectIndex = 0;

  PageListViewSate();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(updatePageState);
  }

  void updatePageState() {
    setState(() {
      scrollPosition = scrollController.position.pixels.abs();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(updatePageState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final deviceHeight = constraints.maxHeight * 0.9;

        return ListView.builder(
          controller: scrollController,
          physics: PageScrollPhysics(height: deviceHeight),
          scrollDirection: Axis.vertical,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            final child = widget.builderFunction(context, index, scrollPosition);
            return InkWellCS(
              child: SizedBox(height: deviceHeight, child: child),
              onTap: () => widget.onItemTap(index),
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class PageScrollPhysics extends ScrollPhysics {
  final double height;

  const PageScrollPhysics({
    required this.height,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  PageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PageScrollPhysics(parent: buildParent(ancestor), height: this.height);
  }

  double _getPage(ScrollMetrics position) {
    return position.pixels / this.height;
  }

  double _getPixels(ScrollMetrics position, double page) {
    return page * this.height;
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity)
      page -= 0.5;
    else if (velocity > tolerance.velocity) page += 0.5;
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
