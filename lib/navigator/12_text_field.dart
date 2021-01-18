import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigator/utile/utile.dart';

class TextFieldDemo extends StatefulWidget {
  static const String routeName = '/navigator/text_field_demo';

  @override
  TextFieldDemoState createState() => TextFieldDemoState();
}

class TextFieldDemoState extends State<TextFieldDemo> {
  final nameTec = TextEditingController(), citizenNumberTec = TextEditingController();
  final phoneTec = TextEditingController(), accountNumberTec = TextEditingController();
  final etcInfoTec = TextEditingController(), etcTec = TextEditingController();

  List<String> errorList = [null, null, null, null, null, null];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              TopBar(title: "InputText Demo"),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        defaultTextField(
                          icon: Icon(Icons.account_box),
                          tec: nameTec,
                          title: "성함",
                          errorMessage: errorList[0],
                        ),
                        SizedBox(height: 20),
                        phoneTextField(
                          icon: Icon(Icons.phone),
                          tec: phoneTec,
                          title: '연락처',
                          errorMessage: errorList[1],
                        ),
                        SizedBox(height: 20),
                        citizenNumberTextField(
                          icon: Icon(Icons.contact_mail_sharp),
                          tec: citizenNumberTec,
                          title: '주민번호',
                          errorMessage: errorList[2],
                        ),
                        SizedBox(height: 20),
                        accountNumberTextField(
                          icon: Icon(Icons.money),
                          tec: accountNumberTec,
                          title: '계좌번호',
                          errorMessage: errorList[3],
                        ),
                        SizedBox(height: 20),
                        infoEtcTextField(
                          icon: Icon(Icons.title),
                          tec: etcInfoTec,
                          title: "title",
                          maxLines: 1,
                          errorMessage: errorList[4],
                        ),
                        SizedBox(height: 20),
                        etcFormField(
                          icon: null,
                          tec: etcTec,
                          title: '비고',
                          errorMessage: errorList[5],
                        ),
                        SizedBox(height: 20),
                        inputButton(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputButton() {
    return FlatButton(
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 50,
        child: Text(
          "전송",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());

        if (_dataCheck() == false) {
          setState(() {});
          return;
        }

        showAlertDialog(context, '모든 값이 입력되었습니다.');
      },
    );
  }

  Widget defaultTextField({
    Icon icon,
    String title,
    TextEditingController tec,
    String errorMessage,
    FocusNode focusNode,
    int maxLines,
  }) {
    return TextFormField(
      controller: tec,
      cursorColor: Color(0xFF0d0d0d),
      maxLines: maxLines,
      focusNode: focusNode,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: title,
        errorText: errorMessage,
        errorStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: icon,
      ),
    );
  }

  Widget phoneTextField({
    Icon icon,
    String title,
    TextEditingController tec,
    String errorMessage,
    FocusNode focusNode,
  }) {
    return TextFormField(
      controller: tec,
      cursorColor: Color(0xFF0d0d0d),
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 16),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
        PhoneNumberTextInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: title,
        errorText: errorMessage,
        errorStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: icon,
      ),
    );
  }

  Widget citizenNumberTextField({
    Icon icon,
    String title,
    TextEditingController tec,
    String errorMessage,
    FocusNode focusNode,
  }) {
    return TextFormField(
      controller: tec,
      cursorColor: Color(0xFF0d0d0d),
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(14),
        CitizenNumberFormatter(),
      ],
      decoration: InputDecoration(
        labelText: title,
        errorText: errorMessage,
        errorStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: icon,
      ),
    );
  }

  Widget accountNumberTextField({
    Icon icon,
    String title,
    TextEditingController tec,
    String errorMessage,
    FocusNode focusNode,
  }) {
    return TextFormField(
      controller: tec,
      cursorColor: Color(0xFF0d0d0d),
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
      decoration: InputDecoration(
        labelText: title,
        errorText: errorMessage,
        errorStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: icon,
      ),
    );
  }

  Widget infoEtcTextField({
    Icon icon,
    String title,
    TextEditingController tec,
    String errorMessage,
    FocusNode focusNode,
    int maxLines,
  }) {
    final fontSize = 12.0;

    return TextFormField(
      controller: tec,
      cursorColor: Color(0xFF0d0d0d),
      maxLines: maxLines,
      focusNode: focusNode,
      style: TextStyle(fontSize: fontSize, height: 2.0),
      decoration: InputDecoration(
        labelText: title,
        errorText: errorMessage,
        errorStyle: TextStyle(fontSize: fontSize),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: icon,
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }

  Widget etcFormField({
    Icon icon,
    String title,
    TextEditingController tec,
    String errorMessage,
    FocusNode focusNode,
  }) {
    return Container(
      height: 200,
      child: TextFormField(
        controller: tec,
        cursorColor: Color(0xFF0d0d0d),
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        focusNode: focusNode,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: title,
          alignLabelWithHint: true,
          errorText: errorMessage,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: icon,
        ),
      ),
    );
  }

  bool _dataCheck() {
    errorList = [null, null, null, null, null, null];

    final name = nameTec.text;
    final phone = phoneTec.text;
    final citizenNumber = citizenNumberTec.text;
    final accountNumber = accountNumberTec.text;
    final etcInfo = etcInfoTec.text;
    final etc = etcTec.text;

    if (name == null || name.isEmpty == true) {
      errorList[0] = "성함을 입력하세요.";
    }

    if (phone == null || phone.isEmpty == true) {
      errorList[1] = "연락처를 입력하세요.";
    } else if (phone.length < 12) {
      errorList[1] = "연락처를 정확히 입력하세요.";
    }

    if (citizenNumber == null || citizenNumber.isEmpty == true) {
      errorList[2] = "주민번호를 입력하세요.";
    } else if (citizenNumber.length < 14) {
      errorList[2] = "주민번호를 정확히 입력하세요.";
    }

    if (accountNumber == null || accountNumber.isEmpty == true) {
      errorList[3] = "계좌번호를 입력하세요.";
    }

    if (etcInfo == null || etcInfo.isEmpty == true) {
      errorList[4] = "title 을 입력하세요.";
    }

    if (etc == null || etc.isEmpty == true) {
      errorList[5] = "비고를 입력하세요.";
    }

    for (final item in errorList) {
      if (item != null) return false;
    }

    return true;
  }
}

// ignore: must_be_immutable
class TopBar extends StatelessWidget {
  TopBar({
    Key key,
    this.title,
    this.onTap,
    this.closeIcon,
    this.height = 60,
  }) : super(key: key);

  String title;
  Function onTap;
  Icon closeIcon;
  double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          titleWidget(),
          closeWidget(context),
        ],
      ),
    );
  }

  Widget titleWidget() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: height,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget closeWidget(BuildContext context) {
    return SizedBox(
      height: height,
      width: height,
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Color(0xFF757575),
          onTap: onTap != null ? onTap : () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: closeIcon == null ? Icon(Icons.close) : closeIcon,
          ),
        ),
      ),
    );
  }
}

class CitizenNumberFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();

    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 6) + '-');
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));

    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int usedSubstringIndex = 0;

    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '-');
      newText.write(newValue.text.substring(3, usedSubstringIndex = 7) + '-');
      newText.write(newValue.text.substring(7, usedSubstringIndex = 10));
    } else {
      if (newTextLength >= 4) {
        newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '-');
      }
      if (newTextLength >= 7) {
        newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      }
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}
