import 'package:flutter/foundation.dart';

class Token {
  final int statusCod;
  final String msg;
  final String token;

  Token({
    @required this.statusCod,
    @required this.msg,
    @required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      statusCod: json['statusCod'] as int,
      msg: json['body']['msg'] as String,
      token: json['token'] as String,
    );
  }
}