import 'package:flutter/material.dart';

class TimeMachineDemo extends StatefulWidget {
  static const String routeName = '/basics/chaining_rotation_transition';

  @override
  State<StatefulWidget> createState() => _TimeMachineDemoState();
}

class _TimeMachineDemoState extends State<TimeMachineDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
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
      body: Stack(
        children: <Widget>[
          RotationTransition(
            alignment: Alignment.center,
            turns: _animationController,
            child: Center(child: renderImage()),
          ),
          renderBottomBtn(),
        ],
      ),
    );
  }

  Widget renderImage() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Image(
          image: AssetImage('assets/galaxy.png'),
          fit: BoxFit.fill,
          width: constraints.maxWidth,
        );
      },
    );
  }

  Widget renderBottomBtn() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: TimeStopper(controller: _animationController),
    );
  }
}

class TimeStopper extends StatelessWidget {
  final AnimationController controller;

  const TimeStopper({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        width: 100,
        height: 100,
      ),
    );
  }

  onTap() {
    if (controller.isAnimating)
      controller.stop();
    else
      controller.repeat();
  }
}
