import 'package:flutter/services.dart';

class AndroidIntentChannel {
  static const MethodChannel _channel = const MethodChannel('my.example/app_intent');

  Future<String?> appIntent(String url) async {
    final result = await _channel.invokeMethod('app_intent', {'url': url});
    return result;
  }
}
