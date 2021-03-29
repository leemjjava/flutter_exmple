import 'package:flutter/material.dart';

const Color blue40 = Color(0xff4042ab);
const Color grayDC = Color(0xffDCDCE5);

// ignore: must_be_immutable
class AnimatedLinerIndicator extends StatefulWidget {
  AnimatedLinerIndicator({
    Key? key,
    required this.scrollController,
    this.valueColor = blue40,
    this.backgroundColor = grayDC,
  }) : super(key: key);
  final ScrollController scrollController;
  Color valueColor;
  Color backgroundColor;

  @override
  AnimatedLinerIndicatorState createState() => AnimatedLinerIndicatorState();
}

class AnimatedLinerIndicatorState extends State<AnimatedLinerIndicator> {
  double tLVScrollPercent = 0;

  @override
  initState() {
    super.initState();

    widget.scrollController.addListener(() {
      final offset = widget.scrollController.offset;
      final max = widget.scrollController.position.maxScrollExtent;
      double percent = offset / max;

      if (percent < 0) percent = 0;
      if (percent > 1) percent = 1;
      setState(() => tLVScrollPercent = percent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: tLVScrollPercent,
      valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
      backgroundColor: widget.backgroundColor,
    );
  }
}
