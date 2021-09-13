import 'package:flutter/material.dart';
import 'package:navigator/components/button/bottom_btn.dart';
import 'package:navigator/components/tap/page_indicator.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/layouts/default_layout.dart';

// ignore: must_be_immutable
class PageIndicatorExample extends StatelessWidget {
  static const String routeName = '/misc/page_indicator_example';

  late BuildContext context;
  final pageController = PageController();
  int pageIndex = 0;
  bool isSubmit = false;

  final tapList = ['사전체크', '유형선택', '사진첨부', '문의내용', '접수완료'];

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return DefaultLayout(
      body: Column(
        children: [
          TopBar(title: 'Page Indicator Example1'),
          Expanded(child: renderBody()),
        ],
      ),
    );
  }

  Widget renderBody() {
    return WillPopScope(
      child: Column(
        children: [
          Expanded(child: renderMain()),
          BottomButton(
            title: '다음',
            onTap: _onNextBtnTap,
            secondWidget: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 12,
            ),
          ),
        ],
      ),
      onWillPop: () async {
        _onBackBtnTap();
        return false;
      },
    );
  }

  Widget renderMain() {
    return Stack(
      children: [
        renderPageView(),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 50,
          child: renderTopBar(),
        ),
      ],
    );
  }

  Widget renderTopBar() {
    return Row(
      children: [
        Container(width: 16, height: double.infinity, color: Color(0xffebebeb)),
        Expanded(
          child: PageIndicator(
            titleList: tapList.map((text) => renderTap(text)).toList(),
            pageController: pageController,
            isSubmit: isSubmit,
          ),
        ),
        Container(
          width: 16,
          height: double.infinity,
          color: isSubmit ? Color(0xffebebeb) : Colors.transparent,
        ),
      ],
    );
  }

  Widget renderTap(String title) {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontSize: 14, color: Color(0x8A000000)),
      ),
    );
  }

  Widget renderPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Center(child: Text("사전체크")),
        ),
        Container(
          color: Colors.white,
          child: Center(child: Text("유형선택")),
        ),
        Container(
          color: Colors.white,
          child: Center(child: Text("사진첨부")),
        ),
        Container(
          color: Colors.white,
          child: Center(child: Text("문의내용")),
        ),
      ],
      onPageChanged: (index) {
        FocusScope.of(context).requestFocus(FocusNode());
        pageIndex = index;
      },
    );
  }

  _onNextBtnTap() {
    if (pageIndex == 3) return isSubmit = true;

    pageController.animateToPage(
      pageIndex + 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  _onBackBtnTap() {
    if (pageIndex == 0) return Navigator.of(context).pop();

    pageController.animateToPage(
      pageIndex - 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
