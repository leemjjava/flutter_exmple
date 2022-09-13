// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:navigator/components/animation/expansion_view.dart';
import 'package:navigator/components/animation/rotate_view.dart';

// ignore: must_be_immutable
class DropDownView extends StatefulWidget {
  DropDownView({
    Key? key,
    required this.title,
    required this.downButton,
    required this.content,
  }) : super(key: key);

  final Widget title;
  final Widget downButton;
  final Widget content;

  @override
  State<DropDownView> createState() => _DropDownViewState();
}

class _DropDownViewState extends State<DropDownView> {
  final expansion = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionView(
      titleView: titleView(),
      expansionView: widget.content,
      visibleValue: expansion,
    );
  }

  Widget titleView() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          widget.title,
          const Spacer(),
          InkWell(
            onTap: () => expansion.value = !expansion.value,
            child: FittedBox(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: RotateView(
                  visibleValue: expansion,
                  child: widget.downButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
