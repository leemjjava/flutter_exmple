import 'package:flutter/material.dart';
import 'package:navigator/layouts/default_layout.dart';

class MainTabBodyLayout extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? action;
  final double topMargin;

  MainTabBodyLayout({
    required this.title,
    required this.body,
    this.action,
    this.topMargin = 18.0,
  });

  @override
  _MainTabBodyLayoutState createState() => _MainTabBodyLayoutState();
}

class _MainTabBodyLayoutState extends State<MainTabBodyLayout> {
  renderAppbar() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: [
          Spacer(),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF434343),
              fontWeight: FontWeight.w700,
            ),
          ),
          if (widget.action == null) Spacer(),
          if (widget.action != null) Expanded(child: widget.action!),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          renderAppbar(),
          Container(height: 1.0, color: Color(0xFFEEEFF2)),
          Container(height: widget.topMargin),
          Expanded(
            child: widget.body,
          ),
        ],
      ),
    );
  }
}
