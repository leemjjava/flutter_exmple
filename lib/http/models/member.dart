import 'package:flutter/foundation.dart';

class Member {
  final int cid;
  final String email_Address;
  final String password;
  final String user_Name;
  final String nick_Name;
  final String allow_Mailing;
  final String allow_Message;
  final String denied;
  final String limit_Date;
  final String reg_Date;
  final String last_Login;
  final String change_Password_Date;
  final String is_Admin;

  Member({
    @required this.cid,
    @required this.email_Address,
    @required this.password,
    @required this.user_Name,
    @required this.nick_Name,
    @required this.allow_Mailing,
    @required this.allow_Message,
    @required this.denied,
    @required this.limit_Date,
    @required this.reg_Date,
    @required this.last_Login,
    @required this.change_Password_Date,
    @required this.is_Admin,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      cid: json['cid'] as int,
      email_Address: json['email_Address'] as String,
      password: json['password'] as String,
      user_Name: json['user_Name'] as String,
      nick_Name: json['nick_Name'] as String,
      allow_Mailing: json['allow_Mailing'] as String,
      allow_Message: json['allow_Message'] as String,
      denied: json['denied'] as String,
      limit_Date: json['limit_Date'] as String,
      reg_Date: json['reg_Date'] as String,
      last_Login: json['last_Login'] as String,
      change_Password_Date: json['change_Password_Date'] as String,
      is_Admin: json['is_Admin'] as String,
    );
  }
}