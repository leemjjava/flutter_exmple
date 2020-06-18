import 'package:flutter/material.dart';
import 'dart:ui';

class BackdropFilterEx extends StatelessWidget{
  static const String routeName = '/week_of_widget/backdrop_filter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backdrop Filter'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.asset('assets/loding.gif'),
          ),
          Center(
            child: ClipRect(  // <-- clips to the 200x200 [Container] below
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0),
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}