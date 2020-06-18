import 'package:flutter/material.dart';

const buttonColor = Colors.red;
const buttonLightColor = Color(0xFFFFCDD2);

Widget getTextField(TextEditingController tec, String title ,String hint, bool obscure){
  return Container(
    height: 45,
    margin: const EdgeInsets.only(top: 15),
    padding: const EdgeInsets.only(left: 20, right: 20,),
    decoration: getBorderBox(),
    child: Row(children: <Widget>[
      Container(
        width: 80,
        child: Text(title,
            style: TextStyle(fontSize: 13, color: Colors.black)),
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

BoxDecoration getBorderBox(){
  return BoxDecoration(
      color: Colors.white,
      border: Border.all(width: 1, color: Colors.black12));
}

Widget getExpandedButton(String title,VoidCallback onPressed ){
  return Container(
    constraints: BoxConstraints(
      minWidth: double.infinity,
    ),
    child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: buttonColor,
      textColor: Colors.white,
      child: Text(title),
      onPressed: onPressed,
    )
  );
}

Widget getTextCheckBox(String title, bool checkValue, ValueChanged<bool> callBack){
  return Container(
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: checkValue,
          onChanged:callBack,
        )
      ]
    ),
  );
}

Widget getGradientButton(Text title){
  return FlatButton(
    onPressed: () { },
    shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
    ),
    padding: const EdgeInsets.all(0.0),
    child: Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[buttonColor, buttonLightColor]),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
        border: Border.all(width: 1, color: Colors.black12)
      ),
      child: Container(
        constraints: expandedConstraints(),
        alignment: Alignment.center,
        child: title,
      ),
    ),
  );
}

Widget getBorderButton(){
  return FlatButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: buttonColor)
    ),
    onPressed: () {},
    color: Colors.white,
    textColor: buttonColor,
    child:Container(
      constraints: expandedConstraints(),
      alignment: Alignment.center,
      child: Text(
          "Border".toUpperCase(),
          style: TextStyle(fontSize: 14)
      ),
    )
  );
}

BoxConstraints expandedConstraints(){
  return const BoxConstraints(minWidth: double.infinity, minHeight: 36.0); // min sizes for Material buttons
}

Widget tfFocusWidget(BuildContext context, Widget child){
  return GestureDetector(
      onTap:()=>FocusScope.of(context).requestFocus(new FocusNode()),
      child:child
  );
}