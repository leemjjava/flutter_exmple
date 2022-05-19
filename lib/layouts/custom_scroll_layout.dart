import 'package:flutter/material.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:navigator/layouts/sliver_height_header_delegate.dart';

/*
 작성일 : 2021-02-15
 작성자 : Mark,
 화면명 : (화면명),
 경로 : 없음
 클래스 : NestedScrollLayout,
 설명 : CustomScrollLayout 파일 body 를 구현할때 ScrollView, ListView 사용하면 안됨
       기본적으로 ScrollView 가 깔려 있는 형태이기 때문에 그 아래에 들어가는 Layout 만 구현해서 제공해야함
       ListView 를 사용해야 하는 경우 NestedScrollLayout 을 사용해야 함.
*/

// ignore: must_be_immutable
class CustomScrollLayout extends StatefulWidget {
  CustomScrollLayout({
    Key? key,
    required this.topBar, //TopBar Widget
    required this.body, //Body Widget
    this.expandedHeight = 100, //넓을 때의 높이
    this.collapsedHeight = 50, //짧을 때의 높이
    this.floating = true, //스크롤 중간에 TopBar 내려오는지 여부 (true: 내려옴)
    this.pinned = true, //TopBar 짧은 높이가 고정되는지 여부 (true: 고정됨)
    this.scrollController,
    this.bgColor = Colors.white,
    this.useSafeArea = true,
  }) : super(key: key);

  ScrollController? scrollController;
  final double expandedHeight;
  final Widget topBar, body;
  double collapsedHeight;
  bool floating, pinned;
  bool useSafeArea;
  Color bgColor;

  @override
  CustomScrollLayoutState createState() => CustomScrollLayoutState();
}

class CustomScrollLayoutState extends State<CustomScrollLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      useSafeArea: widget.useSafeArea,
      backgroundColor: widget.bgColor,
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          _renderHeader(),
          _renderIntrinsicHeight(),
        ],
      ),
    );
  }

  SliverPersistentHeader _renderHeader() {
    return SliverPersistentHeader(
      pinned: widget.pinned,
      floating: widget.floating,
      delegate: SliverHeightHeaderDelegate(
        bgColor: widget.bgColor,
        minHeight: widget.collapsedHeight,
        maxHeight: widget.expandedHeight,
        child: widget.topBar,
      ),
    );
  }

  //SingeChildScrollView 아래에 IntrinsicHeight 넣음
  //그 아래에 Min Height 지정한 Container 넣음
  //IntrinsicHeight Doc 에는 상대적으로 비용이 많이 든다는 경고가 있음
  //https://api.flutter.dev/flutter/widgets/IntrinsicHeight-class.html
  Widget _renderIntrinsicHeight() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
            color: widget.bgColor,
            constraints: BoxConstraints(
              minHeight: _getMinHeight(),
            ),
            child: widget.body,
          ),
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
