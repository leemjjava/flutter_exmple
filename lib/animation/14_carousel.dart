// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CarouselDemo extends StatelessWidget {
  static String routeName = '/misc/carousel';

  static const List<String> fileNames = [
    'assets/eat_cape_town_sm.jpg',
    'assets/eat_new_orleans_sm.jpg',
    'assets/eat_sydney_sm.jpg',
  ];

  final List<Widget> images =
      fileNames.map((file) => Image.asset(file, fit: BoxFit.cover)).toList();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carousel Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: Carousel(itemBuilder: widgetBuilder),
          ),
        ),
      ),
    );
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return images[index % images.length];
  }
}

typedef void OnCurrentItemChangedCallback(int currentItem);

class Carousel extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;

  const Carousel({
    Key? key,
    required this.itemBuilder,
  });

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _controller;
  int _currentPage = 0;
  bool _pageHasChanged = false;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      viewportFraction: .85,
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    var size = MediaQuery.of(context).size;

    return PageView.builder(
      onPageChanged: (value) {
        _pageHasChanged = true;
        _currentPage = value;

        setState(() {});
      },
      controller: _controller,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double result = _pageHasChanged ? _controller.page! : _currentPage * 1.0;

          var value = result - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);

          return Center(
            child: SizedBox(
              height: Curves.easeOut.transform(value) * size.height,
              width: Curves.easeOut.transform(value) * size.width,
              child: child,
            ),
          );
        },
        child: widget.itemBuilder(context, index),
      ),
    );
  }
}
