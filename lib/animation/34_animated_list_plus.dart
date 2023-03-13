import 'package:flutter/material.dart';

class AnimatedListPlusSample extends StatefulWidget {
  static const String routeName = '/week_of_widget/animated_list_plus';

  @override
  _AnimatedListPlusSampleState createState() => _AnimatedListPlusSampleState();
}

class _AnimatedListPlusSampleState extends State<AnimatedListPlusSample> {
  final List<String> list = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

  final _unselectedListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Two Animated List Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: AnimatedList(
                key: _unselectedListKey,
                initialItemCount: list.length,
                itemBuilder: (context, index, animation) {
                  return InkWell(
                    onTap: () => _moveItem(
                      fromIndex: index,
                      fromList: list,
                      fromKey: _unselectedListKey,
                    ),
                    child: Item(text: list[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _flyingCount = 0;

  _moveItem({
    required int fromIndex,
    required List fromList,
    required GlobalKey<AnimatedListState> fromKey,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final globalKey = GlobalKey();
    final item = fromList.removeAt(fromIndex);
    fromKey.currentState!.removeItem(
      fromIndex,
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Opacity(
            key: globalKey,
            opacity: 0.0,
            child: Item(text: item),
          ),
        );
      },
      duration: duration,
    );
    _flyingCount++;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Find the starting position of the moving item, which is exactly the
      // gap its leaving behind, in the original list.
      final box1 = globalKey.currentContext!.findRenderObject() as RenderBox;
      final pos1 = box1.localToGlobal(Offset.zero);
      // Find the destination position of the moving item, which is at the
      // end of the destination list.

      final max = 50 * (list.length + 3);
      final pos2 = Offset(0, max.toDouble());
      // Insert an overlay to "fly over" the item between two lists.
      final entry = OverlayEntry(builder: (BuildContext context) {
        return TweenAnimationBuilder(
          tween: Tween<Offset>(begin: pos1, end: pos2),
          duration: duration,
          builder: (_, Offset value, child) {
            return Positioned(
              left: value.dx,
              top: value.dy,
              child: Item(text: item),
            );
          },
        );
      });

      Overlay.of(context)!.insert(entry);
      await Future.delayed(duration);
      entry.remove();
      fromList.add(item);
      fromKey.currentState!.insertItem(fromList.length - 1);
      _flyingCount--;
    });
  }
}

class Item extends StatelessWidget {
  final String text;

  const Item({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: width,
        height: 50,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
