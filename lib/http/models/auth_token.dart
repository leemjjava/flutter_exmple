class AuthToken {
  final String? accessToken;
  final String? refreshToken;

  AuthToken({
    this.accessToken,
    this.refreshToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
