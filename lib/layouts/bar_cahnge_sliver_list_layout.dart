import 'package:flutter/cupertino.dart';
import 'package:navigator/week_of_widget/16_nested_scroll_view.dart';

import 'default_layout.dart';

/*
 작성일 : 2021-02-08
 작성자 : Mark,
 화면명 : (화면명),
 경로 : 없음
 클래스 : BarChangeSliverListLayout,
 설명 : top Bar 가 바뀌고 body 를 Sliver List 로 가지는 CustomScrollView Layout
*/

// ignore: must_be_immutable
class BarChangeSliverListLayout extends StatefulWidget {
  BarChangeSliverListLayout({
    Key? key,
    required this.expandedTopBar,
    required this.collapsedTopBar,
    required this.body,
    required this.expandedHeight,
    this.collapsedHeight = 0,
    this.floating = false,
    this.pinned = true,
  }) : super(key: key);

  final double expandedHeight;
  final Widget expandedTopBar, collapsedTopBar;
  final SliverFixedExtentList body;
  double collapsedHeight;
  bool pinned, floating;
  @override
  BarChangeSliverListLayoutState createState() => BarChangeSliverListLayoutState();
}

class BarChangeSliverListLayoutState extends State<BarChangeSliverListLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: CustomScrollView(
        slivers: <Widget>[
          _renderHeader(),
          widget.body,
        ],
      ),
    );
  }

  Widget _renderHeader() {
    return SliverPersistentHeader(
      pinned: widget.pinned,
      floating: widget.floating,
      delegate: SliverHeaderDelegateCS(
        minHeight: widget.collapsedHeight,
        maxHeight: widget.expandedHeight,
        minChild: widget.collapsedTopBar,
        maxChild: widget.expandedTopBar,
      ),
    );
  }
}
