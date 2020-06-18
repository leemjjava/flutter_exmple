import 'package:flutter/material.dart';

class ValueListenableBuilderEx extends StatefulWidget{
  static const String routeName = '/week_of_widget/value_listenable_builder';
  final String title;

  ValueListenableBuilderEx({
    Key key,
    this.title
  }) : super (key : key);

  @override
  State<StatefulWidget> createState() => ValueListenableBuilderExState();
}

class ValueListenableBuilderExState extends State<ValueListenableBuilderEx>{
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final Widget goodJob = const Text('Good job!!!');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '버튼 좀 계~~~속 많이 눌러 줄 수 있겠니? :',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30,),

            ValueListenableBuilder(
                valueListenable: _counter,
                child: goodJob,
                builder: (BuildContext context, int value, Widget child){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('$value'),
                      child,
                    ],
                  );
                }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: ()=> _counter.value +=1,
      ),
    );
  }
}