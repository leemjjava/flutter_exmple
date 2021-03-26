import 'package:flutter/material.dart';

class KeyboardKey extends StatefulWidget {
  final dynamic label;
  final GestureTapCallback? onTap;

  KeyboardKey({
    required this.label,
    @required this.onTap,
  });

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderBody() {
    if (widget.label is Widget) {
      return widget.label;
    }

    return Text(
      widget.label,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: widget.onTap,
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Center(
            child: renderBody(),
          ),
        ),
      ),
    );
  }
}
