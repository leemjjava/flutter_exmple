import 'package:navigator/http/models/token.dart';
import 'package:navigator/http/models/member.dart';
import 'package:navigator/http/models/member_input.dart';
import 'package:navigator/http/models/auth_token.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:navigator/http/models/result_body.dart';
import 'dart:convert' show utf8;
import 'package:logger/logger.dart';
import 'resources/login_api_provider.dart';
import 'resources/member_api_provider.dart';

class HttpRepository {
  static ResultBody getResultBody(String url ,Response res){
    var logger = Logger();

    String request = res.request.toString();
    int statusCode = res.statusCode;
    String parse = res.reasonPhrase;
    logger.d('\n$request\n$statusCode $parse');

    Map<String,String> headers = res.headers;
    logger.d(headers);

    String bodyString = utf8.decode(res.bodyBytes);
//    logger.d(bodyString);

    Map<String, dynamic> body = jsonDecode(bodyString);
    logger.d(body);

    return ResultBody.fromJson(body, statusCode);
  }

  static ResultBody getMultipartResultBody(String url ,StreamedResponse res, String resStr){
    var logger = Logger();

    String request = res.request.toString();
    int statusCode = res.statusCode;
    String parse = res.reasonPhrase;
    logger.d('\n$request\n$statusCode $parse');

    Map<String,String> headers = res.headers;
    logger.d(headers);

    Map<String, dynamic> body = jsonDecode(resStr);
    logger.d(body);

    return ResultBody.fromJson(body, statusCode);
  }


  final loginProvider = LoginProvide();

  Future<Token> getToken() => loginProvider.getToken();
  Future<AuthToken> getAuthToken(String id, String password) => loginProvider.getAuthToken(id, password);
  Future<AuthToken> getReToken() => loginProvider.getReToken();

  final memberProvider = MemberApiProvider();

  Future<List<Member>> getMembers() => memberProvider.getMembers();
  Future<MemberInputResult> createMember(Map<String, String> parameter) => memberProvider.createMember(parameter);
}