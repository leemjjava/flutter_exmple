import 'package:flutter/material.dart';
import 'package:navigator/utile/utile.dart';
import '../http/http_repository.dart';
import '../utile/token_decoder.dart';

class LoginEx extends StatefulWidget {
  static const String routeName = '/transparent_image/LoginEx';
  LoginEx({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginExState();
}

class LoginExState extends State<LoginEx> {
  final HttpRepository httpService = HttpRepository();
  TextEditingController _tecId = TextEditingController();
  TextEditingController _tecPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 테스트'),
      ),
      body: getInputField(),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _tecId.dispose();
    _tecPassword.dispose();
    super.dispose();
  }

  Widget getInputField() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Flexible(child: renderTextField("ID", _tecId, false)),
          Flexible(child: renderTextField("password", _tecPassword, true)),
          renderButton('로그인', _loginOnTap),
          renderButton('Account 가져오기', _accountOnTap),
          renderButton('Token 디코딩', _tokenDecodeOnTap),
          renderButton('reToken 전송', _reTokenOnTap),
          FutureBuilder<String>(
            future: getLocalToken(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final jwtMap = parseJwt(snapshot.data!);
                return Text(jwtMap.toString());
              }

              if (snapshot.hasError) return Text("${snapshot.error}");
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Widget renderTextField(String title, TextEditingController tec, bool obscureText) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 30, right: 30, top: 15),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: TextField(
                controller: tec,
                style: TextStyle(color: Colors.black),
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: title,
                  hintStyle: TextStyle(color: Colors.grey[300]),
                ),
                cursorColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderButton(String title, VoidCallback? onPressed) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: Text('reToken 전송'),
          onPressed: onPressed,
        ),
      ),
    );
  }

  _loginOnTap() async {
    try {
      final data = await httpService.getAuthToken(
        _tecId.text,
        _tecPassword.text,
      );

      final content = data.accessToken;
      print(content);
    } catch (e, stacktrace) {
      print(stacktrace);
      showAlertDialog(context, e.toString());
    }
  }

  _accountOnTap() async {
    try {
      final data = await httpService.getMembers();
      final content = data.length.toString();
      print(content);
    } catch (e, stacktrace) {
      print(stacktrace);
      showAlertDialog(context, e.toString());
    }
  }

  _tokenDecodeOnTap() async {
    try {
      final data = await getLocalToken();
      final jwtMap = parseJwt(data as String);
      print(jwtMap);
    } catch (e, stacktrace) {
      print(stacktrace);
      showAlertDialog(context, e.toString());
    }
  }

  _reTokenOnTap() async {
    try {
      final data = await httpService.getReToken();
      final content = data.accessToken;
      print(content);
    } catch (e, stacktrace) {
      print(stacktrace);
      showAlertDialog(context, e.toString());
    }
  }
}
