import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FadePageItemCS extends StatelessWidget {
  FadePageItemCS({
    Key? key,
    required this.pageScrollPosition,
    required this.pageNumber,
    required this.builderFunction,
    this.radius,
  }) : super(key: key);

  late double deviceHeight, deviceWidth;
  final pageScrollPosition;
  final pageNumber;
  final minRatio = 0.75;
  double? radius;

  final Function(
    BuildContext context,
    double pagePercent,
  ) builderFunction;

  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        deviceWidth = constraints.maxWidth;
        deviceHeight = constraints.maxHeight;

        return renderStack();
      },
    );
  }

  Widget renderStack() {
    return Stack(
      children: <Widget>[
        Positioned.fromRect(
          rect: getPageRect(),
          child: Opacity(
            opacity: getPagePercent(),
            child: renderCard(),
          ),
        ),
      ],
    );
  }

  Widget renderCard() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
        child: builderFunction(context, getPagePercent()),
      ),
    );
  }

  Rect getPageRect() {
    if (checkPageUp()) return Offset(0, 0) & Size(deviceWidth, deviceHeight);

    double rectWidth = getRectWidth();
    double rectHeight = getRectHeight();

    double x = (deviceWidth - rectWidth) / 2;
    double y = (deviceHeight - rectHeight) + getNowScrollHeight();

    return Offset(x, y) & Size(rectWidth, rectHeight);
  }

  double getRectWidth() {
    double minRectWidth = deviceWidth * minRatio;
    double rectWidthOffset = (deviceWidth - minRectWidth) * getScrollRatio();
    return minRectWidth + rectWidthOffset;
  }

  double getRectHeight() {
    double minRectHeight = deviceHeight * minRatio;
    double rectHeightOffset = (deviceHeight - minRectHeight) * getScrollRatio();
    return minRectHeight + rectHeightOffset;
  }

  double getNowScrollHeight() {
    double startPagePosition = deviceHeight * pageNumber;
    return pageScrollPosition - startPagePosition;
  }

  double getScrollRatio() {
    double pageViewScrollOffset = deviceHeight - getNowScrollHeight();
    return pageViewScrollOffset / deviceHeight;
  }

  double getPagePercent() {
    if (checkPageUp()) return 1;
    final ratio = getScrollRatio();
    double factor = 1;

    if (ratio < 1) {
      final plusFactor = (0.25 * ratio);
      final minFactor = minRatio;
      factor = plusFactor + minFactor;
    }
    return factor;
  }

  bool checkPageUp() {
    if (pageNumber == 0) return false;
    if (pageScrollPosition < deviceHeight * pageNumber) return true;
    return false;
  }
}
