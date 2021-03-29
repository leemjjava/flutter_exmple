import 'package:flutter/material.dart';
import 'package:navigator/components/tap/page_tab.dart';
import 'package:navigator/utile/ui.dart';

class PageTapExample extends StatefulWidget {
  static const String routeName = '/misc/page_tap_example';

  @override
  PageTapExampleState createState() => PageTapExampleState();
}

class PageTapExampleState extends State<PageTapExample> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: 'Page Tap'),
            renderAnimationTab(),
            Expanded(child: renderMainPageView()),
          ],
        ),
      ),
    );
  }

  Widget renderAnimationTab() {
    return PageTap(
      pageController: _pageController,
      titleList: ['page01', 'page02', 'page03', 'page04'],
    );
  }

  Widget renderMainPageView() {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        Center(child: renderTitle('PAGE 01')),
        Center(child: renderTitle('PAGE 02')),
        Center(child: renderTitle('PAGE 03')),
        Center(child: renderTitle('PAGE 04')),
      ],
    );
  }

  Widget renderTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
