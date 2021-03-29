import 'package:flutter/material.dart';
import 'package:navigator/http/models/auth_token.dart';
import 'package:navigator/http/models/member.dart';
import '../utile/token_decoder.dart';
import 'package:flutter/rendering.dart';
import '../http/blocs/member_bloc.dart';
import '../http/blocs/token_bloc.dart';
import 'package:navigator/http/models/result_body.dart';
import '../utile/utile.dart';
import '../utile/ui.dart';
import 'package:provider/provider.dart';

enum ButtonType { NONE, LOGIN, RE_TOKEN, TOKEN_DECODE, ACCOUNT }

class LoginExTwo extends StatefulWidget {
  static const String routeName = '/examples/LoginExTow';
  LoginExTwo({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginExTowState();
}

class LoginExTowState extends State<LoginExTwo> {
  bool networkConnection = false;
  var _memberBloc = MemberBloc();
  var _tokenBloc;
  TextEditingController _idCon = TextEditingController();
  TextEditingController _passwordCon = TextEditingController();
  ButtonType _buttonType = ButtonType.NONE;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _memberBloc.dispose();
    _idCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tokenBloc = Provider.of<TokenBloc>(context);

    debugPaintSizeEnabled = false;
    context = context;
    AppBar appBar = AppBar(title: Text('로그인 테스트'));

    final topHeight = appBar.preferredSize.height + MediaQuery.of(context).padding.top;
    double minHeight = MediaQuery.of(context).size.height - topHeight;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(minHeight: minHeight),
          child: getMainColumn(),
        ),
      ),
    );
  }

  Widget getMainColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        loginLogo(),
        inputColumn(),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: buttonColumn(),
        ),
        Column(
          children: <Widget>[
            getAuthTokenText(),
            getDecodeTokenText(),
            getMember(),
          ],
        ),
      ],
    );
  }

  Widget loginLogo() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Icon(
        Icons.account_box,
        size: 100,
        color: Colors.red,
      ),
    );
  }

  Widget inputColumn() {
    return Column(
      children: <Widget>[
        getTextField(_idCon, 'eamil', '이메일 입력', false),
        getTextField(_passwordCon, 'passwrod', '비밀번호 입력', true),
      ],
    );
  }

  Widget buttonColumn() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: getExpandedButton(
                '로그인',
                () => onPress(ButtonType.LOGIN),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: getExpandedButton(
                '토큰 decode',
                () => onPress(ButtonType.TOKEN_DECODE),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: getExpandedButton(
                'get Member',
                () => onPress(ButtonType.ACCOUNT),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: getExpandedButton(
                '토큰 refresh',
                () => onPress(ButtonType.RE_TOKEN),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onPress(ButtonType type) {
    if (networkConnection == true) return;
    networkConnection = true;
    _buttonType = type;
    blocControl();
  }

  void blocControl() {
    switch (_buttonType) {
      case ButtonType.LOGIN:
        _tokenBloc.fetchAuthToken(_idCon.text, _passwordCon.text);
        break;
      case ButtonType.TOKEN_DECODE:
        _tokenBloc.fetchLocalToken();
        break;
      case ButtonType.RE_TOKEN:
        _tokenBloc.fetchReAuthToken();
        break;
      case ButtonType.ACCOUNT:
        _memberBloc.fetchMembers();
        break;
      default:
    }
  }

  Widget getDecodeTokenText() {
    return Container(
      decoration: getBorderBox(),
      width: double.infinity,
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(5),
      child: StreamBuilder<String>(
          stream: _tokenBloc.localToken,
          builder: (context, snapshot) {
            if (networkConnection == false) return Text("decodeToken no Data");

            networkConnection = false;
            if (snapshot.hasData) {
              final jwtMap = parseJwt(snapshot.data!);

              int expTimestamp = jwtMap['exp'] as int;

              DateTime now = DateTime.now();
              DateTime exp = DateTime.fromMillisecondsSinceEpoch(expTimestamp * 1000);

              String compare = now.compareTo(exp) > 0 ? '토큰 만료' : '토큰 만료되지 않음';

              return Text(
                  "현재 시각: $now\n만료 시각: $exp\n만료 여부: $compare\n\ndecodeToken: ${jwtMap.toString()}");
            } else if (snapshot.hasError) {
              return Text("decodeToken error: ${snapshot.error}");
            }
            // By default, show a loading spinner
            return Text("decodeToken no Data");
          }),
    );
  }

  Widget getAuthTokenText() {
    return Container(
      decoration: getBorderBox(),
      width: double.infinity,
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(5),
      child: StreamBuilder<AuthToken>(
        stream: _tokenBloc.authToken,
        builder: (context, snapshot) {
          if (networkConnection == false) return Text("token no Data");
          networkConnection = false;
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data == null) return Container();
            String accessToken = data.accessToken ?? 'no access token';
            String refreshToken = data.refreshToken ?? 'on refresh Token';
            return Text('accessToken: $accessToken\nrefreshToken: $refreshToken');
          } else if (snapshot.hasError) {
            ResultBody resultBody = snapshot.error as ResultBody;
            showAlertDialog(context, resultBody.message ?? 'no message');

            return Text("token error ${resultBody.statusCode} : ${resultBody.message}");
          }
          // By default, show a loading spinner
          return Text("token no Data");
        },
      ),
    );
  }

  Widget getMember() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(5),
      width: double.infinity,
      decoration: getBorderBox(),
      child: StreamBuilder<List<Member>>(
        stream: _memberBloc.members,
        builder: (context, snapshot) {
          final defaultWidget = Text("member no Data");

          if (networkConnection == false) return Text("member no Data");
          networkConnection = false;

          if (snapshot.hasData) {
            final list = snapshot.data;
            if (list == null) return defaultWidget;

            return renderListView(list);
          } else if (snapshot.hasError) {
            ResultBody resultBody = snapshot.error as ResultBody;
            final title = "member error ${resultBody.statusCode} : ${resultBody.message}";

            return Text(title);
          }
          // By default, show a loading spinner
          return defaultWidget;
        },
      ),
    );
  }

  Widget renderListView(List<Member> list) {
    return Container(
      width: double.infinity,
      child: AbsorbPointer(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildListTile(list, index);
          },
        ),
      ),
    );
  }

  Widget _buildListTile(List<Member> list, int index) {
    var id = list[index].emailAddress;
    var title = list[index].userName;
    var completed = list[index].allowMailing;

    return ListTile(
      leading: Text("$id"),
      title: Text("$title"),
      subtitle: Text(
        "Mailing",
        style: TextStyle(
          color: completed == 'Y' ? Colors.lightBlue : Colors.red,
        ),
      ),
    );
  }

  BoxDecoration getBorderBox() {
    return new BoxDecoration(
      color: Color(0xFFE8F5E9),
      border: Border.all(width: 1, color: Colors.black12),
    );
  }
}
