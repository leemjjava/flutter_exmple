import 'package:flutter/material.dart';

class AnimationControllerDemo extends StatefulWidget {
  static const String routeName = '/basics/animation_controller';

  @override
  _AnimationControllerDemoState createState() => _AnimationControllerDemoState();
}

class _AnimationControllerDemoState extends State<AnimationControllerDemo>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(seconds: 1);
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: _duration);
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: renderMain()),
    );
  }

  Widget renderMain() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderDataShow(),
        SizedBox(height: 10),
        ElevatedButton(
          child: Text('animate'),
          onPressed: _animateBtnOnTap,
        )
      ],
    );
  }

  Widget renderDataShow() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: Text(
        '${controller.value.toStringAsFixed(2)}',
        textScaleFactor: 1 + controller.value,
      ),
    );
  }

  _animateBtnOnTap() {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}
