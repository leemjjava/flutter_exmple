import 'package:flutter/material.dart';
import 'package:navigator/components/musinsa_list/musinsa_list_item.dart';
import 'package:navigator/utile/utile.dart';

class MusinsaListView extends StatefulWidget {
  final int itemCount;
  final Function(
    BuildContext context,
    int index,
  ) builderFunction;

  final Function(int index) onItemTap;

  MusinsaListView({
    required this.builderFunction,
    required this.itemCount,
    required this.onItemTap,
  });

  @override
  MusinsaListViewSate createState() => MusinsaListViewSate();
}

class MusinsaListViewSate extends State<MusinsaListView> {
  final scrollController = PageController();
  double scrollPosition = 1;
  int selectIndex = 0;

  MusinsaListViewSate();

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
        return ListView.builder(
          controller: scrollController,
          physics: PageScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            final child = _pageListViewBuilder(context, index, scrollPosition);

            return InkWellCS(
              child: SizedBox(width: constraints.maxWidth, child: child),
              onTap: () => widget.onItemTap(index),
            );
          },
        );
      },
    );
  }

  _pageListViewBuilder(BuildContext context, int index, double scrollPosition) {
    return MusinsaItemCS(
      pageScrollPosition: scrollPosition,
      pageNumber: index,
      builderFunction: (context) => widget.builderFunction(context, index),
      radius: 4,
    );
  }
}
