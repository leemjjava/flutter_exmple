import 'package:flutter/material.dart';

class AnimatedBuilderDemo extends StatefulWidget {
  static const String routeName = '/basics/animated_builder';

  _AnimatedBuilderDemoState createState() => _AnimatedBuilderDemoState();
}

class _AnimatedBuilderDemoState extends State<AnimatedBuilderDemo>
    with SingleTickerProviderStateMixin {
  static const Color beginColor = Colors.deepPurple;
  static const Color endColor = Colors.deepOrange;

  late AnimationController controller;
  late Animation<Color?> animation;

  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    animation = ColorTween(
      begin: beginColor,
      end: endColor,
    ).animate(controller);
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Builder')),
      body: Center(child: renderMain()),
    );
  }

  Widget renderMain() {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => renderBtn(child),
      child: Text(
        'Change Color',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget renderBtn(Widget? child) {
    return MaterialButton(
      color: animation.value,
      child: child,
      onPressed: _onTap,
    );
  }

  _onTap() {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}
