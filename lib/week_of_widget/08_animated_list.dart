import 'package:flutter/material.dart';

class AnimatedListSample extends StatefulWidget {
  static const String routeName = '/week_of_widget/animated_list';

  @override
  _AnimatedListSampleState createState() => _AnimatedListSampleState();
}

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final ScrollController _scrollController = new ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<int> _list;
  int? _selectedItem;
  int _nextItem =
      3; // The next item inserted when the user presses the '+' button.
  bool isEndAdd = false;

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
  }

  void printAnimation(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        print('forward');
        break;
      case AnimationStatus.reverse:
        print('reverse');
        break;
      case AnimationStatus.completed:
        print('completed');
        break;
      case AnimationStatus.dismissed:
        print('dismissed');
        break;
      default:
    }
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    printAnimation(animation.status);

//    if(_selectedItem == null) scrollEnd();

    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  Widget _buildRemovedItem(
      BuildContext context, int item, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  void _insert() {
    int index =
        _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
    _list.insert(index, _nextItem++);
  }

  void scrollEnd() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem!));
      setState(() {
        _selectedItem = null;
      });
    }
    if (_list.length > 0) {
      _list.removeAt(_list.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: _insert,
            tooltip: 'insert a new item',
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: _remove,
            tooltip: 'remove the selected item',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _list.length,
          itemBuilder: _buildItem,
          controller: _scrollController,
        ),
      ),
    );
  }
}

class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final Function(BuildContext, E, Animation<double>) removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState!;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index, duration: Duration(milliseconds: 400));
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(context, removedItem, animation);
      }, duration: Duration(milliseconds: 400));
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    required this.animation,
    required this.item,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final Animation<double> animation;
  final VoidCallback? onTap;
  final int item;
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

  Widget getSizeTransition({Widget? child}) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: child,
    );
  }

  Widget getSlideTransition({Widget? child}) {
    return SlideTransition(
      position: animation.drive(Tween(begin: Offset(1, 0), end: Offset(0.0, 0))
          .chain(CurveTween(curve: Curves.elasticInOut))),
      child: child,
    );
  }

//  Widget getSlideTransition({Widget child}){
//    return FadeTransition(
//      position: animation.drive(Tween(begin: Offset(0, 1), end: Offset(0.0, 0))),
//      child: child,
//    );
//  }
}
