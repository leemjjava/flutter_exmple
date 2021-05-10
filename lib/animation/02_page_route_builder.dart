import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PageRouteBuilderDemo extends StatelessWidget {
  static const String routeName = '/basics/page_route_builder';
  late BuildContext context;

  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      appBar: AppBar(title: Text('Slide Page Route')),
      body: Center(child: renderMain()),
    );
  }

  Widget renderMain() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Page 1'),
        SizedBox(height: 10),
        ElevatedButton(
          child: Text('Go!'),
          onPressed: _onTap,
        ),
      ],
    );
  }

  _onTap() {
    final slideRoute = _createRoute();
    Navigator.of(context).push<void>(slideRoute);
  }

  Route _createRoute() {
    return PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) => _Page2(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero);
        var curveTween = CurveTween(curve: Curves.ease);

        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
}

class _Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Slide Page Route')),
      body: Center(child: Text('Page 2')),
    );
  }
}
