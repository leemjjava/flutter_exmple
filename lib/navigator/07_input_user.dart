import 'package:flutter/material.dart';
import '../http/blocs/member_bloc.dart';
import '../utile/utile.dart';
import '../http/models/member_input.dart';
import '../http/models/result_body.dart';
import '../utile/ui.dart';

enum CheckBoxType { MAIL, MESSAGE }

class UserInputEx extends StatefulWidget {
  static const String routeName = '/navigator/UserInputEx';

  @override
  State<StatefulWidget> createState() => UserInputExState();
}

class UserInputExState extends State<UserInputEx> {
  final _memberBloc = MemberBloc();
  TextEditingController _emailTec = TextEditingController();
  TextEditingController _passwordTec = TextEditingController();
  TextEditingController _userNameTec = TextEditingController();
  TextEditingController _nickNameTec = TextEditingController();

  bool _allowMailing = false;
  bool _allowMessage = false;

  void _mailChanged(bool? value) => setState(() => _allowMailing = value ?? false);
  void _messageChanged(bool? value) => setState(() => _allowMessage = value ?? false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _emailTec.dispose();
    _passwordTec.dispose();
    _userNameTec.dispose();
    _nickNameTec.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text('회원가입 테스트'));
    var minHeight = MediaQuery.of(context).size.height -
        (appBar.preferredSize.height + MediaQuery.of(context).padding.top);

    var body = SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(
        minHeight: minHeight,
        maxHeight: minHeight,
      ),
      child: getMainColumn(),
    ));

    return Scaffold(
      appBar: appBar,
      body: tfFocusWidget(context, body),
    );
  }

  Widget getMainColumn() {
    return Column(children: <Widget>[
      getTextField(_emailTec, 'eamil', '이메일 입력', false),
      getTextField(_passwordTec, 'passwrod', '비밀번호 입력', true),
      getTextField(_userNameTec, 'name', '이름 입력', false),
      getTextField(_nickNameTec, 'nick', '닉네임 입력', false),
      SizedBox(
        height: 15,
      ),
      getCheckBox(CheckBoxType.MAIL),
      getCheckBox(CheckBoxType.MESSAGE),
      Expanded(child: Container()),
      getExpandedButton('가입', memberCreateOnPress()),
      getMemberCreate(),
      getGradientButton(Text(
        '그라데이션 버튼',
        style: TextStyle(color: Colors.white),
      )),
      getBorderButton(),
    ]);
  }

  VoidCallback memberCreateOnPress() {
    return () {
      _memberBloc.fetchCreate(getUserParam());
    };
  }

  Map<String, String> getUserParam() {
    return {
      'Email_Address': _emailTec.text,
      'Password': _passwordTec.text,
      'User_Name': _userNameTec.text,
      'Nick_Name': _nickNameTec.text,
      'Allow_Mailing': _allowMailing ? 'Y' : 'N',
      'Allow_Message': _allowMessage ? 'Y' : 'N',
    };
  }

  Widget getCheckBox(CheckBoxType type) {
    String title = '';
    bool checkValue = false;
    ValueChanged<bool?>? callBack;

    switch (type) {
      case CheckBoxType.MAIL:
        title = '메일 수신 여부';
        checkValue = _allowMailing;
        callBack = _mailChanged;
        break;

      case CheckBoxType.MESSAGE:
        title = '메세지 수신 여부';
        checkValue = _allowMessage;
        callBack = _messageChanged;
        break;

      default:
    }

    return getTextCheckBox(title, checkValue, callBack);
  }

  Widget getMemberCreate() {
    return StreamBuilder<MemberInputResult>(
      stream: _memberBloc.create,
      builder: (context, snapshot) {
        String? message = snapshot.data!.message;

        if (snapshot.hasError) {
          ResultBody resultBody = snapshot.error as ResultBody;
          message = resultBody.message;
        }

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (message == null) return;
          showAlertDialog(context, message);
        });
        return Container();
      },
    );
  }
}
