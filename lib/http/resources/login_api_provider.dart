import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:navigator/http/models/token.dart';
import 'package:navigator/http/models/result_body.dart';
import 'package:navigator/http/models/auth_token.dart';
import '../http_repository.dart';
import 'dart:convert';
import '../../utile/utile.dart';

class LoginProvide {
  final tokenKey = "Authorization";
  final reTokenKey = "refresh_token";
  final storage = new FlutterSecureStorage();

  final String _loginURL = "$host/Stage/api/Auth";

  Future<Token> getToken() async {
    Response res = await get(Uri.parse(_loginURL));

    ResultBody resultBody = HttpRepository.getResultBody(_loginURL, res);
    if (res.statusCode != 200) throw resultBody;

    Map<String, dynamic> body = resultBody.data;

    Token post = Token.fromJson(body);
    String? token = post.token;

    storage.write(key: tokenKey, value: token);
    return Token.fromJson(body);
  }

  final String _authTokenURL = "$authHost/Prod/create";
  Future<AuthToken> getAuthToken(String id, String password) async {
    Map<String, String> parameter = {
      'email_address': id,
      'password': password,
    };

    Response res = await post(Uri.parse(_authTokenURL), body: jsonEncode(parameter));

    ResultBody resultBody = HttpRepository.getResultBody(_authTokenURL, res);
    if (res.statusCode != 200) throw resultBody;

    Map<String, dynamic> body = resultBody.data;

    AuthToken authToken = AuthToken.fromJson(body);
    String? accessToken = authToken.accessToken;
    String? refreshToken = authToken.refreshToken;

    storage.write(key: tokenKey, value: accessToken);
    storage.write(key: reTokenKey, value: refreshToken);
    return AuthToken.fromJson(body);
  }

  final String _authReTokenURL = "$authHost/Prod/refresh";
  Future<AuthToken> getReToken() async {
    String refreshToken = await storage.read(key: reTokenKey) ?? '';
    Map<String, String> headers = {
      reTokenKey: refreshToken,
    };

    print(headers);

    Response res = await post(Uri.parse(_authReTokenURL), headers: headers);

    ResultBody resultBody = HttpRepository.getResultBody(_authReTokenURL, res);
    if (res.statusCode != 200) throw resultBody;

    Map<String, dynamic> body = resultBody.data;

    AuthToken authToken = AuthToken.fromJson(body);
    String accessToken = authToken.accessToken!;
    refreshToken = authToken.refreshToken!;

    storage.write(key: tokenKey, value: accessToken);
    storage.write(key: reTokenKey, value: refreshToken);
    return AuthToken.fromJson(body);
  }
}
