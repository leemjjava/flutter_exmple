import 'package:flutter/foundation.dart';

class AuthToken {
  final String accessToken;
  final String refreshToken;

  AuthToken({
    @required this.accessToken,
    @required this.refreshToken,

  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}