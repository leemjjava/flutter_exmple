import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBarWidget extends StatelessWidget {
  static const String routeName = '/examples/custom_bar';

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late double topPadding;

  @override
  Widget build(BuildContext context) {
    topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      body: renderMain(context),
    );
  }

  renderMain(BuildContext context) {
    return Container(
      height: 160.0 + topPadding,
      child: Stack(
        children: <Widget>[
          renderBarWidget(context),
          Positioned(
            top: 80.0 + topPadding,
            left: 0.0,
            right: 0.0,
            child: renderMainWidget(),
          )
        ],
      ),
    );
  }

  renderBarWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: Colors.red,
      width: MediaQuery.of(context).size.width,
      height: 100.0 + topPadding,
      child: Center(
        child: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );
  }

  renderMainWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.0),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
          color: Colors.white,
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.red),
              onPressed: () {
                print("your menu action here");
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: "Search"),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.red),
              onPressed: () => print("your menu action here"),
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.red),
              onPressed: () => print("your menu action here"),
            ),
          ],
        ),
      ),
    );
  }
}
