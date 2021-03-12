import 'package:flutter/foundation.dart';

class Member {
  final int? cid;
  final String? emailAddress;
  final String? password;
  final String? userName;
  final String? nickName;
  final String? allowMailing;
  final String? allowMessage;
  final String? denied;
  final String? limitDate;
  final String? regDate;
  final String? lastLogin;
  final String? changePasswordDate;
  final String? isAdmin;

  Member({
    @required this.cid,
    @required this.emailAddress,
    @required this.password,
    @required this.userName,
    @required this.nickName,
    @required this.allowMailing,
    @required this.allowMessage,
    @required this.denied,
    @required this.limitDate,
    @required this.regDate,
    @required this.lastLogin,
    @required this.changePasswordDate,
    @required this.isAdmin,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      cid: json['cid'] as int,
      emailAddress: json['email_Address'] as String,
      password: json['password'] as String,
      userName: json['user_Name'] as String,
      nickName: json['nick_Name'] as String,
      allowMailing: json['allow_Mailing'] as String,
      allowMessage: json['allow_Message'] as String,
      denied: json['denied'] as String,
      limitDate: json['limit_Date'] as String,
      regDate: json['reg_Date'] as String,
      lastLogin: json['last_Login'] as String,
      changePasswordDate: json['change_Password_Date'] as String,
      isAdmin: json['is_Admin'] as String,
    );
  }
}
