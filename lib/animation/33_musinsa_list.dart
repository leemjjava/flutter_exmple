import 'package:flutter/material.dart';
import 'package:navigator/components/musinsa_list/musinsa_list_view.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:navigator/utile/utile.dart';

class MusinsaListExample extends StatefulWidget {
  static const String routeName = '/misc/musinsa_list_example';

  @override
  _MusinsaListExampleState createState() => _MusinsaListExampleState();
}

class _MusinsaListExampleState extends State<MusinsaListExample> {
  final list = [
    'assets/sea.jpg',
    'assets/forest02.jpg',
    'assets/forest.jpg',
    'assets/eat_sydney_sm.jpg',
    'assets/eat_new_orleans_sm.jpg',
    'assets/eat_cape_town_sm.jpg',
    'assets/space.png',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          TopBar(title: '무신사 List'),
          SizedBox(height: 350, child: renderListView()),
        ],
      ),
    );
  }

  Widget renderListView() {
    return MusinsaListView(
      itemCount: 100,
      onItemTap: _onItemTap,
      builderFunction: _pageListViewBuilder,
    );
  }

  _pageListViewBuilder(BuildContext context, int index) {
    final pathIndex = index % list.length;
    final path = list[pathIndex];

    return Stack(
      children: <Widget>[
        renderImage(path),
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: renderTitleText(index),
          ),
        ),
      ],
    );
  }

  Widget renderImage(String path) {
    return Hero(
      tag: path,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: Image.asset(path, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x4d000000),
                    Color(0x1f545454),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderTitleText(int index) {
    return Hero(
      tag: "${index}_title",
      child: Material(
        type: MaterialType.transparency, // likely needed
        child: FittedBox(
          child: Text(
            "TITLE : $index",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 32,
              height: (36 / 32),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _onItemTap(int index) {
    final route = createSlideUpRoute(
      widget: DetailView(
        path: list[index],
        title: "TITLE : $index",
        index: index,
      ),
    );
    Navigator.push(context, route);
  }
}

// ignore: must_be_immutable
class DetailView extends StatelessWidget {
  String path;
  String title;
  int index;

  DetailView({
    required this.path,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          TopBar(title: ''),
          renderMain(),
        ],
      ),
    );
  }

  Widget renderMain() {
    return Container(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          renderImage(path),
          Positioned.fill(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: titleText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderImage(String path) {
    return Hero(
      tag: path,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: Image.asset(path, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x4d000000),
                    Color(0x1f545454),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleText() {
    return Hero(
      tag: "${index}_title",
      child: Material(
        type: MaterialType.transparency,
        child: FittedBox(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 32,
              height: (36 / 32),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
