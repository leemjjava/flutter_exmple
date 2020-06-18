import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/member.dart';
import '../models/member_input.dart';
import 'package:navigator/http/models/result_body.dart';
import '../http_repository.dart';
import 'dart:convert';
import '../../utile/utile.dart';

class MemberApiProvider{
  final TOKEN_KEY = "Authorization";
  final storage = new FlutterSecureStorage();

  final String _memberUrl = "$host/Stage/api/Member";

  Future<List<Member>> getMembers() async {
    String token = await storage.read(key: TOKEN_KEY);
    print("$TOKEN_KEY $token");

    Response res = await get(
        _memberUrl,
        headers: {TOKEN_KEY : '$token'}
    );

    ResultBody resultBody = HttpRepository.getResultBody(_memberUrl, res);
    if(res.statusCode != 200) throw resultBody;

    List<dynamic> body = resultBody.data;

    List<Member> accounts = body.map(
          (dynamic item) => Member.fromJson(item),
    ).toList();

    return accounts;

  }

  final String _createMemberURL = "$host/Stage/api/Member";
  Future<MemberInputResult> createMember(Map<String, String> parameter) async {

    String token = await storage.read(key: TOKEN_KEY);

    MultipartRequest request = MultipartRequest('POST', Uri.parse(_createMemberURL));
    request.fields.addAll(parameter);
    request.headers.addAll({TOKEN_KEY : '$token'});

    StreamedResponse res = await request.send();
    String resStr = await res.stream.bytesToString();

    ResultBody resultBody = HttpRepository.getMultipartResultBody(_createMemberURL, res, resStr);
    if(res.statusCode != 200) throw resultBody;

    Map<String, dynamic> body = resultBody.data;

    return MemberInputResult.fromJson(body,resultBody.message);
  }

}

