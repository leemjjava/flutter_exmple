import 'package:flutter/material.dart';

class NestingRoutes extends StatefulWidget {
  static const String routeName = '/examples/nesting_routes';

  @override
  _NestingRoutesState createState() => _NestingRoutesState();
}

class _NestingRoutesState extends State<NestingRoutes> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Root App Bar'),
      ),
      drawer: Container(
        color: Colors.white,
        width: width * 0.8,
        margin: EdgeInsets.only(top: top),
        child: Column(
          children: [
            _drawerBtn('pageOne', '/'),
            _drawerBtn('pageTwo', '/two'),
            _drawerBtn('pageThree', '/three'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: NestedNavigator(
          navigationKey: navigationKey,
          initialRoute: '/',
          routes: {
            // default rout as '/' is necessary!
            '/': (context) => PageOne(),
            '/two': (context) => PageTwo(),
            '/three': (context) => PageThree(),
          },
        ),
      ),
    );
  }

  Widget _drawerBtn(String name, String routePath) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        final currentContext = navigationKey.currentContext;
        if (currentContext == null) return;
        Navigator.of(currentContext).pushReplacementNamed(routePath);
      },
      child: Container(
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(name),
      ),
    );
  }
}

class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigationKey;
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;

  NestedNavigator({
    required this.navigationKey,
    required this.initialRoute,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: navigationKey,
        initialRoute: initialRoute,
        onGenerateRoute: slidUpRoute,
      ),
      onWillPop: () {
        if (navigationKey.currentState?.canPop() == true) {
          navigationKey.currentState?.pop();
          return Future<bool>.value(false);
        }
        return Future<bool>.value(true);
      },
    );
  }

  PageRoute slidUpRoute(RouteSettings routeSettings) {
    final builder = routes[routeSettings.name]!;

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red[100],
        alignment: Alignment.center,
        child: mainColumn(context),
      ),
    );
  }

  Widget mainColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Page One', style: TextStyle(fontSize: 40)),
        SizedBox(height: 16),
        InkWell(
          onTap: () => Navigator.of(context).pushReplacementNamed('/two'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Text('to Page Two'),
          ),
        ),
      ],
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[100],
        alignment: Alignment.center,
        child: mainColumn(context),
      ),
    );
  }

  Widget mainColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Page Two', style: TextStyle(fontSize: 40)),
        SizedBox(height: 16),
        InkWell(
          onTap: () => Navigator.of(context).pushReplacementNamed('/three'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Text('to Page three'),
          ),
        ),
      ],
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green[100],
        alignment: Alignment.center,
        child: mainView(context),
      ),
    );
  }

  Widget mainView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Page Three', style: TextStyle(fontSize: 40)),
        SizedBox(height: 16),
        InkWell(
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Text('to Page one'),
          ),
        ),
      ],
    );
  }
}
