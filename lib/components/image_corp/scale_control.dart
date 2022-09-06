import 'package:flutter/material.dart';

/// ResizebleWidget 의 Control Type Enum
enum ScaleType {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

///ResizebleWidget 의 크기를 조절하기 위한 Widget
/// [onDrag] : control 의 drag 정보를 받기 위한 함수
/// [type] : control type
class ScaleControl extends StatefulWidget {
  const ScaleControl({
    required this.onDrag,
    required this.type,
  });

  final Function onDrag;
  final ScaleType type;

  @override
  _ScaleControlState createState() => _ScaleControlState();
}

class _ScaleControlState extends State<ScaleControl> {
  double initX = 0.0;
  double initY = 0.0;

  void _handleDrag(details) {
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
  }

  void _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;

    widget.onDrag(dx, dy, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: 44,
        height: 44,
        alignment: getAlignment(),
        color: Colors.transparent,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            border: _getBorder(),
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Alignment getAlignment() {
    switch (widget.type) {
      case ScaleType.topLeft:
        return Alignment.bottomRight;
      case ScaleType.topRight:
        return Alignment.bottomLeft;
      case ScaleType.bottomLeft:
        return Alignment.topRight;
      case ScaleType.bottomRight:
        return Alignment.topLeft;
    }
  }

  Border _getBorder() {
    final borderSide = BorderSide(color: const Color(0xff4365db), width: 6);

    switch (widget.type) {
      case ScaleType.topLeft:
        return Border(top: borderSide, left: borderSide);
      case ScaleType.topRight:
        return Border(top: borderSide, right: borderSide);
      case ScaleType.bottomLeft:
        return Border(left: borderSide, bottom: borderSide);
      case ScaleType.bottomRight:
        return Border(right: borderSide, bottom: borderSide);
    }
  }
}
