import 'package:flutter/material.dart';
import 'package:navigator/components/animation/fade_page_item.dart';
import 'package:navigator/components/list_view.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:navigator/utile/utile.dart';

class PageListViewExample extends StatefulWidget {
  static const String routeName = '/misc/page_list_view_example';

  @override
  _PageListViewExampleState createState() => _PageListViewExampleState();
}

class _PageListViewExampleState extends State<PageListViewExample> {
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
          TopBar(title: 'Page List Example'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: renderListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderListView() {
    return PageListView(
      itemCount: 100,
      onItemTap: _onItemTap,
      builderFunction: _pageListViewBuilder,
    );
  }

  _pageListViewBuilder(BuildContext context, int index, double scrollPosition) {
    return FadePageItemCS(
      pageScrollPosition: scrollPosition,
      pageNumber: index,
      builderFunction: (context, pagePercent) {
        final pathIndex = index % list.length;
        final path = list[pathIndex];

        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: Stack(
            children: <Widget>[
              renderImage(path),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(20),
                  child: renderTitleText(index, pagePercent),
                ),
              ),
            ],
          ),
        );
      },
      radius: 4,
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

  Widget renderTitleText(int index, double pagePercent) {
    return Hero(
      tag: "${index}_title",
      child: Material(
        type: MaterialType.transparency, // likely needed
        child: FittedBox(
          child: Text(
            "TITLE : $index",
            textAlign: TextAlign.left,
            textScaleFactor: pagePercent,
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
