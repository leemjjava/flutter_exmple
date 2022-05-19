import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropDownBtnCS extends StatelessWidget {
  DropDownBtnCS({
    Key? key,
    this.value,
    required this.hint,
    required this.itemList,
    this.onChanged,
  }) : super(key: key);

  String? value;
  final String hint;
  final List<String> itemList;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 10, right: 20),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(hint),
        value: value,
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 24,
        elevation: 16,
        itemHeight: 60,
        style: TextStyle(color: Color(0xFF0d0d0d)),
        underline: Container(
          height: 1,
          color: Color(0xFF0d0d0d),
        ),
        onChanged: onChanged,
        items: itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: double.infinity,
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ignore: must_be_immutable
class ExpandBtnCS extends StatelessWidget {
  ExpandBtnCS({
    Key? key,
    this.title = "Button111223",
    this.buttonColor = Colors.grey,
    this.textColor = Colors.white,
    this.onPressed,
    this.height = 40,
    this.width = double.infinity,
    double? fontSize,
    double? radius,
    FontWeight? fontWeight,
  })  : _radius = radius ?? (height / 2),
        _fontSize = fontSize ?? (height / 3),
        _fontWeight = fontWeight ?? FontWeight.w300,
        super(key: key);

  String title;
  Color buttonColor;
  Color textColor;
  VoidCallback? onPressed;
  double height;
  double width;
  double _fontSize;
  double _radius;
  FontWeight _fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: buttonColor,
            textStyle: TextStyle(color: textColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: _fontWeight,
              fontSize: _fontSize,
            ),
          ),
          onPressed: onPressed,
        ));
  }
}

// ignore: must_be_immutable
class BorderBtnCS extends StatelessWidget {
  BorderBtnCS({
    Key? key,
    this.title = "Button",
    this.buttonColor = Colors.white,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
    this.width = double.infinity,
    this.height = 40,
    this.fontSize = 14,
    this.onPressed,
    this.borderWeight = 1,
    required this.fontWeight,
    double? radius,
  })  : _radius = radius ?? (height / 2),
        super(key: key);

  String title;
  Color buttonColor;
  Color textColor;
  Color borderColor;

  double width;
  double height;
  double fontSize;
  double borderWeight;
  FontWeight fontWeight;

  VoidCallback? onPressed;
  double _radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
            side: BorderSide(
              width: borderWeight,
              color: borderColor,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
