// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 128,
                height: 128,
                child: AnimatedContainer(
                  margin: EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  duration: const Duration(seconds: 2),
                  curve: Curves.bounceIn,
                ),
              ),
            ),
            ElevatedButton(
              child: Text('change'),
              onPressed: () => change(),
            ),
          ],
        ),
      ),
    );
  }

  void change() {
    setState(() {
      color = generateColor();
      borderRadius = generateBorderRadius();
      margin = generateMargin();
    });
  }
}
