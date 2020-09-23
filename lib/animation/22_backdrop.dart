import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class BackdropExample extends StatefulWidget {
  static const String routeName = '/misc/backdrop';

  @override
  BackdropExampleState createState() => BackdropExampleState();
}

class BackdropExampleState extends State<BackdropExample> {
  final frontPanelVisible = ValueNotifier<bool>(false);
  double frontPanelHeight = 600;
  bool panelOpen;

  @override
  void initState() {
    super.initState();
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  void _subscribeToValueNotifier() {
    panelOpen = frontPanelVisible.value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Backdrop(
          frontHeader: getHeaderWidget(),
          frontLayer: getFrontWidget(),
          backLayer: getBackPanel(),
          frontPanelHeight: frontPanelHeight,
          panelVisible: frontPanelVisible,
          frontHeaderHeight: 30.0,
          frontHeaderVisibleClosed: true,
        ),
      ),
    );
  }

  Widget getHeaderWidget() {
    return Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey,
        size: 30,
      ),
    );
  }

  Widget getFrontWidget() {
    return Container(
      height: frontPanelHeight,
      color: Theme.of(context).cardColor,
      child: Center(child: Text('Backdrop View')),
    );
  }

  Widget getBackPanel() {
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Backdrop View is ${panelOpen ? "open" : "closed"}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getHeightChangeBtn('높이 600', 600),
                  getHeightChangeBtn('높이 400', 400),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getHeightChangeBtn('높이 200', 200),
                  getHeightChangeBtn('높이 100', 100),
                ],
              ),
            ],
          ),
          Center(child: Text('Bottom of Panel')),
        ],
      ),
    );
  }

  Widget getHeightChangeBtn(String title, double height) {
    return FlatButton(
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        frontPanelHeight = height;
        setState(() {
          frontPanelVisible.value = !panelOpen;
        });
      },
    );
  }
}

const _kFlingVelocity = 2.0;

class _BackdropPanel extends StatelessWidget {
  const _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.header,
    this.body,
    this.headerHeight,
    this.padding,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget header;
  final Widget body;
  final double headerHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Material(
        elevation: 12.0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            getHeader(),
            Divider(height: 1.0),
            body,
            // Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget getHeader() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onTap: onTap,
      child: Container(
        height: headerHeight,
        child: header,
      ),
    );
  }
}

class Backdrop extends StatefulWidget {
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontHeader;
  final double frontPanelHeight;
  final double frontHeaderHeight;
  final bool frontHeaderVisibleClosed;
  final EdgeInsets frontPanelPadding;
  final ValueNotifier<bool> panelVisible;

  Backdrop({
    @required this.frontLayer,
    @required this.backLayer,
    this.frontPanelHeight = 0.0,
    this.frontHeaderHeight = 48.0,
    this.frontPanelPadding = const EdgeInsets.all(0.0),
    this.frontHeaderVisibleClosed = true,
    this.panelVisible,
    this.frontHeader,
  })  : assert(frontLayer != null),
        assert(backLayer != null);

  @override
  createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {
  final _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  bool get _backdropPanelVisible {
    if (_controller.status == AnimationStatus.completed) return true;
    if (_controller.status == AnimationStatus.forward) return true;

    return false;
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    final maxHeight = renderBox.size.height;
    double panelBodyHeight = widget.frontPanelHeight;

    if (panelBodyHeight == 0) return maxHeight;

    panelBodyHeight = panelBodyHeight > 0 ? panelBodyHeight : maxHeight + panelBodyHeight;

    return panelBodyHeight + widget.frontHeaderHeight;
  }

  @override
  void initState() {
    super.initState();
    setAnimationController();
    setPanelVisible();
  }

  void setAnimationController() {
    final isClosed = widget.panelVisible?.value ?? true;

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: isClosed ? 1.0 : 0.0,
      vsync: this,
    );
  }

  void setPanelVisible() {
    final panelVisible = widget.panelVisible;
    if (panelVisible == null) return;

    panelVisible.addListener(_subscribeToValueNotifier);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) panelVisible.value = true;
      if (status == AnimationStatus.dismissed) panelVisible.value = false;
    });
  }

  void _subscribeToValueNotifier() {
    if (widget.panelVisible.value == _backdropPanelVisible) return;
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
    _controller.value -= details.primaryDelta / _backdropHeight;
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
        final bodyHeight = widget.frontPanelHeight;

        final closedPercentage = getClosedPercentage(maxHeight);
        final openPercentage = bodyHeight == 0 ? 0.0 : getOpenPercentage(maxHeight);

        final panelDetailsPosition = Tween<Offset>(
          begin: Offset(0.0, closedPercentage),
          end: Offset(0.0, openPercentage),
        ).animate(_controller.view);

        return Container(
          key: _backdropKey,
          child: Stack(
            children: <Widget>[
              widget.backLayer,
              SlideTransition(
                position: panelDetailsPosition,
                child: _BackdropPanel(
                  onTap: _toggleBackdropPanelVisibility,
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  header: widget.frontHeader,
                  headerHeight: widget.frontHeaderHeight,
                  body: widget.frontLayer,
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
    double panelBodyHeight = widget.frontPanelHeight;
    panelBodyHeight = panelBodyHeight > 0 ? panelBodyHeight : maxHeight + panelBodyHeight;

    final panelHeight = panelBodyHeight + widget.frontHeaderHeight;
    return (maxHeight - panelHeight) / maxHeight;
  }
}
