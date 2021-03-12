// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class TweenDemo extends StatefulWidget {
  static const String routeName = '/basics/tweens';

  _TweenDemoState createState() => _TweenDemoState();
}

class _TweenDemoState extends State<TweenDemo> with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(seconds: 1);
  static const double accountBalance = 1000000;
  late AnimationController controller;
  late Animation<double> animation;

  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: _duration,
    )..addListener(() => setState(() {}));

    animation = Tween(
      begin: 0.0,
      end: accountBalance,
    ).animate(controller);
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final title =
        controller.status == AnimationStatus.completed ? 'Buy a Mansion' : 'Win Lottery';

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: Text('\$${animation.value.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24)),
            ),
            ElevatedButton(
              child: Text(title),
              onPressed: _onBtnTap,
            )
          ],
        ),
      ),
    );
  }

  _onBtnTap() {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}
