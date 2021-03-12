import 'package:flutter/material.dart';

class IndexStackEx extends StatefulWidget {
  static const String routeName = '/week_of_widget/index_stack';

  @override
  _IndexStackExState createState() => _IndexStackExState();
}

class _IndexStackExState extends State<IndexStackEx> with TickerProviderStateMixin {
  final List<Widget> myIcons = [
    Icon(
      Icons.favorite,
      color: Colors.grey,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    Icon(
      Icons.audiotrack,
      color: Colors.grey,
      size: 30.0,
    ),
    Icon(
      Icons.beach_access,
      color: Colors.grey,
      size: 36.0,
    ),
    Icon(
      Icons.cloud,
      color: Colors.grey,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    Icon(
      Icons.computer,
      color: Colors.grey,
      size: 30.0,
    ),
  ];

  late MediaQueryData deviceData;
  late AnimationController _animationController;
  late Animation<Offset> animation;

  int _tabIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: Duration(milliseconds: 500),
    );

    animation = Tween(begin: Offset(1, 0), end: Offset(0.0, 0))
        .chain(CurveTween(curve: Curves.easeOutQuint))
        .animate(_animationController);
//    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    super.initState();
  }

  _handleTabSelection(int index) {
    setState(() {
      _tabIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextStyle whiteText() {
    return TextStyle(color: Colors.white, fontSize: 50);
  }

  @override
  Widget build(BuildContext context) {
    deviceData = MediaQuery.of(context);

    List<Widget> _tabs = [
      MyAnimation(
        animation: animation,
        color: Colors.black,
        child: Text(
          '1 tab',
          style: whiteText(),
        ),
      ),
      MyAnimation(
        animation: animation,
        child: ListView(
          padding: EdgeInsets.only(bottom: 80),
          children: List.generate(
              30,
              (index) => Text(
                    'line: $index',
                    style: whiteText(),
                  )).toList(),
        ),
        color: Colors.blue,
      ),
      MyAnimation(
        animation: animation,
        color: Colors.red,
        child: Text(
          '3 tab',
          style: whiteText(),
        ),
      ),
      MyAnimation(
        animation: animation,
        color: Colors.orange,
        child: Text(
          '4 tab',
          style: whiteText(),
        ),
      ),
      MyAnimation(
        animation: animation,
        color: Colors.green,
        child: TextButton(
          style: TextButton.styleFrom(primary: Colors.grey),
          onPressed: () => print('5 tab!!'),
          child: Text(
            '5 tab',
            style: whiteText(),
          ),
        ),
      ),
    ];

    return Scaffold(
        appBar: AppBar(),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                IndexedStack(
                  children: _tabs,
                  index: _tabIndex,
                ),
                Positioned(
                  height: 70,
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: bottomButtons(),
                )
              ],
            )));
  }

  Widget bottomButtons() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: Color(0xFFFFEBEE),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          border: Border.all(width: 1, color: Color(0xFFEF9A9A))),
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: bottomsColumn(),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              left: getPosition(_tabIndex),
              curve: Curves.easeOutQuint,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x552979FF),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                height: 60,
                width: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getPosition(int index) {
    double width = deviceData.size.width - 32;
    double padding = (width - (60 * 5)) / 4;

    return (index * 60) + (padding * index);
  }

  Widget bottomsColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<GestureDetector>.generate(5, (index) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            width: 60,
            height: 60,
            child: Center(
              child: myIcons[index],
            ),
          ),
          onTap: () {
            _handleTabSelection(index);
          },
        );
      }),
    );
  }
}

class MyAnimation extends AnimatedWidget {
  MyAnimation({
    key,
    required this.animation,
    required this.child,
    required this.color,
  }) : super(
          key: key,
          listenable: animation,
        );

  final Widget child;
  final Color color;
  final Animation<Offset> animation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Container(
        alignment: Alignment.center,
        color: color,
        height: double.infinity,
        width: double.infinity,
        child: child,
      ),
    );
  }
}
