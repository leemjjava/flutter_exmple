import 'package:flutter/material.dart';
import '../http/http_repository.dart';
import 'package:navigator/http/models/auth_token.dart';
import 'package:navigator/http/models/member.dart';
import '../utile/token_decoder.dart';

class LoginEx extends StatefulWidget {
  static const String routeName = '/transparent_image/LoginEx';
  LoginEx({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginExState();
}

class LoginExState extends State<LoginEx> {
  final HttpRepository httpService = HttpRepository();
  TextEditingController _tec = TextEditingController();
  TextEditingController _tec2 = TextEditingController();

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
    _tec.dispose();
    _tec2.dispose();
    super.dispose();
  }

  Widget getInputField() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              alignment: Alignment(0.0, 0.0),
              height: 45,
              margin: EdgeInsets.only(left: 30, right: 30, top: 15),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Row(children: <Widget>[
                Container(
                  width: 60,
                  child: Text("ID", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: TextField(
                      controller: _tec,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'ID',
                          hintStyle: TextStyle(color: Colors.grey[300])),
                      cursorColor: Colors.blue,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Flexible(
            child: Container(
              alignment: Alignment(0.0, 0.0),
              height: 45,
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Row(children: <Widget>[
                Container(
                  width: 80,
                  child: Text("passwrod",
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: TextField(
                      controller: _tec2,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '패스워',
                          hintStyle: TextStyle(color: Colors.grey[300])),
                      cursorColor: Colors.blue,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  FutureBuilder<AuthToken>(
                    future: httpService.getAuthToken(_tec.text, _tec2.text),
                    builder: (context, snapshot) {
                      final token = snapshot.data;
                      final content = token?.accessToken ?? 'No Token';

                      return Text(content);
                    },
                  );
                },
                child: Text('로그인'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Account 가져오기'),
                onPressed: () {
                  FutureBuilder<List<Member>>(
                    future: httpService.getMembers(),
                    builder: (context, snapshot) {
                      final listMember = snapshot.data;
                      final count = listMember?.length.toString() ?? 0;

                      return Text(count);
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Token 디코딩'),
                onPressed: () {
                  return FutureBuilder(
                      future: getLocalToken(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        print('token 디코딩\n');

                        if (snapshot.hasData) {
                          final jwtMap = parseJwt(snapshot.data);
                          print(jwtMap);
                        }

                        return Text('');
                      });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('rtoken 전송'),
                onPressed: () {
                  return FutureBuilder<AuthToken>(
                    future: httpService.getReToken(),
                    builder: (context, snapshot) {
                      final token = snapshot.data;
                      final content = token?.accessToken ?? 'No Token';

                      return Text(content);
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            child: FutureBuilder<String>(
                future: getLocalToken(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final jwtMap = parseJwt(snapshot.data);
                    print(jwtMap);
                    return Text(jwtMap.toString());
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner
                  return CircularProgressIndicator();
                }),
          ),
        ],
      ),
    );
  }
}
