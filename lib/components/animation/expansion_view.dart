import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpansionView extends StatefulWidget {
  ExpansionView({
    Key? key,
    required this.titleView,
    required this.expansionView,
    required this.visibleValue,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  Widget titleView;
  Widget expansionView;

  final ValueNotifier<bool> visibleValue;
  final bool initiallyExpanded;
  final Duration duration;

  @override
  State<ExpansionView> createState() => _ExpansionViewState();
}

class _ExpansionViewState extends State<ExpansionView>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late Animation<double> _heightFactor;
  late AnimationController _controller;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _heightFactor = _controller.drive(_easeInTween);

    final readState = PageStorage.of(context)?.readState(context);
    _isExpanded = readState as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;

    widget.visibleValue.addListener(_handleTap);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _reverse();
      }

      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  void _reverse() {
    _controller.reverse().then<void>((void value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.titleView,
        ClipRect(
          child: Align(heightFactor: _heightFactor.value, child: child),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: Offstage(
        offstage: closed,
        child: TickerMode(
          enabled: !closed,
          child: widget.expansionView,
        ),
      ),
    );
  }
}
