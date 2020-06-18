import 'package:flutter/foundation.dart';

class ResultBody<T> {
  final int statusCdoe;
  final String message;
  final dynamic data;

  ResultBody({
    @required this.statusCdoe,
    @required this.message,
    @required this.data,
  });

  factory ResultBody.fromJson(Map<String, dynamic> json, int statusCdoe) {
    return ResultBody(
      statusCdoe: statusCdoe,
      message: json['message'] as String,
      data: json['data'] as dynamic,
    );
  }

}