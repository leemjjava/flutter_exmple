import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class TransformExample extends StatefulWidget {
  static const String routeName = '/misc/transform_example';

  @override
  TransformExampleState createState() => TransformExampleState();
}

class TransformExampleState extends State<TransformExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transform Example'),
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 10),
                  transformBtn('1번', Colors.red, () {}),
                  SizedBox(width: 10),
                  transformBtn('2번', Colors.pink, () {}),
                  SizedBox(width: 10),
                  transformBtn('3번', Colors.purple, () {}),
                ],
              ),
            ),
            Positioned.fill(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _animationController,
                  child: RedContainer(),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: (180 / (180 / math.pi)) * _animationController.value,
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transformBtn(String title, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        height: 40,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            if (_animationController.isDismissed) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          },
        ),
      ),
    );
  }
}

class RedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: 250,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.1),
                blurRadius: 6.0,
              )
            ],
          ),
          child: Center(
            child: Text(
              'Text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
