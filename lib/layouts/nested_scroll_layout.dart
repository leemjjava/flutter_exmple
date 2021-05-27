import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:navigator/layouts/sliver_height_header_delegate.dart';

/*
 작성일 : 2021-02-15
 작성자 : Mark,
 화면명 : (화면명),
 경로 : 없음
 클래스 : NestedScrollLayout,
 설명 : NestedScrollLayout 파일 body 를 구현할때 ScrollView, ListView 형태도 사용 가능함
       ScrollView 나 ListView 를 사용할 경우 ScrollController 를 따로 제공하면 TopBar 가 작동하지 않음
       ScrollController 로 Scroll 상태를 감시해야 하는 경우 Layout 에 직접 제공해야 함
*/

// ignore: must_be_immutable
class NestedScrollLayout extends StatefulWidget {
  NestedScrollLayout({
    Key? key,
    required this.topBar, //TopBar Widget
    required this.body, //Body Widget
    this.expandedHeight = 100, //넓을 때의 높이
    this.collapsedHeight = 50, //짧을 때의 높이
    this.floating = true, //스크롤 중간에 TopBar 내려오는지 여부 (true: 내려옴)
    this.pinned = true, //TopBar 짧은 높이가 고정되는지 여부 (true: 고정됨)
    this.scrollController,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  ScrollController? scrollController;
  final double expandedHeight, collapsedHeight;
  final Widget topBar, body;
  bool pinned, floating;
  bool? resizeToAvoidBottomInset;

  @override
  NestedHeightListLayoutState createState() => NestedHeightListLayoutState();
}

class NestedHeightListLayoutState extends State<NestedScrollLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: NestedScrollView(
        controller: widget.scrollController,
        floatHeaderSlivers: widget.floating,
        headerSliverBuilder: _headerSliverBuilder,
        body: Padding(
          padding: EdgeInsets.only(top: widget.collapsedHeight),
          child: widget.body,
        ),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: _renderSliverTopBar(),
      ),
    ];
  }

  Widget _renderSliverTopBar() {
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
