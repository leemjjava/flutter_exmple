// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class AnimatedBuilderDemo extends StatefulWidget {
  static const String routeName = '/basics/animated_builder';

  _AnimatedBuilderDemoState createState() => _AnimatedBuilderDemoState();
}

class _AnimatedBuilderDemoState extends State<AnimatedBuilderDemo>
    with SingleTickerProviderStateMixin {
  static const Color beginColor = Colors.deepPurple;
  static const Color endColor = Colors.deepOrange;
  Duration duration = Duration(milliseconds: 800);
  late AnimationController controller;
  late Animation<Color?> animation;

  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: duration,
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
      appBar: AppBar(),
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => renderBtn(child),
          child: Text(
            'Change Color',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  renderBtn(Widget? child) {
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
