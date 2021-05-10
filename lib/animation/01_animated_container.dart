import 'dart:math';
import 'package:flutter/material.dart';

double generateBorderRadius() => Random().nextDouble() * 64;
double generateMargin() => Random().nextDouble() * 64;
Color generateColor() => Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));

class AnimatedContainerDemo extends StatefulWidget {
  static String routeName = '/basics/01_animated_container';

  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  Color color = Colors.deepPurple;
  double borderRadius = generateBorderRadius();
  double margin = generateMargin();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Container')),
      body: Center(child: renderMain()),
    );
  }

  Widget renderMain() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderChangeContainer(),
        SizedBox(height: 10),
        ElevatedButton(
          child: Text('CHANGE'),
          onPressed: _onChange,
        ),
      ],
    );
  }

  Widget renderChangeContainer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 150,
      height: 150,
      child: AnimatedContainer(
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        duration: const Duration(seconds: 2),
        curve: Curves.bounceIn,
      ),
    );
  }

  _onChange() {
    color = generateColor();
    borderRadius = generateBorderRadius();
    margin = generateMargin();

    setState(() {});
  }
}
