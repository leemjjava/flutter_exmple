import 'package:flutter/material.dart';

class BasicAnimationDemo extends StatefulWidget{
  static const String routeName = '/basics/basic_animation';

  @override
  State<StatefulWidget> createState() => _BasicAnimationDemoState();
}

class _BasicAnimationDemoState extends State<BasicAnimationDemo>
    with SingleTickerProviderStateMixin<BasicAnimationDemo>{
  late AnimationController _animationController;

  double i = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
    );
    _animationController.addListener(_update);
    _animationController.forward();
  }

  void _update(){
    setState(() {
//      i = (_animationController.value * 299792458).round();
      i = _animationController.value;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          "$i m/s",
          style: TextStyle(
            fontSize: 20,
            color: Colors.orange,
            fontWeight: FontWeight.bold
          ),

        ),
      ),
    );
  }
}

//class MyPragmenticWidget extends StatelessWidget{
//  static const String routeName = '/basics/basic_animation';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(),
//        body: Center(
//          child: TweenAnimationBuilder<int>(
//            tween: IntTween(begin: 0, end: 29979245),
//            duration: Duration(seconds: 10),
//            builder: (BuildContext context, int i, Widget child){
//              return Text(
//                "$i m/s",
//                style: TextStyle(
//                    fontSize: 20,
//                    color: Colors.green,
//                    fontWeight: FontWeight.bold
//                ),
//
//              );
//            },
//          ),
//        )
//    );
//  }
//}