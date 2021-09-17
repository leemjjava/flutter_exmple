import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigator/utile/utile.dart';

// ignore: must_be_immutable
class BottomButton extends StatelessWidget {
  String title;
  GestureTapCallback? onTap;
  Widget? secondWidget;
  bool isDisable;

  BottomButton({
    required this.title,
    this.onTap,
    this.secondWidget,
    this.isDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellCS(
      backgroundColor: isDisable == true ? Color(0x1F000000) : Colors.green,
      splashColor: isDisable == true ? Color(0x1F000000) : Colors.green[700],
      highlightColor: Colors.white.withOpacity(0),
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        child: renderTitle(),
      ),
      onTap: isDisable == true ? null : onTap,
    );
  }

  Widget renderTitle() {
    final secondWidget = this.secondWidget;
    if (secondWidget == null) {
      return Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 7),
        Container(
          margin: EdgeInsets.only(bottom: Platform.isAndroid ? 0 : 1),
          child: Center(child: secondWidget),
        ),
      ],
    );
  }
}
