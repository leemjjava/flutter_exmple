import 'package:flutter/material.dart';

class FadeTransitionDemo extends StatefulWidget{
  static const String routeName = '/basics/fade_transition';

  @override
  State<StatefulWidget> createState() => _FadeTransitionDemoState();
}

class _FadeTransitionDemoState extends State<FadeTransitionDemo>
    with SingleTickerProviderStateMixin{

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            FadeTransition(
              opacity: _controller,
              child: Image.asset("assets/space.png"),
            ),
//            RaisedButton(
//              child: Text("hide/show"),
//              onPressed: (){
//                if (_controller.status == AnimationStatus.completed) {
//                  _controller.reverse();
//                } else {
//                  _controller.forward();
//                }
//              },
//            )
          ],
        ),
      ),
    );
  }
}