import 'package:http/http.dart';
import 'dart:convert' show utf8;
import 'package:logger/logger.dart';
import 'dart:convert';

import 'package:navigator/http/models/address.dart';

class AddressRepository {
  final logger = Logger();

  Future<Address> searchAddress(String query) async {
    String url = "http://www.juso.go.kr/addrlink/addrLinkApi.do$query";

    Response response = await get(Uri.parse(url));
    String bodyString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> body = jsonDecode(bodyString);
    logger.d(body);

    return Address.formJson(body);
  }
}
