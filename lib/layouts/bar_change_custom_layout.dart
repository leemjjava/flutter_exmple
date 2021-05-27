import 'package:flutter/cupertino.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:navigator/week_of_widget/16_nested_scroll_view.dart';
/*
 작성일 : 2021-02-08
 작성자 : Mark,
 화면명 : (화면명),
 경로 : 없음
 클래스 : BarChangeCustomLayout,
 설명 : top Bar 가 바뀌고 body 를 SliverToBoxAdapter 로 가지는 CustomScrollView Layout
*/

// ignore: must_be_immutable
class BarChangeCustomLayout extends StatefulWidget {
  BarChangeCustomLayout({
    Key? key,
    required this.expandedTopBar,
    required this.collapsedTopBar,
    required this.body,
    required this.expandedHeight,
    required this.collapsedHeight,
    this.floating = false,
    this.pinned = true,
  }) : super(key: key);

  final double expandedHeight;
  final Widget expandedTopBar, collapsedTopBar, body;
  double collapsedHeight;
  bool floating, pinned;
  @override
  BarChangeCustomLayoutState createState() => BarChangeCustomLayoutState();
}

class BarChangeCustomLayoutState extends State<BarChangeCustomLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: CustomScrollView(
        slivers: <Widget>[
          _renderHeader(),
          SliverToBoxAdapter(
            child: _renderIntrinsicHeight(
              child: widget.body,
            ),
          ),
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
        minChild: widget.expandedTopBar,
        maxChild: widget.collapsedTopBar,
      ),
    );
  }

  Widget _renderIntrinsicHeight({required Widget child}) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Container(
          constraints: BoxConstraints(
            minHeight: _getMinHeight(),
          ),
          child: child,
        ),
      ),
    );
  }

  double _getMinHeight() {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final minusHeight = top + bottom + widget.expandedHeight;
    final height = MediaQuery.of(context).size.height;

    return height - minusHeight;
  }
}
