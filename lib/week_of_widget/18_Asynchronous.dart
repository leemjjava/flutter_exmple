import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AsyncExample extends StatefulWidget{
  static const String routeName = '/week_of_widget/async_example';

  @override
  AsyncExampleState createState() =>AsyncExampleState();

}

class AsyncExampleState extends State<AsyncExample>{

  int clickCount = 0;
  String value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
              child: Material(
                child: button(),
              )
          ),
        )
    );
  }

  Widget button(){
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        child: Text("나를 눌러줘"),
      ),
      onTap: (){
        ++clickCount;
        print("$clickCount : onTap Start");

        onFutureDelayedStart();

        print("$clickCount : onTap end");
      },
    );
  }

  Future<String> getData(){
    return Future((){
      for(int i = 0; i < 10000000000; ++i){
      }

      return 'I got lots of data! There are 10000000000';
    });
  }


  onFutureStart() async{
    print("$clickCount : onFutureStart Start");

    final value = await getData();
    print("$clickCount : $value");

    print("$clickCount : onFutureStart end");

    this.value = value;
  }

  onFutureDelayedStart() async{
    print("$clickCount : onFutureDelayedStart Start");

    for(int i = 0; i < 7; ++i){
      await Future.delayed(Duration(seconds: 1));
    }
    print("$clickCount : 7 seconds after");

    print("$clickCount : onFutureDelayedStart Start");
  }

  startIsolate(){
    Isolate.spawn(isolateTest, 1);
    Isolate.spawn(isolateTest, 2);
    Isolate.spawn(isolateTest, 3);
  }

  isolateTest(var message){
    print('isolate no.$message');
  }

  getRaisedButton(){
    return RaisedButton(
      child: Text('Click me'),
      onPressed: (){
        final myFuture = get('https://example.com');

        myFuture.then((response){
          if(response.statusCode == 200){
            print('Success!');
          }
        },onError: (error, stacktrace){
          print("onError: $error");
          print(stacktrace.toString());
        });
      },
    );
  }

  getRaisedButton02(){
    return RaisedButton(
      child: Text('Click me'),
      onPressed: () async{
        try{
          final response = await get('https://example.com');

          if(response.statusCode == 200){
            print('Success!');
          }
        }catch(error, stacktrace){
          print("onError: $error");
          print(stacktrace.toString());
        }

      },
    );
  }


}

void main(){
  print('Before the Future');
  Future((){
    print('Running the Future');
  }).then((_){
    print('Future is complete');
  });
  print('After the Future');
}

