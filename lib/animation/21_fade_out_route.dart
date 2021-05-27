import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadeOutRoute extends StatefulWidget {
  static const String routeName = '/misc/fade_out_route';
  @override
  FadeOutRouteState createState() => FadeOutRouteState();
}

class FadeOutRouteState extends State<FadeOutRoute> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  final duration = Duration(milliseconds: 500);
  final curve = Curves.ease;
  double textFont = 15;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);
    animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).chain(CurveTween(curve: curve)).animate(controller);

    animation.addListener(() {
      textFont = getFontSize();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeItemCS(
      ratio: animation.value,
      child: Center(
        child: TextButton(
          child: Text(
            '나를 눌러라!',
            style: TextStyle(fontSize: textFont),
          ),
          onPressed: _centerBtnOnTap,
        ),
      ),
    );
  }

  _centerBtnOnTap() async {
    controller.forward();

    final secondRoute = createSlideSideRoute(widget: SecondView());
    await Navigator.push(context, secondRoute);

    controller.reverse();
  }

  double getFontSize() {
    return (animation.value * 100) * 0.15;
  }

  Route createSlideSideRoute({required Widget widget}) {
    return PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class SecondView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.red,
        child: Text(
          '두번째 화면',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FadeItemCS extends StatelessWidget {
  FadeItemCS({
    Key? key,
    required this.ratio,
    required this.child,
  }) : super(key: key);

  late double deviceHeight, deviceWidth;
  final ratio;
  Widget child;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Positioned.fill(child: Container(color: Colors.black)),
        Positioned.fromRect(
          rect: getPageRect(),
          child: Opacity(
            opacity: ratio,
            child: Scaffold(body: Container(child: child)),
          ),
        ),
      ],
    );
  }

  Rect getPageRect() {
    if (ratio == 1) return Offset(0, 0) & Size(deviceWidth, deviceHeight);

    double rectWidth = getRectWidth();
    double rectHeight = getRectHeight();

    double x = (deviceWidth - rectWidth) / 2;
    double y = (deviceHeight - rectHeight) / 2;

    return Offset(x, y) & Size(rectWidth, rectHeight);
  }

  double getRectWidth() {
    double minWidthRatio = 0.80;
    double minRectWidth = deviceWidth * minWidthRatio;
    double rectWidthOffset = (deviceWidth - minRectWidth) * ratio;
    return minRectWidth + rectWidthOffset;
  }

  double getRectHeight() {
    double minHeightRatio = 0.85;
    double minRectHeight = deviceHeight * minHeightRatio;
    double rectHeightOffset = (deviceHeight - minRectHeight) * ratio;
    return minRectHeight + rectHeightOffset;
  }
}
