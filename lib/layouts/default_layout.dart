import 'package:flutter/material.dart';

/*
* 기본 레이아웃
* */
class DefaultLayout extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Color backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final GestureTapCallback? onTap;
  final PointerDownEventListener? onPointerDown;
  final bool useSafeArea;

  DefaultLayout({
    required this.body,
    this.appBar,
    this.backgroundColor = Colors.white,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset,
    this.onTap,
    this.onPointerDown,
    this.useSafeArea = true,
  });

  @override
  _DefaultLayoutState createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: widget.backgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Listener(
        onPointerDown: widget.onPointerDown,
        behavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTap: widget.onTap,
          child: SafeArea(
            top: widget.useSafeArea,
            bottom: widget.useSafeArea,
            child: widget.body,
          ),
        ),
      ),
    );
  }
}
