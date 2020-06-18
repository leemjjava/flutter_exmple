import 'package:flutter/foundation.dart';

class MemberInputResult<T> {
  final int cid;
  final String message;

  MemberInputResult({
    @required this.cid,
    @required this.message,
  });

  factory MemberInputResult.fromJson(Map<String, dynamic> json, String message) {
    return MemberInputResult(
      cid: json['cid'] as int,
      message: message,
    );
  }

}