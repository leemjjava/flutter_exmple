import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewExample extends StatefulWidget {
  static const String routeName = '/examples/in_app_web_view_example';

  @override
  _InAppWebViewExampleState createState() => new _InAppWebViewExampleState();
}

class _InAppWebViewExampleState extends State<InAppWebViewExample> {
  bool isSetCenter = false;
  late InAppWebViewController controller;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
  );

  @override
  void initState() {
    super.initState();
    setWebView();
  }

  setWebView() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Web Message Channels")),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: renderWebView(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            isSetCenter = true;
            controller.reload();

            setState(() {});
          },
          child: const Icon(Icons.navigation),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget renderWebView() {
    return InAppWebView(
      initialData: InAppWebViewInitialData(data: html),
      initialOptions: options,
      onWebViewCreated: (controller) {
        this.controller = controller;

        controller.addJavaScriptHandler(
          handlerName: 'handlerFoo',
          callback: (args) {
            return {'bar': 'bar_value', 'baz': 'baz_value'};
          },
        );

        controller.addJavaScriptHandler(
          handlerName: 'handlerFooWithArgs',
          callback: (args) {
            print("handlerFooWithArgs : ${args}");
          },
        );
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("Message coming from the Dart side: ${consoleMessage.message}");
      },
      onLoadStop: (controller, url) async {
        this.controller = controller;

        await controller.evaluateJavascript(source: """
                      window.addEventListener("myCustomEvent", (event) => {
                        console.log(JSON.stringify(event.detail));
                      }, false);
                    """);

        await Future.delayed(Duration(seconds: 5));

        controller.evaluateJavascript(source: """
                      const event = new CustomEvent("myCustomEvent", {
                        detail: {foo: 1, bar: false}
                      });
                      window.dispatchEvent(event);
                    """);

        if (isSetCenter) {
          isSetCenter = false;
          controller.evaluateJavascript(source: """
              var moveLatLon = new kakao.maps.LatLng(33.452613, 126.570888);
              // 지도 중심을 이동 시킵니다
              map.setCenter(moveLatLon);
          """);
        }
      },
    );
  }
}

final html = """
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    </head>
    <body>
        <h1>JavaScript Handlers</h1>
        <script>
            window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                window.flutter_inappwebview.callHandler('handlerFoo')
                  .then(function(result) {
                    // print to the console the data coming
                    // from the Flutter side.
                    console.log(JSON.stringify(result));
                    
                    window.flutter_inappwebview
                      .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
                });
            });
        </script>
    </body>
</html>
""";
