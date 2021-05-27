import 'package:flutter/material.dart';

import 'default_layout.dart';

/*
 작성일 : 2021-04-01
 작성자 : Mark,
 화면명 : (화면명),
 경로 : 없음
 클래스 : IntrinsicHeightLayout,
 설명 : Column 을 사용하여 Ui를 그릴때 Scroll 이 기본으로 들어가 있고,
 Screen 이 화면보다 작을때는 Expanded 가 적용되고,
 Screen 이 화면보다 클때는 Expanded 가 작동하지 않고 싶을때 사용하는 Layout

*/

class IntrinsicHeightLayout extends StatelessWidget {
  final Widget body;

  IntrinsicHeightLayout({
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final minHeight = _getMinHeight(context);

    return DefaultLayout(
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            child: body,
          ),
        ),
      ),
    );
  }

  double _getMinHeight(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final minusHeight = top + bottom;
    final height = MediaQuery.of(context).size.height;

    return height - minusHeight;
  }
}
