import 'package:flutter/material.dart';

const buttonColor = Colors.red;
const buttonLightColor = Color(0xFFFFCDD2);

Widget getTextField(TextEditingController tec, String title, String hint, bool obscure) {
  return Container(
    height: 45,
    margin: const EdgeInsets.only(top: 15),
    padding: const EdgeInsets.only(
      left: 20,
      right: 20,
    ),
    decoration: getBorderBox(),
    child: Row(children: <Widget>[
      Container(
        width: 80,
        child: Text(title, style: TextStyle(fontSize: 13, color: Colors.black)),
      ),
      Expanded(
        child: TextField(
          controller: tec,
          style: TextStyle(fontSize: 13, color: Colors.black),
          obscureText: obscure,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[300]),
          ),
          cursorColor: Colors.blue,
        ),
      ),
    ]),
  );
}

BoxDecoration getBorderBox() {
  return BoxDecoration(
      color: Colors.white, border: Border.all(width: 1, color: Colors.black12));
}

Widget getExpandedButton(String title, VoidCallback onPressed) {
  return Container(
    constraints: BoxConstraints(
      minWidth: double.infinity,
    ),
    child: TextButton(
      style: TextButton.styleFrom(
        primary: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        textStyle: TextStyle(color: Colors.white),
      ),
      child: Text(title),
      onPressed: onPressed,
    ),
  );
}

Widget getTextCheckBox(String title, bool checkValue, ValueChanged<bool?>? callBack) {
  return Container(
    height: 40,
    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Text(title),
      Checkbox(
        value: checkValue,
        onChanged: callBack,
      )
    ]),
  );
}

Widget getGradientButton(Text title) {
  return TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
      ),
    ),
    child: Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[buttonColor, buttonLightColor]),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
          border: Border.all(width: 1, color: Colors.black12)),
      child: Container(
        constraints: expandedConstraints(),
        alignment: Alignment.center,
        child: title,
      ),
    ),
  );
}

Widget getBorderButton({
  VoidCallback? onPressed,
}) {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: Colors.white,
      textStyle: TextStyle(color: buttonColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: buttonColor),
      ),
    ),
    onPressed: onPressed,
    child: Container(
      constraints: expandedConstraints(),
      alignment: Alignment.center,
      child: Text(
        "Border".toUpperCase(),
        style: TextStyle(fontSize: 14),
      ),
    ),
  );
}

BoxConstraints expandedConstraints() {
  return const BoxConstraints(
    minWidth: double.infinity,
    minHeight: 36.0,
  ); // min sizes for Material buttons
}

Widget tfFocusWidget(BuildContext context, Widget child) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
    child: child,
  );
}

// ignore: must_be_immutable
class TopBar extends StatelessWidget {
  TopBar({
    Key? key,
    this.title,
    this.onTap,
    this.closeIcon,
    this.height = 60,
  }) : super(key: key);

  String? title;
  GestureTapCallback? onTap;
  Icon? closeIcon;
  double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          TopTitle(
            title: title ?? '',
            height: height,
          ),
          SizedBox(
            height: double.infinity,
            width: height,
            child: Material(
              color: Colors.white,
              child: InkWell(
                splashColor: Color(0xFF757575),
                onTap: onTap != null ? onTap! : () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: closeIcon == null ? Icon(Icons.close) : closeIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TopTitle extends StatelessWidget {
  TopTitle({
    Key? key,
    this.title,
    this.height = 60,
    this.alignment,
    this.weight,
  }) : super(key: key);

  String? title;
  double height;
  AlignmentGeometry? alignment;
  FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: alignment ?? Alignment.center,
      color: Colors.white,
      height: height,
      child: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 17,
          fontWeight: weight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
