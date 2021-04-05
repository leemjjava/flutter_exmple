import 'package:flutter/material.dart';

import 'circle_network_image.dart';

class BubbleCard extends StatefulWidget {
  final bool isLeftPointer;
  final bool isRead;
  final String label;
  final String subLabel;
  final String? imgUrl;

  BubbleCard({
    required this.label,
    required this.subLabel,
    this.isLeftPointer = false,
    this.imgUrl,
    this.isRead = false,
  });

  @override
  _BubbleCardState createState() => _BubbleCardState();
}

class _BubbleCardState extends State<BubbleCard> {
  final pointWidth = 13.0, pointHeight = 19.0, radius = 7.0;
  final padding = 14.0;

  @override
  Widget build(BuildContext context) {
    final isLeft = widget.isLeftPointer;

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(minWidth: 0.0),
        child: renderMain(),
      ),
    );
  }

  Widget renderMain() {
    return CustomPaint(
      painter: BubblePainter(
        pointHeight: pointHeight,
        pointWidth: pointWidth,
        isLeftPointer: widget.isLeftPointer,
        color: widget.isLeftPointer ? Color(0xFFE2E3F4) : Color(0xffE2E2E9),
        radius: radius,
      ),
      child: renderBody(),
    );
  }

  Widget renderBody() {
    final isLeft = widget.isLeftPointer;
    final pointerMargin = this.pointWidth + padding;
    final url = widget.imgUrl;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: isLeft ? pointerMargin : padding),
            if (url != null) CircleNetworkImage(path: url, imageSize: 46),
            if (url != null) SizedBox(width: 14.0),
            Expanded(child: renderText()),
            SizedBox(width: isLeft ? padding : pointerMargin),
          ],
        ),
      ),
    );
  }

  renderText() {
    return Container(
      constraints: BoxConstraints(minHeight: 46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label, style: _getLabelTextStyle()),
          SizedBox(height: 5),
          Text(widget.subLabel, style: _getSubLabelTextStyle()),
        ],
      ),
    );
  }

  TextStyle _getLabelTextStyle() {
    if (widget.isRead == true) {
      return TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xff7f7f7f),
      );
    } else {
      return TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      );
    }
  }

  TextStyle _getSubLabelTextStyle() {
    if (widget.isRead == true) {
      return TextStyle(
        fontSize: 12,
        color: Color(0xff959595),
      );
    } else {
      return TextStyle(
        fontSize: 12,
        color: Color(0xFF616161),
      );
    }
  }

  Widget renderConformText() {
    return Row(
      children: [
        Text(
          '확인하기',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4042AB),
          ),
        ),
        Icon(
          Icons.arrow_right,
          color: const Color(0xFF4042AB),
        ),
      ],
    );
  }
}

class BubblePainter extends CustomPainter {
  final bool isLeftPointer;
  final Color color;
  final double pointWidth, pointHeight;
  final double radius, pointRadius = 3.0;

  BubblePainter({
    required this.isLeftPointer,
    required this.color,
    this.pointWidth = 10.0,
    this.pointHeight = 5.0,
    this.radius = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    final path = isLeftPointer ? pathLeft(width, height) : pathRight(width, height);
    canvas.drawPath(path, paint);
  }

  Path pathLeft(double width, double height) {
    final path = Path();
    path.moveTo(0.0, 0.0);

    path.lineTo(width - radius, 0.0);
    path.arcToPoint(
      Offset(width, radius),
      radius: Radius.circular(radius),
    );

    path.lineTo(width, height - radius);
    path.arcToPoint(
      Offset(width - radius, height),
      radius: Radius.circular(radius),
    );

    path.lineTo(pointWidth + radius, height);
    path.arcToPoint(
      Offset(pointWidth, height - radius),
      radius: Radius.circular(radius),
    );

    path.lineTo(pointWidth, pointHeight);

    path.lineTo(0.0, pointRadius);
    path.arcToPoint(
      Offset(pointRadius, 0.0),
      radius: Radius.circular(pointRadius),
    );

    return path;
  }

  Path pathRight(double width, double height) {
    final path = Path();
    path.moveTo(0.0, 0.0);

    path.lineTo(width - pointRadius, 0.0);
    path.arcToPoint(
      Offset(width, pointRadius),
      radius: Radius.circular(pointRadius),
    );
    path.lineTo(width - pointWidth, pointHeight);

    path.lineTo(width - pointWidth, height - radius);
    path.arcToPoint(
      Offset(width - pointWidth - radius, height),
      radius: Radius.circular(radius),
    );

    path.lineTo(radius, height);
    path.arcToPoint(
      Offset(0.0, height - radius),
      radius: Radius.circular(radius),
    );

    path.lineTo(0.0, radius);
    path.arcToPoint(
      Offset(radius, 0.0),
      radius: Radius.circular(radius),
    );

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
