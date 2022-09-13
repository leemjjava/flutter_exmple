import 'package:flutter/material.dart';
import 'package:navigator/components/animation/drop_down_view.dart';

import '../components/topbar/top_bar.dart';
import '../layouts/default_layout.dart';

class ExpansionViewExample extends StatefulWidget {
  static const String routeName = '/misc/expansion_view_example';
  const ExpansionViewExample({Key? key}) : super(key: key);

  @override
  State<ExpansionViewExample> createState() => _ExpansionViewExampleState();
}

class _ExpansionViewExampleState extends State<ExpansionViewExample> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          TopBar(title: 'Expansion View Example'),
          Expanded(child: mainView()),
        ],
      ),
    );
  }

  Widget mainView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DropDownView(
            title: titleView('title 01'),
            downButton: Icon(Icons.keyboard_arrow_down_sharp),
            content: Container(height: 100, color: Colors.red),
          ),
          DropDownView(
            title: titleView('title 02'),
            downButton: Icon(Icons.keyboard_arrow_down_sharp),
            content: Container(height: 300, color: Colors.blue),
          ),
          DropDownView(
            title: titleView('title 03'),
            downButton: Icon(Icons.keyboard_arrow_down_sharp),
            content: Container(height: 200, color: Colors.green),
          ),
          DropDownView(
            title: titleView('title 04'),
            downButton: Icon(Icons.keyboard_arrow_down_sharp),
            content: Container(height: 1200, color: Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget titleView(String title) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
