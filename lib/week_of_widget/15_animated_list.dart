import 'package:flutter/material.dart';

class AnimatedListExample extends StatefulWidget {
  static const String routeName = '/week_of_widget/animated_list_example';

  @override
  _AnimatedListExampleState createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final ScrollController _scrollController = new ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  var items = <int>[0, 1, 2];
  int? _selectedItem;
  int _nextItem = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedListExample'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: _insert,
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: _remove,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: items.length,
          itemBuilder: _listItemBuilder,
          controller: _scrollController,
        ),
      ),
    );
  }

  Widget _listItemBuilder(context, index, animation) {
    return CardItem(
      animation: animation,
      item: items[index],
      selected: _selectedItem == items[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == items[index] ? null : items[index];
        });
      },
    );
  }

  void _scrollEnd() {
    final widgetBinding = WidgetsBinding.instance;
    widgetBinding.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  void _insert() {
    int index =
        _selectedItem == null ? items.length : items.indexOf(_selectedItem!);
    if (index == items.length) _scrollEnd();

    items.insert(index, _nextItem);
    ++_nextItem;

    _listKey.currentState!
        .insertItem(index, duration: Duration(milliseconds: 300));
  }

  void _remove() {
    int index = _selectedItem == null
        ? items.length - 1
        : items.indexOf(_selectedItem!);
    if (index < 0) return;

    final currentState = _listKey.currentState;
    if (currentState == null) return;

    int item = items[index];
    currentState.removeItem(
      index,
      (context, animation) => _buildRemovedItem(context, item, animation),
      duration: Duration(milliseconds: 300),
    );
    items.removeAt(index);

    _selectedItem = -1;
  }

  Widget _buildRemovedItem(
      BuildContext context, int item, Animation<double> animation) {
    return CardItem(animation: animation, item: item, selected: false);
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    required this.animation,
    required this.item,
    this.selected = false,
    this.onTap,
  });

  final Animation<double> animation;
  final int item;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4!;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: getSlideTransition(child: getCardBody(textStyle: textStyle)),
    );
  }

  Widget getCardBody({TextStyle? textStyle}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 128.0,
        child: Card(
          color: Colors.primaries[item % Colors.primaries.length],
          child: Center(
            child: Text('Item $item', style: textStyle),
          ),
        ),
      ),
    );
  }

  Widget getSizeTransition({
    required Widget child,
  }) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: child,
    );
  }

  Widget getSlideTransition({
    required Widget child,
  }) {
    return SlideTransition(
      position: animation.drive(Tween(
        begin: Offset(1, 0),
        end: Offset(0.0, 0),
      ).chain(CurveTween(curve: Curves.easeOutExpo))),
      child: child,
    );
  }
}
