import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:navigator/components/keyboard/keyboard_layout.dart';

/*
 작성일 : 2021-02-25
 작성자 : Mark,
 화면명 : ,
 경로 : ,
 클래스 : Backdrop,
 설명 : 화면 아래에서 원하는 layout 이 SlideUp 할수 있도록 도와주는 Widget,
*/

const _kFlingVelocity = 2.0;

// ignore: must_be_immutable
class Backdrop extends StatefulWidget {
  final Widget frontLayer;
  final Widget backLayer;
  final Widget? frontHeader;
  final double frontPanelHeight;
  final double frontHeaderHeight;
  final bool frontHeaderVisibleClosed;
  final EdgeInsets frontPanelPadding;
  final KeyboardModelNotifier? panelVisible;
  ScrollController? scrollController;

  Backdrop({
    required this.frontLayer,
    required this.backLayer,
    this.frontPanelHeight = 0.0,
    this.frontHeaderHeight = 48.0,
    this.frontPanelPadding = const EdgeInsets.all(0.0),
    this.frontHeaderVisibleClosed = true,
    this.panelVisible,
    this.frontHeader,
    this.scrollController,
  });

  @override
  createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {
  final _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  late AnimationController _controller;
  double bottomPadding = 0;

  bool get _backdropPanelVisible {
    if (_controller.status == AnimationStatus.completed) return true;
    if (_controller.status == AnimationStatus.forward) return true;

    return false;
  }

  double get _backdropHeight {
    final context = _backdropKey.currentContext;
    if (context == null) return 0.0;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  @override
  void initState() {
    super.initState();
    _setAnimationController();
    _setPanelVisible();
  }

  void _setAnimationController() {
    final isClosed = widget.panelVisible?.value ?? true;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: isClosed ? 1.0 : 0.0,
    );
  }

  void _setPanelVisible() {
    final panelVisible = widget.panelVisible;
    if (panelVisible == null) return;

    panelVisible.addListener(_subscribeToValueNotifier);
    _controller.addStatusListener(_animationStatusListener);
  }

  _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.reverse) _setVisible(false);
    if (status == AnimationStatus.completed) _setVisible(true);
  }

  _setVisible(bool visible) {
    widget.panelVisible!.value = visible;
    final devicePadding = MediaQuery.of(context).padding.bottom;
    final double padding = visible ? widget.frontPanelHeight - devicePadding : 0;

    if (bottomPadding == padding) return;

    bottomPadding = padding;
    if (visible == true) _scrollAnimation();
    setState(() {});
  }

  _scrollAnimation() {
    final dataKey = widget.panelVisible?.key;
    final scrollController = widget.scrollController;
    if (dataKey == null) return;
    if (scrollController == null) return;

    final deviceHeight = Get.height;
    final RenderBox box = dataKey.currentContext!.findRenderObject() as RenderBox;

    final boxY = box.localToGlobal(Offset.zero).dy;
    final boxHeight = box.size.height;

    final boxEndY = boxY + boxHeight;
    final scrollHeight = deviceHeight - widget.frontPanelHeight;

    final nowPosition = scrollHeight - boxEndY;
    if (nowPosition >= 0) return;

    final newOffset = scrollController.offset;
    final offset = nowPosition.abs();

    scrollController.animateTo(
      offset + newOffset,
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  void _subscribeToValueNotifier() {
    if (widget.panelVisible?.value == _backdropPanelVisible) return;
    _toggleBackdropPanelVisibility();
  }

  @override
  void didUpdateWidget(Backdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.panelVisible?.removeListener(_subscribeToValueNotifier);
    widget.panelVisible?.addListener(_subscribeToValueNotifier);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.panelVisible?.dispose();
    super.dispose();
  }

  void _toggleBackdropPanelVisibility() {
    final velocity = _backdropPanelVisible ? -_kFlingVelocity : _kFlingVelocity;
    _controller.fling(velocity: velocity);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating == true) return;
    _controller.value -= details.primaryDelta! / _backdropHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating) return;
    if (_controller.status == AnimationStatus.completed) return;

    final flingVelocity = details.velocity.pixelsPerSecond.dy / _backdropHeight;

    double velocity;
    if (flingVelocity < 0.0)
      velocity = math.max(_kFlingVelocity, -flingVelocity);
    else if (flingVelocity > 0.0)
      velocity = math.min(-_kFlingVelocity, -flingVelocity);
    else
      velocity = _controller.value < 0.5 ? -_kFlingVelocity : _kFlingVelocity;

    _controller.fling(velocity: velocity);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.biggest.height;

        final closedPercentage = getClosedPercentage(maxHeight);
        final openPercentage = getOpenPercentage(maxHeight);

        final panelDetailsPosition = Tween<Offset>(
          begin: Offset(0.0, closedPercentage),
          end: Offset(0.0, openPercentage),
        ).animate(_controller.view);

        return Container(
          color: Color(0xFFFFFFFF),
          key: _backdropKey,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: widget.backLayer,
              ),
              SlideTransition(
                position: panelDetailsPosition,
                child: _BackdropPanel(
                  onTap: _toggleBackdropPanelVisibility,
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  title: widget.frontHeader ?? Container(),
                  titleHeight: widget.frontHeaderHeight,
                  child: widget.frontLayer,
                  padding: widget.frontPanelPadding,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double getClosedPercentage(double maxHeight) {
    final headerRatio = (maxHeight - widget.frontHeaderHeight) / maxHeight;
    return widget.frontHeaderVisibleClosed ? headerRatio : 1.0;
  }

  double getOpenPercentage(double maxHeight) {
    final panelHeight = widget.frontPanelHeight + widget.frontHeaderHeight;
    if (panelHeight > maxHeight) return 0.04;

    return (maxHeight - panelHeight) / maxHeight;
  }
}

class _BackdropPanel extends StatelessWidget {
  const _BackdropPanel({
    Key? key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    required this.child,
    this.titleHeight,
    this.padding,
  }) : super(key: key);

  final VoidCallback? onTap;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final Widget? title;
  final Widget child;
  final double? titleHeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        elevation: 16.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _getHeader(),
            Divider(height: 1.0, color: Color(0xffc2c3c8)),
            child,
          ],
        ),
      ),
    );
  }

  Widget _getHeader() {
    if (title == null) return Container();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        onTap: onTap,
        child: Container(height: titleHeight, child: title),
      ),
    );
  }
}
