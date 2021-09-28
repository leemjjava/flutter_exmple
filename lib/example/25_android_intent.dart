import 'package:flutter/material.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:navigator/method_channel/android_Intent.dart';
import 'package:navigator/utile/utile.dart';

class AndroidIntentScreen extends StatelessWidget {
  static const String routeName = '/examples/android_intent';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          TopBar(title: 'Android Intent Screen'),
          Expanded(child: renderMain()),
        ],
      ),
    );
  }

  Widget renderMain() {
    return Center(
      child: InkWellCS(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Text("Android Intent"),
        ),
        onTap: _onTap,
      ),
    );
  }

  _onTap() async {
    try {
      final url =
          "intent://scan/#Intent;scheme=zxing;package=com.google.zxing.client.android;end";

      final AndroidIntentChannel intent = AndroidIntentChannel();
      await intent.appIntent(url);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }
}
