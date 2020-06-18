import 'package:flutter/material.dart';

class SliverEx extends StatelessWidget {
  static const String routeName = '/week_of_widget/sliver_app_bar';

  List<Container> containerList = [
    Container(color: Colors.red),
    Container(color: Colors.purple),
    Container(color: Colors.green),
    Container(color: Colors.orange),
    Container(color: Colors.yellow),
    Container(color: Colors.pink),
    Container(color: Colors.red),
    Container(color: Colors.purple),
    Container(color: Colors.green),
    Container(color: Colors.orange),
    Container(color: Colors.yellow),
    Container(color: Colors.pink),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('SliverAppBar'),
            backgroundColor: Colors.black,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('assets/forest.jpg', fit: BoxFit.cover),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(containerList,),
          ),
        ],
      ),
    );
  }
}