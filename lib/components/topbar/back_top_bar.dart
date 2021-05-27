import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BackTopBar extends StatelessWidget {
  BackTopBar({
    this.title,
    this.height,
    this.rightButtons,
    this.useDefaultPadding = true,
    this.customTitle,
    this.customOnBack,
    this.bgColor = Colors.white,
  });

  bool useDefaultPadding;
  String? title;
  double? height;
  Widget? rightButtons;
  Widget? customTitle;
  GestureTapCallback? customOnBack;
  Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: this.useDefaultPadding
          ? EdgeInsets.only(top: 16, left: 16.0, right: 16.0)
          : EdgeInsets.all(0),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          renderBackBtn(context),
          Row(
            children: [
              renderTitle(context, title),
              rightButtons != null ? Expanded(child: rightButtons!) : Container(),
            ],
          ),
        ],
      ),
    );
  }

  renderTitle(BuildContext context, String? title) {
    if (customTitle != null) return this.customTitle;
    if (title == null) return Container();

    return Text(
      title,
      style: TextStyle(
        color: Color(0xff000000),
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
    );
  }

  renderBackBtn(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.centerLeft,
        height: 44,
        width: 40,
        child: Icon(Icons.arrow_back_ios),
      ),
      onTap: () => customOnBack == null ? Navigator.pop(context) : customOnBack!(),
    );
  }
}
