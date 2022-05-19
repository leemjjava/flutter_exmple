import 'package:flutter/material.dart';

class FadeSizeAnimationExample extends StatefulWidget {
  static const String routeName = '/misc/fade_size_animation';

  @override
  _FadeSizeAnimationExampleState createState() =>
      _FadeSizeAnimationExampleState();
}

class _FadeSizeAnimationExampleState extends State<FadeSizeAnimationExample> {
  final ScrollController _scrollController = new ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  var items = <int>[0, 1, 2];
  int _selectedItem = -1;
  int _nextItem = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FadeSizeAnimationExample'),
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

  Widget _listItemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return CardItem(
      animation: animation,
      item: items[index],
      selected: _selectedItem == items[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == items[index] ? -1 : items[index];
        });
      },
    );
  }

  void _scrollEnd() async {
    final widgetBinding = WidgetsBinding.instance;
    if (widgetBinding == null) return;

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
        _selectedItem == -1 ? items.length : items.indexOf(_selectedItem);
    bool isLast = index == items.length;
    items.insert(index, _nextItem);
    ++_nextItem;

    _listKey.currentState!
        .insertItem(index, duration: Duration(milliseconds: 300));
    if (isLast) _scrollEnd();
  }

  void _remove() {
    int index =
        _selectedItem == -1 ? items.length - 1 : items.indexOf(_selectedItem);
    if (index < 0) return;

    int item = items[index];
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildRemovedItem(context, item, animation),
      duration: Duration(milliseconds: 300),
    );
    items.removeAt(index);

    _selectedItem = -1;
  }

  Widget _buildRemovedItem(
    BuildContext context,
    int item,
    Animation<double> animation,
  ) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    required this.animation,
    required this.item,
    this.onTap,
    this.selected: false,
  }) : super(key: key);

  final Animation<double> animation;
  final int item;
  final GestureTapCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4!;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: getFadeSizeTransition(child: getCardBody(textStyle: textStyle)),
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

  Widget getFadeSizeTransition({
    required Widget child,
  }) {
    return FadeSizeAnimation(
      controller: animation,
      child: child,
    );
  }
}

// ignore: must_be_immutable
class FadeSizeAnimation extends StatelessWidget {
  FadeSizeAnimation({
    Key? key,
    required this.child,
    required this.controller,
    this.containerHeight = 150,
  })  : opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 1, curve: Curves.ease),
          ),
        ),
        height = Tween<double>(begin: 0.0, end: containerHeight).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0, 0.5, curve: Curves.ease),
          ),
        ),
        super(key: key);

  final Widget child;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> height;
  double containerHeight;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Opacity(
      opacity: opacity.value,
      child: Container(
        width: double.infinity,
        height: height.value,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
      child: child,
    );
  }
}
