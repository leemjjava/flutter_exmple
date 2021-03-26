import 'package:flutter/material.dart';

enum PrimaryButtonTheme {
  primary,
  grey,
}

class PrimaryButton extends StatefulWidget {
  final String label;
  final Color? bgColor;
  final Color? txtColor;
  final GestureTapCallback? onTap;
  final PrimaryButtonTheme theme;
  final EdgeInsets padding;

  PrimaryButton({
    required this.label,
    required this.onTap,
    this.bgColor,
    this.txtColor,
    this.theme = PrimaryButtonTheme.primary,
    this.padding = const EdgeInsets.all(18.0),
  });

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.theme == PrimaryButtonTheme.primary
        ? Color(0xFF4042AB)
        : Color(0xFFE0E2E6);

    if (widget.bgColor != null) {
      bgColor = widget.bgColor!;
    }

    Color txtColor =
        widget.theme == PrimaryButtonTheme.primary ? Colors.white : Color(0xFF868686);

    if (widget.txtColor != null) {
      txtColor = widget.txtColor!;
    }

    return Material(
      borderRadius: BorderRadius.circular(6.0),
      color: widget.onTap == null ? Color(0xFFE0E2E6) : bgColor,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: widget.padding,
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 15,
                color: widget.onTap == null ? Color(0xFF868686) : txtColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
