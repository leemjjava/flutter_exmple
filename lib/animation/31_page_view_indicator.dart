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

  final tapList = ['Page1', 'Page2', 'Page3', 'Page4'];

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ChangeNotifierProvider(
      create: (context) => submit,
      child: DefaultLayout(
        body: WillPopScope(
          onWillPop: () async {
            _onBackBtnTap();
            return false;
          },
          child: Column(
            children: [
              TopBar(title: 'Page Indicator Example'),
              SizedBox(height: 50, child: renderTopBar()),
              Expanded(child: renderPageView()),
              renderBottomBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderTopBar() {
    return Consumer<Submit>(
      builder: (context, submit, child) {
        return PageIndicator(
          titleList: tapList.map((text) => renderTap(text)).toList(),
          pageController: pageController,
          isSubmit: submit.isSubmit,
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
          child: Center(child: Text("Page4")),
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
        final icon = Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
          size: 12,
        );

        return BottomButton(
          title: index == 3 ? 'submit' : 'next',
          onTap: _onNextBtnTap,
          secondWidget: index == 3 ? null : icon,
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
