import 'package:flutter/cupertino.dart';
import 'package:navigator/week_of_widget/16_nested_scroll_view.dart';

import 'default_layout.dart';

/*
 작성일 : 2021-02-08
 작성자 : Mark,
 화면명 : (화면명),
 경로 : 없음
 클래스 : BarChangeNestedLayout,
 설명 : top Bar 가 바뀌는 NestedScrollView Layout
*/

// ignore: must_be_immutable
class BarChangeNestedLayout extends StatefulWidget {
  BarChangeNestedLayout({
    Key? key,
    required this.expandedHeight,
    required this.expandedTopBar,
    required this.collapsedTopBar,
    required this.body,
    this.collapsedHeight = 0,
    this.floating = false,
    this.pinned = true,
  }) : super(key: key);

  final double expandedHeight;
  final Widget expandedTopBar, collapsedTopBar, body;
  double collapsedHeight;
  bool pinned, floating;
  @override
  BarChangeNestedLayoutState createState() => BarChangeNestedLayoutState();
}

class BarChangeNestedLayoutState extends State<BarChangeNestedLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: NestedScrollView(
        floatHeaderSlivers: widget.floating,
        headerSliverBuilder: _headerSliverBuilder,
        body: widget.body,
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverPersistentHeader(
        pinned: widget.pinned,
        floating: widget.floating,
        delegate: SliverHeaderDelegateCS(
          minHeight: widget.collapsedHeight,
          maxHeight: widget.expandedHeight,
          minChild: widget.collapsedTopBar,
          maxChild: widget.expandedTopBar,
        ),
      ),
    ];
  }
}
