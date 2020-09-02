import 'package:flutter/foundation.dart';

class ErrorModel{
  final int statusCode;
  final int error;
  final String message;

  ErrorModel({
    @required this.statusCode,
    @required this.error,
    @required this.message,
  });

  Map<String,dynamic> toJson(){
    return {
      'success':false,
      'message':message,
      'data':error,
    };
  }
}