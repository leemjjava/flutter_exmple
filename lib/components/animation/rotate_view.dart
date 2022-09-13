import 'package:flutter/material.dart';

class RotateView extends StatefulWidget {
  const RotateView({
    Key? key,
    required this.visibleValue,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final Widget child;
  final ValueNotifier<bool> visibleValue;
  final Duration duration;

  @override
  State<RotateView> createState() => _RotateViewState();
}

class _RotateViewState extends State<RotateView>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  late AnimationController _controller;

  late Animation<double> _iconTurns;

  bool _isDown = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    widget.visibleValue.addListener(_handleTap);
  }

  void _handleTap() {
    setState(() {
      _isDown = !_isDown;
      if (_isDown) {
        _controller.forward();
      } else {
        _controller.reverse();
      }

      PageStorage.of(context)?.writeState(context, _isDown);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: widget.child,
    );
  }
}
