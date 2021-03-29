import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DismissibleEx extends StatefulWidget {
  static const String routeName = '/week_of_widget/dismissible';
  DismissibleEx({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DismissibleExState();
}

class DismissibleExState extends State<DismissibleEx> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    final title = 'Dismissing Items';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];

            return Dismissible(
              key: Key(item),
//            direction: DismissDirection.vertical,
              onDismissed: (DismissDirection direction) {
                setState(() {
                  items.removeAt(index);
                });

                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$item dismiss'),
                  ),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.check),
              ),
              secondaryBackground: Container(
                color: Colors.green,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.cancel),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                height: 80,
                child: Center(
                  child: Text(
                    '$item',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
