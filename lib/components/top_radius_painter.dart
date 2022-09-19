import 'package:flutter/material.dart';

class TopRadiusPainter extends CustomPainter {
  bool isNoHorizontal = false;
  Color lineColor = Color(0xffced3d6);

  TopRadiusPainter({
    this.isNoHorizontal = false,
    this.lineColor = const Color(0xffced3d6),
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = lineColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    var path = Path();

    final radius = size.width * 0.15;

    path.moveTo(0, size.height);
    path.arcToPoint(
      Offset(radius, 10),
      radius: Radius.circular(radius),
    );

    path.lineTo(size.width - radius, 10);
    path.arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.circular(radius),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
