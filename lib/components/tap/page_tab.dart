import 'package:flutter/material.dart';

const Color black = Color(0xff000000);
const Color grayA3 = Color(0xFFa3a3a3);
const Color blue40 = Color(0xff4042ab);

class PageTap extends StatefulWidget {
  PageTap({
    Key? key,
    required this.titleList,
    required this.pageController,
  }) : super(key: key);

  final List<String> titleList;
  final PageController pageController;
  @override
  PageTapState createState() => PageTapState();
}

class PageTapState extends State<PageTap> {
  int pageIndex = 0;
  int maxCount = 0;
  double maxWidth = 0;
  double tLVScrollPercent = 0.0;

  @override
  void initState() {
    super.initState();

    maxCount = widget.titleList.length;

    widget.pageController.addListener(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        maxWidth = constraints.maxWidth;
        final width = maxWidth / maxCount;
        final left = (maxWidth - width) * tLVScrollPercent;

        return Container(
          height: 50,
          child: Stack(
            children: [
              Positioned.fill(child: pageButtonLayout()),
              Positioned(
                bottom: 0,
                left: left,
                child: Container(width: width, height: 2, color: blue40),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget pageButtonLayout() {
    final listMap = widget.titleList.asMap();
    return SizedBox(
      height: 50,
      child: Row(
        children: listMap.entries.map((entry) {
          return Expanded(child: pageButton(entry.value, entry.key));
        }).toList(),
      ),
    );
  }

  Widget pageButton(String title, int page) {
    final fontColor = pageIndex == page ? black : grayA3;

    return InkWell(
      onTap: () {
        pageIndex = page;
        widget.pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 400),
          curve: Curves.linear,
        );
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: fontColor,
                ),
              ),
            ),
          ),
          Container(height: 2, color: Colors.transparent),
        ],
      ),
    );
  }
}
