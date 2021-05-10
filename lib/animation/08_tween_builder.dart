import 'package:flutter/material.dart';
import 'dart:math';

class TweenBuilderDemo extends StatefulWidget {
  static const String routeName = '/basics/chaining_tween_builder';

  @override
  State<StatefulWidget> createState() => _TweenBuilderDemoState();
}

class _TweenBuilderDemoState extends State<TweenBuilderDemo> {
  double _endValue = (2 * pi);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(color: Colors.lightBlue[50]),
          Center(child: renderColumn()),
        ],
      ),
    );
  }

  Widget renderColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        renderTweenAnimation(),
        ElevatedButton(
          child: Text('animated'),
          onPressed: () {
            _endValue = _endValue != 0 ? 0 : (2 * pi);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget renderTweenAnimation() {
    return TweenAnimationBuilder<double>(
      child: Image.asset('assets/icon.png'),
      tween: Tween<double>(begin: 0, end: _endValue),
      duration: Duration(seconds: 2),
      // onEnd: onTweenEnd,
      builder: (context, angle, child) {
        return Transform.rotate(
          angle: angle,
          child: ColorFiltered(
            child: child,
            colorFilter: ColorFilter.mode(
              Colors.lightBlue[100]!,
              BlendMode.modulate,
            ),
          ),
        );
      },
    );
  }

  onTweenEnd() {
    _endValue = _endValue == 0 ? 2 * pi : 0;
    setState(() {});
  }
}
