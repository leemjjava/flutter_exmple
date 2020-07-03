import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutExample extends StatefulWidget{
  static const String routeName = '/week_of_widget/layout_example';

  @override
  LayoutExampleState createState() =>LayoutExampleState();

}

class LayoutExampleState extends State<LayoutExample>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(Icons.phone,
                    color: Colors.blue,
                  ),
                  Text("CALL",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.near_me,
                    color: Colors.blue,
                  ),
                  Text("ROUTE",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.share,
                    color: Colors.blue,
                  ),
                  Text("SHARE",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}