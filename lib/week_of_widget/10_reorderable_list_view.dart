import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReorderListViewEx extends StatefulWidget {
  static const String routeName = '/week_of_widget/reorderable_list';

  @override
  ReorderListViewExState createState() => ReorderListViewExState();
}

class ReorderListViewExState extends State<ReorderListViewEx> {
  List<String> alphabetList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reorderable ListView Demo"),
      ),
      body: ReorderableListView(
        header: Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Text(
            'This is the hearder!',
            style: TextStyle(
                fontSize: 25, color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
        ),
        onReorder: _onReorder,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: List<ListViewCard>.generate(
          alphabetList.length,
          (index) => ListViewCard(alphabetList, index, Key('$index')),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) newIndex -= 1;

        final String item = alphabetList.removeAt(oldIndex);
        alphabetList.insert(newIndex, item);
      },
    );
  }
}

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  final List<String> listItems;

  ListViewCard(this.listItems, this.index, this.key);

  @override
  _ListViewCard createState() => _ListViewCard();
}

class _ListViewCard extends State<ListViewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () => Fluttertoast.showToast(
            msg: "Item ${widget.listItems[widget.index]} selected.",
            toastLength: Toast.LENGTH_SHORT),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getTextView(isTitle: true),
                  getTextView(isTitle: false),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(
                Icons.reorder,
                color: Colors.grey,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextView({bool isTitle = false}) {
    FontWeight fontWeight = isTitle ? FontWeight.bold : FontWeight.normal;
    String text = isTitle
        ? 'Title ${widget.listItems[widget.index]}'
        : 'Description ${widget.listItems[widget.index]}';

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(fontWeight: fontWeight, fontSize: 16),
        textAlign: TextAlign.left,
        maxLines: 5,
      ),
    );
  }
}
