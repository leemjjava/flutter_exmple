// ignore: must_be_immutable
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopBar extends StatelessWidget {
  TopBar({
    Key? key,
    this.title,
    this.onTap,
    this.closeIcon,
    this.height = 60,
  }) : super(key: key);

  String? title;
  GestureTapCallback? onTap;
  Icon? closeIcon;
  double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          TopTitle(
            title: title ?? '',
            height: height,
          ),
          SizedBox(
            height: double.infinity,
            width: height,
            child: Material(
              color: Colors.white,
              child: InkWell(
                splashColor: Color(0xFF757575),
                onTap: onTap != null ? onTap! : () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: closeIcon == null ? Icon(Icons.close) : closeIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TopTitle extends StatelessWidget {
  TopTitle({
    Key? key,
    this.title,
    this.height = 60,
    this.alignment,
    this.weight,
  }) : super(key: key);

  String? title;
  double height;
  AlignmentGeometry? alignment;
  FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: alignment ?? Alignment.center,
      color: Colors.white,
      height: height,
      child: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 17,
          fontWeight: weight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
