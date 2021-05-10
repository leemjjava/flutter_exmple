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

    controller = AnimationController(vsync: this, duration: _duration);
    controller.addListener(() => setState(() {}));

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
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: renderMain()),
    );
  }

  Widget renderMain() {
    final btnTitle = getTitle();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderDataShow(),
        ElevatedButton(
          child: Text(btnTitle),
          onPressed: _onBtnTap,
        )
      ],
    );
  }

  Widget renderDataShow() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: Text(
        '\$${animation.value.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  String getTitle() {
    if (controller.status == AnimationStatus.completed) return 'Buy a Mansion';
    return 'Win Lottery';
  }

  _onBtnTap() {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}
