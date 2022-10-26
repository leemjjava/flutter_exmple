import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MusinsaItemCS extends StatelessWidget {
  MusinsaItemCS({
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

  final Function(BuildContext context) builderFunction;

  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        deviceWidth = constraints.maxWidth;
        deviceHeight = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            Positioned.fromRect(
              rect: getPageRect(),
              child: builderFunction(context),
            ),
          ],
        );
      },
    );
  }

  Rect getPageRect() {
    double x = deviceWidth - (deviceWidth * getScrollRatio());
    return Offset(x, 0) & Size(deviceWidth, deviceHeight);
  }

  double getNowScrollWidth() {
    double startPagePosition = deviceWidth * pageNumber;
    return pageScrollPosition - startPagePosition;
  }

  double getScrollRatio() {
    double pageViewScrollOffset = deviceWidth - getNowScrollWidth();
    return pageViewScrollOffset / deviceWidth;
  }
}
