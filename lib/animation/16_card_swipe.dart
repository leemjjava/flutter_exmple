// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CardSwipeDemo extends StatefulWidget {
  static String routeName = '/misc/card_swipe';

  @override
  _CardSwipeDemoState createState() => _CardSwipeDemoState();
}

class _CardSwipeDemoState extends State<CardSwipeDemo> {
  late List<String> fileNames = [
    'assets/eat_cape_town_sm.jpg',
    'assets/eat_new_orleans_sm.jpg',
    'assets/eat_sydney_sm.jpg',
  ];

  void initState() {
    super.initState();
    _resetCards();
  }

  void _resetCards() {
    fileNames = [
      'assets/eat_cape_town_sm.jpg',
      'assets/eat_new_orleans_sm.jpg',
      'assets/eat_sydney_sm.jpg',
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Swipe'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRect(
                child: Stack(
                  children: <Widget>[
                    for (final path in fileNames) renderCard(path)
                  ],
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Refill'),
              onPressed: onRefillPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget renderCard(String path) {
    return SwipeAbleCard(
      imageAssetName: path,
      onSwiped: () {
        fileNames.remove(path);
        setState(() {});
      },
    );
  }

  onRefillPressed() {
    setState(() => _resetCards());
  }
}

class Card extends StatelessWidget {
  final String imageAssetName;

  Card(this.imageAssetName);

  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: AssetImage(imageAssetName),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SwipeAbleCard extends StatefulWidget {
  final String imageAssetName;
  final VoidCallback onSwiped;

  SwipeAbleCard({
    required this.onSwiped,
    required this.imageAssetName,
  });

  _SwipeAbleCardState createState() => _SwipeAbleCardState();
}

class _SwipeAbleCardState extends State<SwipeAbleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragStartX = 0;
  bool _isSwipingLeft = false;

  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _animation = _controller.drive(Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1, 0),
    ));
  }

  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: GestureDetector(
        onHorizontalDragStart: _dragStart,
        onHorizontalDragUpdate: _dragUpdate,
        onHorizontalDragEnd: _dragEnd,
        child: Card(widget.imageAssetName),
      ),
    );
  }

  /// Sets the starting position the user dragged from.
  void _dragStart(DragStartDetails details) {
    _dragStartX = details.localPosition.dx;
  }

  /// Changes the animation to animate to the left or right depending on the
  /// swipe, and sets the AnimationController's value to the swiped amount.
  void _dragUpdate(DragUpdateDetails details) {
    var isSwipingLeft = (details.localPosition.dx - _dragStartX) < 0;
    if (isSwipingLeft != _isSwipingLeft) {
      _isSwipingLeft = isSwipingLeft;
      _updateAnimation(details.localPosition.dx);
    }

    // Calculate the amount dragged in unit coordinates (between 0 and 1)
    // using this widgets width.
    _controller.value =
        (details.localPosition.dx - _dragStartX).abs() / context.size!.width;
    setState(() {});
  }

  /// Runs the fling / spring animation using the final velocity of the drag
  /// gesture.
  void _dragEnd(DragEndDetails details) {
    var velocity =
        (details.velocity.pixelsPerSecond.dx / context.size!.width).abs();
    _animate(velocity: velocity);
  }

  void _updateAnimation(double dragPosition) {
    _animation = _controller.drive(Tween<Offset>(
      begin: Offset.zero,
      end: _isSwipingLeft ? Offset(-1, 0) : Offset(1, 0),
    ));
  }

  void _animate({double velocity = 0}) {
    var description = SpringDescription(mass: 50, stiffness: 1, damping: 1);
    var simulation =
        SpringSimulation(description, _controller.value, 1, velocity);
    _controller.animateWith(simulation).then<void>((_) => widget.onSwiped());
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
