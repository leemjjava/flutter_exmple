import 'package:flutter/material.dart';
import 'package:navigator/components/animation/fade_page_item.dart';
import 'package:navigator/components/list_view.dart';
import 'package:navigator/components/topbar/top_bar.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: 'Page List Example'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: PageListView(
                  itemCount: 100,
                  onItemTap: _onItemTap,
                  builderFunction: _pageListViewBuilder,
                ),
              ),
            ),
          ],
        ),
      ),
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
              Positioned.fill(child: Image.asset(path, fit: BoxFit.cover)),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(20),
                  child: renderTitleText("TITLE : $index", pagePercent),
                ),
              ),
            ],
          ),
        );
      },
      radius: 4,
    );
  }

  _onItemTap(int index) {}

  // Widget renderImage() {
  //   return Hero(
  //     tag: "${tag}_$index",
  //     child: Image.asset(path, fit: BoxFit.cover),
  //   );
  // }

  Widget renderTitleText(String title, double pagePercent) {
    return Material(
      type: MaterialType.transparency, // likely needed
      child: FittedBox(
        child: Text(
          title,
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
    );
  }
}

// ignore: must_be_immutable
class DetailView extends StatelessWidget {
  String path;
  String title;

  DetailView({
    required this.path,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: ''),
            Container(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(child: Image.asset(path, fit: BoxFit.cover)),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.all(20),
                      child: titleText(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return Material(
      type: MaterialType.transparency, // likely needed
      child: FittedBox(
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 32,
            height: (36 / 32),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
