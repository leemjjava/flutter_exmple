import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class BackdropExample extends StatelessWidget {
  static const String routeName = '/misc/backdrop';
  final frontPanelVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Backdrop(
          frontLayer: FrontPanel(),
          backLayer: BackPanel(
            frontPanelOpen: frontPanelVisible,
          ),
          frontHeader: FrontPanelTitle(),
          panelVisible: frontPanelVisible,
          frontPanelHeight: 100,
          frontHeaderHeight: 48.0,
          frontHeaderVisibleClosed: true,
        ),
      ),
    );
  }
}

class FrontPanelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(
        'Tap Me',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

class FrontPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Theme.of(context).cardColor,
      child: Center(
        child: Text('Hello world'),
      ),
    );
  }
}

class BackPanel extends StatefulWidget {
  BackPanel({
    @required this.frontPanelOpen,
  });
  final ValueNotifier<bool> frontPanelOpen;

  @override
  createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;

  @override
  initState() {
    super.initState();
    panelOpen = widget.frontPanelOpen.value;
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  void _subscribeToValueNotifier() {
    panelOpen = widget.frontPanelOpen.value;
    setState(() {});
  }

  @override
  void didUpdateWidget(BackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Text('Front panel is ${panelOpen ? "open" : "closed"}'),
            ),
          ),
          Center(
            child: RaisedButton(
              child: Text('Tap Me'),
              onPressed: () {
                widget.frontPanelOpen.value = true;
              },
            ),
          ),
          Center(child: Text('Bottom of Panel')),
        ],
      ),
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
    this.title,
    this.child,
    this.titleHeight,
    this.padding,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;
  final double titleHeight;
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              onTap: onTap,
              child: Container(height: titleHeight, child: title),
            ),
            Divider(height: 1.0),
            child,
            // Expanded(child: child),
          ],
        ),
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
    return renderBox.size.height;
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

        final closedPercentage = getClosedPercentage(maxHeight);
        final openPercentage = getOpenPercentage(maxHeight);

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
                  title: widget.frontHeader,
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
    return (maxHeight - panelHeight) / maxHeight;
  }
}
