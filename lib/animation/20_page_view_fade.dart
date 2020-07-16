import 'package:flutter/material.dart';

class PageViewFade extends StatefulWidget {
  static const String routeName = '/misc/page_view_fade';
  @override
  PageViewFadeState createState() => PageViewFadeState();
}

class PageViewFadeState extends State<PageViewFade> {
  PageController pageController;
  double pageScrollPosition = 1;

  void updatePageState() {
    setState(() {
      pageScrollPosition = pageController.position.pixels.abs();
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
    );
    pageController.addListener(updatePageState);
  }

  @override
  Widget build(BuildContext context) {
    double statusHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: statusHeight),
        child: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            FadePageItem(
              pageScrollPosition: pageScrollPosition,
              pageNumber: 0,
              child: pageChildPhoto(),
            ),
            FadePageItem(
              pageScrollPosition: pageScrollPosition,
              pageNumber: 1,
              child: pageChildColor(),
            ),
            FadePageItem(
              pageScrollPosition: pageScrollPosition,
              pageNumber: 2,
              child: pageChild("3번째 페이지"),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageChildPhoto() {
    return Column(
      children: <Widget>[
        Expanded(
            child: imageStack("아름다운 경관을 선사하는\n제주도 삼나무 숲", 'assets/forest02.jpg')
        ),
        Expanded(
            child: imageStack("에메랄드 바다의 몰디브는\n어떤 나라일까?", 'assets/sea.jpg')
        ),
      ],
    );
  }

  Widget imageStack(String title, String path){
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(path,
            fit: BoxFit.cover,
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: whiteText(title),
          ),
        ),
      ],
    );
  }

  Widget pageChildColor() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.blueAccent,
            alignment: Alignment.center,
            child: whiteText("Colors blueAccent"),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.greenAccent,
            alignment: Alignment.center,
            child: whiteText("Colors greenAccent"),
          ),
        ),
      ],
    );
  }

  Widget pageChild(String title) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 1],
          colors: [Colors.yellowAccent,Colors.orangeAccent,Colors.pinkAccent],
        ),
      ),
      child: whiteText("3번째 페이지"),
    );
  }

  Widget whiteText(String title){
    return  Text(title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    );
  }

}

// ignore: must_be_immutable
class FadePageItem extends StatelessWidget {
  FadePageItem({
    Key key,
    @required this.pageScrollPosition,
    @required this.pageNumber,
    @required this.child,
  }) : super(key : key);

  double deviceHeight, deviceWidth;
  final pageScrollPosition;
  final pageNumber;
  Widget child;

  @override
  Widget build(BuildContext context) {
    double statusHeight = MediaQuery.of(context).padding.top;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height - statusHeight;

    return Stack(
      children: <Widget>[
        Positioned.fill(child: Container(color: Colors.black)),
        Positioned.fromRect(
          rect: getPageRect(),
          child: Opacity(
            opacity: getPageOpacity(),
            child: Scaffold(
              body: Container(
                child: child,
              )
            ),
          ),
        ),
      ],
    );
  }

  Rect getPageRect(){
    if(checkPageUp()) return Offset(0,0) & Size(deviceWidth, deviceHeight);

    double rectWidth = getRectWidth();
    double rectHeight = getRectHeight();

    double x = (deviceWidth - rectWidth) / 2;
    double y = (deviceHeight - rectHeight) + getNowScrollHeight();

    return Offset(x,y) & Size(rectWidth, rectHeight);
  }

  double getRectWidth(){
    double minRectWidth = deviceWidth * 0.80;
    double rectWidthOffset = (deviceWidth - minRectWidth) * getScrollRatio();
    return minRectWidth + rectWidthOffset;
  }

  double getRectHeight(){
    double minRectHeight = deviceHeight * 0.85;
    double rectHeightOffset = (deviceHeight - minRectHeight) * getScrollRatio();
    return minRectHeight + rectHeightOffset;
  }

  double getNowScrollHeight(){
    double startPagePosition = deviceHeight * pageNumber;
    return pageScrollPosition - startPagePosition;
  }

  double getScrollRatio(){
    double pageViewScrollOffset = deviceHeight - getNowScrollHeight();
    return pageViewScrollOffset / deviceHeight;
  }

  double getPageOpacity(){
    if(checkPageUp()) return 1;

    return getScrollRatio()
        .clamp(0, 1)
        .toDouble();
  }

  bool checkPageUp(){
    if(pageNumber == 0) return false;
    if(pageScrollPosition < deviceHeight * pageNumber) return true;
    return false;
  }

}