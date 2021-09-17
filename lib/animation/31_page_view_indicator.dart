import 'package:flutter/material.dart';
import 'package:navigator/components/button/bottom_btn.dart';
import 'package:navigator/components/tap/page_indicator.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PageIndicatorExample extends StatelessWidget {
  static const String routeName = '/misc/page_indicator_example';

  late BuildContext context;
  final pageController = PageController();
  int pageIndex = 0;
  Submit submit = Submit();

  final tapList = ['Page1', 'Page2', 'Page3', 'Page4', 'Complete'];

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return ChangeNotifierProvider(
      create: (context) => submit,
      child: DefaultLayout(
        body: Column(
          children: [
            TopBar(title: 'Page Indicator Example'),
            Expanded(child: renderBody()),
          ],
        ),
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
    return Consumer<Submit>(
      builder: (context, submit, child) {
        return Row(
          children: [
            Container(width: 16, height: double.infinity, color: Colors.green[100]),
            Expanded(
              child: PageIndicator(
                titleList: tapList.map((text) => renderTap(text)).toList(),
                pageController: pageController,
                isSubmit: submit.isSubmit,
              ),
            ),
            Container(
              width: 16,
              height: double.infinity,
              color: submit.isSubmit ? Colors.green[100] : Colors.transparent,
            ),
          ],
        );
      },
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
          child: Center(child: Text("Page1")),
        ),
        Container(
          color: Colors.white,
          child: Center(child: Text("Page2")),
        ),
        Container(
          color: Colors.white,
          child: Center(child: Text("Page3")),
        ),
        Container(
          color: Colors.white,
          child: Center(child: Text("Complete")),
        ),
      ],
      onPageChanged: (index) {
        FocusScope.of(context).requestFocus(FocusNode());
        pageIndex = index;
        submit.pageCount = index;
      },
    );
  }

  renderBottomBtn() {
    return Consumer<Submit>(
      builder: (context, submit, child) {
        final index = submit.pageCount;

        return BottomButton(
          title: index == 3 ? '전송' : '다음',
          onTap: _onNextBtnTap,
          secondWidget: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 12,
          ),
        );
      },
    );
  }

  _onNextBtnTap() {
    if (pageIndex == 3) return submit.isSubmit = true;

    pageController.animateToPage(
      pageIndex + 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  _onBackBtnTap() {
    if (pageIndex == 0) return Navigator.of(context).pop();
    if (submit.isSubmit == true) return submit.isSubmit = false;

    pageController.animateToPage(
      pageIndex - 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}

class Submit extends ChangeNotifier {
  bool _isSubmit = false;

  bool get isSubmit => _isSubmit;
  set isSubmit(bool isSubmit) {
    _isSubmit = isSubmit;
    notifyListeners();
  }

  int _pageCount = 0;
  int get pageCount => _pageCount;
  set pageCount(int pageCount) {
    _pageCount = pageCount;
    notifyListeners();
  }
}
