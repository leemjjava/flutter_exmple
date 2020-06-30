import 'package:flutter/material.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  static const String routeName = '/basics/chaining_animated_widget';

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

//  final Image starsBackground = Image.asset(
//    'assets/space.png',
//    fit: BoxFit.fitHeight,
//  );
  final Image ufo = Image.asset(
    'assets/ufo.png',
    fit: BoxFit.fill,
    width: 150,
    height: 150,
  );
  AnimationController _animation;

  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/space.png"),
                  fit: BoxFit.cover
                  
                ),
              ),
            ),
            BeamTransition(animation: _animation),
            ufo,
          ],
        ),
    );

  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}

class BeamTransition extends AnimatedWidget {
  BeamTransition({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return ClipPath(
      clipper: const BeamClipper(),
      child: Container(
        height: 1000,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.5,
            colors: [
              Colors.yellow,
              Colors.transparent,
            ],
            stops: [0, animation.value],
          ),
        ),
      ),
    );
  }
}

class BeamClipper extends CustomClipper<Path> {
  const BeamClipper();

  @override
  getClip(Size size) {
    return Path()
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();
  }

  /// Return false always because we always clip the same area.
  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}