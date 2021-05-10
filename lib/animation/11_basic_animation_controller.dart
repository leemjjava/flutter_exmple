import 'package:flutter/material.dart';

class BasicAnimationDemo extends StatefulWidget {
  static const String routeName = '/basics/basic_animation';

  @override
  State<StatefulWidget> createState() => _BasicAnimationDemoState();
}

class _BasicAnimationDemoState extends State<BasicAnimationDemo>
    with SingleTickerProviderStateMixin<BasicAnimationDemo> {
  late AnimationController _animationController;
  double i = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animationController.addListener(_update);
    _animationController.forward();
  }

  void _update() {
    i = _animationController.value;
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: renderTitle()),
    );
  }

  Widget renderTitle() {
    return Text(
      "$i m/s",
      style: TextStyle(
        fontSize: 20,
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
