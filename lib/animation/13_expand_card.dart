import 'package:flutter/material.dart';

class ExpandCardDemo extends StatelessWidget {
  static const String routeName = '/misc/expand_card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: ExpandCard()),
    );
  }
}

class ExpandCard extends StatefulWidget {
  _ExpandCardState createState() => _ExpandCardState();
}

class _ExpandCardState extends State<ExpandCard> with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 300);
  bool selected = false;

  double get size => selected ? 256 : 128;

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () => toggleExpanded(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: duration,
            width: size,
            height: size,
            curve: Curves.ease,
            child: renderAnimatedCrossFade(),
          ),
        ),
      ),
    );
  }

  Widget renderAnimatedCrossFade() {
    return AnimatedCrossFade(
      duration: duration,
      firstCurve: Curves.easeInOutCubic,
      secondCurve: Curves.easeInOutCubic,
      crossFadeState: selected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      layoutBuilder: crossFadeBuilder,
      firstChild: renderImage('assets/eat_cape_town_sm.jpg'),
      secondChild: renderImage('assets/eat_new_orleans_sm.jpg'),
    );
  }

  Widget crossFadeBuilder(
    Widget topChild,
    Key topChildKey,
    Widget bottomChild,
    Key bottomChildKey,
  ) {
    return Stack(
      children: [
        Positioned.fill(key: bottomChildKey, child: bottomChild),
        Positioned.fill(key: topChildKey, child: topChild),
      ],
    );
  }

  Widget renderImage(String path) {
    return Image.asset(path, fit: BoxFit.cover);
  }

  void toggleExpanded() {
    selected = !selected;
    setState(() {});
  }
}
