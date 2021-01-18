import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationAlert extends StatefulWidget {
  static const String routeName = '/misc/animation_alert';

  @override
  AnimationAlertState createState() => AnimationAlertState();
}

class AnimationAlertState extends State<AnimationAlert> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Animation Alert"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              inputButton(
                  'Center', () => showDialog(context, '버튼이 터치되었습니다.', centerBuild)),
              SizedBox(height: 20),
              inputButton('Down', () => showDialog(context, '버튼이 터치되었습니다.', downBuild)),
              SizedBox(height: 20),
              inputButton('Up', () => showDialog(context, '버튼이 터치되었습니다.', upBuilder)),
              SizedBox(height: 20),
              inputButton('Side', () => showDialog(context, '버튼이 터치되었습니다.', sideBuilder)),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputButton(String title, VoidCallback onPressed) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 50,
        child: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      onPressed: onPressed,
    );
  }

  void showDialog(
    BuildContext context,
    String message,
    RouteTransitionsBuilder transitionBuilder,
  ) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => dialogContainer(message),
      transitionBuilder: transitionBuilder,
    );
  }

  Widget centerBuild(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scale = CurvedAnimation(
      parent: animation,
      curve: Curves.elasticInOut,
    ).value;

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  Widget downBuild(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
    final yValue = curvedValue * 200;

    return Transform(
      transform: Matrix4.translationValues(0.0, yValue, 0.0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  Widget upBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedValue = 1.0 - Curves.easeInOutBack.transform(animation.value);
    final yValue = curvedValue * 200;

    return Transform(
      transform: Matrix4.translationValues(0.0, yValue, 0.0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  Widget sideBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
    final xValue = curvedValue * 200;

    return Transform(
      transform: Matrix4.translationValues(xValue, 0.0, 0.0),
      child: child,
    );
  }

  Widget dialogContainer(String message) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
