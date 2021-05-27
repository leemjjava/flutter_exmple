import 'package:flutter/cupertino.dart';
import 'package:navigator/layouts/sliver_height_header_delegate.dart';

import 'default_layout.dart';

/*
 작성일 : 2021-02-08
 작성자 : Mark,
 화면명 : (화면명),
 경로 : 없음
 클래스 : CustomListLayout,
 설명 : top Bar 의 높이만 바뀌고 SliverList 를 자식으로 가질수 있는 CustomScrollView Layout
*/

// ignore: must_be_immutable
class CustomListLayout extends StatefulWidget {
  CustomListLayout({
    Key? key,
    required this.topBar,
    required this.body,
    this.expandedHeight = 100,
    this.collapsedHeight = 50,
    this.floating = true,
    this.pinned = true,
    this.bottomBtn,
  }) : super(key: key);

  final double expandedHeight;
  final Widget topBar, body;
  double collapsedHeight;
  bool floating, pinned;
  Widget? bottomBtn;

  @override
  CustomListLayoutState createState() => CustomListLayoutState();
}

class CustomListLayoutState extends State<CustomListLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                _renderHeader(),
                widget.body,
              ],
            ),
          ),
          _renderBottomBtn(),
        ],
      ),
    );
  }

  _renderBottomBtn() {
    if (widget.bottomBtn == null) return Container();
    return widget.bottomBtn;
  }

  SliverPersistentHeader _renderHeader() {
    return SliverPersistentHeader(
      pinned: widget.pinned,
      floating: widget.floating,
      delegate: SliverHeightHeaderDelegate(
        minHeight: widget.collapsedHeight,
        maxHeight: widget.expandedHeight,
        child: widget.topBar,
      ),
    );
  }
}
