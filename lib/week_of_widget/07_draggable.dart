import 'package:flutter/material.dart';
import 'dart:math';
import '../utile/utile.dart';

class DraggableEx extends StatefulWidget {
  static const String routeName = '/week_of_widget/draggable';

  @override
  _DraggableExState createState() => _DraggableExState();
}

class _DraggableExState extends State<DraggableEx> with TickerProviderStateMixin {
  int rng = new Random().nextInt(1000);

  void newRng() {
    setState(() {
      rng = Random().nextInt(1000);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Draggable(
              data: rng,
              child: draggableChild(),
              feedback: feedbackChild(),
              childWhenDragging: rectangleContainer(color: Colors.black38),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                evenTarget(),
                oddTarget(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget draggableChild() {
    return rectangleContainer(
      color: Colors.pink,
      child: Center(
        child: Text(
          "$rng",
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
    );
  }

  Widget feedbackChild() {
    return rectangleContainer(
      color: Colors.orange,
      radius: 20,
      child: Center(
        child: Text(
          "$rng",
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
    );
  }

  Widget oddTarget() {
    return rectangleContainer(
        color: Colors.deepPurple,
        child: DragTarget(
          builder: (context, List<int?> candidateData, rejectedData) {
            return Center(
              child: Text(
                "홀수",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (item) {
            final data = item as int;
            showAlertDialog(context, data % 2 != 0 ? "맞음!" : "틀림!");
            newRng();
          },
        ));
  }

  Widget evenTarget() {
    return rectangleContainer(
      color: Colors.green,
      child: DragTarget(
        builder: (context, List<int?> candidateData, rejectedData) {
          print(candidateData);
          return Center(
              child: Text(
            "짝수",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ));
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: (item) {
          final data = item as int;
          showAlertDialog(context, data % 2 == 0 ? "맞음!" : "틀림!");
          newRng();
        },
      ),
    );
  }

  Widget rectangleContainer({
    Color? color,
    Widget? child,
    double radius = 0,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      width: 100.0,
      height: 100.0,
      child: child,
    );
  }
}
