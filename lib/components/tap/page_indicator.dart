import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PageIndicator extends StatefulWidget {
  PageIndicator({
    Key? key,
    required this.titleList,
    required this.pageController,
    required this.isSubmit,
    this.indicatorColor = const Color(0xFFC8E6C9),
  }) : super(key: key);

  final List<Widget> titleList;
  final PageController pageController;
  bool isSubmit;
  Color indicatorColor;
  @override
  PageIndicatorState createState() => PageIndicatorState();
}

class PageIndicatorState extends State<PageIndicator> {
  int pageIndex = 0;
  int maxCount = 0;
  double tLVScrollPercent = 0.0;

  @override
  void initState() {
    super.initState();
    maxCount = widget.titleList.length;
    final initialPage = widget.pageController.initialPage;
    tLVScrollPercent = (1 / maxCount) * initialPage;

    widget.pageController.addListener(_setPagePosition);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_setPagePosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, color: widget.indicatorColor),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => renderMainRow(constraints),
          ),
        ),
        Container(
          width: 16,
          height: double.infinity,
          color: widget.isSubmit ? widget.indicatorColor : Colors.transparent,
        ),
      ],
    );
  }

  Widget renderMainRow(BoxConstraints constraints) {
    double maxWidth = constraints.maxWidth;
    final width = maxWidth / maxCount;
    final left = (maxWidth - width) * tLVScrollPercent;

    return Container(
      height: 50,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: widget.isSubmit ? 0 : null,
            child: renderBackView(width + left),
          ),
          Positioned.fill(child: pageButtonLayout()),
        ],
      ),
    );
  }

  Widget pageButtonLayout() {
    final titleList = widget.titleList;

    return SizedBox(
      height: 50,
      child: Row(
        children: titleList.map((widget) => pageButton(widget)).toList(),
      ),
    );
  }

  Widget pageButton(Widget titleText) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(child: Center(child: titleText)),
          Container(height: 2, color: Colors.transparent),
        ],
      ),
    );
  }

  Widget renderBackView(double width) {
    if (widget.isSubmit) {
      return Container(width: double.infinity, color: widget.indicatorColor);
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        color: widget.indicatorColor,
      ),
    );
  }

  _setPagePosition() {
    final offset = widget.pageController.offset;
    final max = widget.pageController.position.maxScrollExtent;
    final percent = offset / max;
    final partOfScroll = 1 / maxCount;

    for (int i = 1; i <= maxCount; ++i) {
      if (partOfScroll * i >= percent) {
        pageIndex = i - 1;
        break;
      }
    }

    setState(() => tLVScrollPercent = percent);
  }
}
