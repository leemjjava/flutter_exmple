import 'package:flutter/material.dart';
import 'package:navigator/week_of_widget/16_Nested_scroll_view.dart';
import 'navigator/01_name_routes_arguments.dart';
import 'navigator/02_returning_data.dart';
import 'navigator/03_to_do_list.dart';
import 'navigator/04_hero.dart';
import 'navigator/05_login_test.dart';
import 'navigator/06_login_test_two.dart';
import 'navigator/07_input_user.dart';
import 'navigator/08_custom_bar.dart';

import 'week_of_widget/01_custom_paint_ex.dart';
import 'week_of_widget/02_backdrop_filter.dart';
import 'week_of_widget/03_dismissible.dart';
import 'week_of_widget/04_value_listenable_builder.dart';
import 'week_of_widget/05_sliver_example.dart';
import 'week_of_widget/06_sliver_list_grid.dart';
import 'week_of_widget/07_draggable.dart';
import 'week_of_widget/08_animated_list.dart';
import 'week_of_widget/09_animated_icon.dart';
import 'week_of_widget/10_reorderable_list_view.dart';
import 'week_of_widget/11_animated_switcher.dart';
import 'week_of_widget/12_index_stack.dart';
import 'week_of_widget/13_stack.dart';
import 'week_of_widget/14_draggable_scrollable_sheet.dart';
import 'week_of_widget/15_animated_list.dart';

import 'box_constraint/01_box_constraint.dart';
import 'package:provider/provider.dart';
import 'http/blocs/token_bloc.dart';

void main() {
  return runApp(
      MultiProvider(
        providers: [

          Provider<TokenBloc>(
            create:(context) => TokenBloc(),
            dispose:(context, TokenBloc value) => value.dispose(),
          ),

        ],

        child: MyApp(),
      )
  );
}

class MyRouts {
  final String name;
  final String route;
  final WidgetBuilder builder;

  const MyRouts({this.name, this.route, this.builder});
}

final navigators = [
  MyRouts(
    name: 'Named Routs Arguments',
    route: ArgumentsDemo.routeName,
    builder: (BuildContext context) => ArgumentsDemo()
  ),
  MyRouts(
      name: 'Returning Data',
      route: ReturningDataDemo.routeName,
      builder: (BuildContext context) => ReturningDataDemo()
  ),
  MyRouts(
      name: 'Todo List',
      route: TodoScreen.routeName,
      builder: (BuildContext context) => TodoScreen(todos :
        List.generate(20, (i) => Todo(
            'Todo $i',
            'a description of what needs to be done for Todo $i'
        ))
      )
  ),
  MyRouts(
      name: 'Hero',
      route: MainScreen.routeName,
      builder: (BuildContext context) => MainScreen()
  ),
  MyRouts(
      name: 'Login',
      route: LoginEx.routeName,
      builder: (BuildContext context) => LoginEx()
  ),
  MyRouts(
      name: 'LoginExTwo',
      route: LoginExTwo.routeName,
      builder: (BuildContext context) => LoginExTwo()
  ),
  MyRouts(
      name: 'UserInputEx',
      route: UserInputEx.routeName,
      builder: (BuildContext context) => UserInputEx()
  ),
  MyRouts(
      name: 'CustomBarWidget',
      route: CustomBarWidget.routeName,
      builder: (BuildContext context) => CustomBarWidget()
  ),
];

final weekOfWidgets = [
  MyRouts(
      name: 'Custom Paint',
      route: CustomPaintEx.routeName,
      builder: (BuildContext context) => CustomPaintEx()
  ),
  MyRouts(
      name: 'Backdrop Filter',
      route: BackdropFilterEx.routeName,
      builder: (BuildContext context) => BackdropFilterEx()
  ),
  MyRouts(
      name: 'Dismissible',
      route: DismissibleEx.routeName,
      builder: (BuildContext context) => DismissibleEx()
  ),
  MyRouts(
      name: 'Value Listenable Builder',
      route: ValueListenableBuilderEx.routeName,
      builder: (BuildContext context) => ValueListenableBuilderEx(title: 'Value Listen',)
  ),
  MyRouts(
      name: 'SliverEx',
      route: SliverEx.routeName,
      builder: (BuildContext context) => SliverEx()
  ),
  MyRouts(
      name: 'SliverListGridEx',
      route: SliverListGridEx.routeName,
      builder: (BuildContext context) => SliverListGridEx()
  ),
  MyRouts(
      name: 'DraggableEx',
      route: DraggableEx.routeName,
      builder: (BuildContext context) => DraggableEx()
  ),
  MyRouts(
      name: 'AnimatedListSample',
      route: AnimatedListSample.routeName,
      builder: (BuildContext context) => AnimatedListSample()
  ),
  MyRouts(
      name: 'AnimatedIconEx',
      route: AnimatedIconEx.routeName,
      builder: (BuildContext context) => AnimatedIconEx()
  ),
  MyRouts(
      name: 'ReorderListViewEx',
      route: ReorderListViewEx.routeName,
      builder: (BuildContext context) => ReorderListViewEx()
  ),
  MyRouts(
      name: 'AnimatedSwitcher',
      route: AnimatedSwitcherEx.routeName,
      builder: (BuildContext context) => AnimatedSwitcherEx()
  ),
  MyRouts(
      name: 'IndexStack',
      route: IndexStackEx.routeName,
      builder: (BuildContext context) => IndexStackEx()
  ),
  MyRouts(
      name: 'Stack',
      route: StackEx.routeName,
      builder: (BuildContext context) => StackEx()
  ),
  MyRouts(
      name: 'DraggableScrollableSheet',
      route: DraggableScrollableSheetEx.routeName,
      builder: (BuildContext context) => DraggableScrollableSheetEx()
  ),
  MyRouts(
      name: 'animated_list_example',
      route: AnimatedListExample.routeName,
      builder: (BuildContext context) => AnimatedListExample()
  ),
  MyRouts(
      name: 'nested_scroll_view',
      route: NestedScrollViewExample.routeName,
      builder: (BuildContext context) => NestedScrollViewExample()
  ),
];

final boxConstraints = [
  MyRouts(
      name: 'Box Constraint',
      route: BoxConstraintEx.routeName,
      builder: (BuildContext context) => BoxConstraintEx()
  ),
];

final navigatorsMap =
  Map.fromEntries(navigators.map((MyRouts item) => MapEntry(item.route, item.builder)));

final weekOfWidgetMap =
  Map.fromEntries(weekOfWidgets.map((MyRouts item) => MapEntry(item.route, item.builder)));

final boxConstraintMap =
Map.fromEntries(boxConstraints.map((MyRouts item) => MapEntry(item.route, item.builder)));

final allRoutes = <String, WidgetBuilder>{
  ...navigatorsMap,
  ...weekOfWidgetMap,
  ...boxConstraintMap,
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(),
      routes: allRoutes,
      onGenerateRoute: (RouteSettings settings){
        if(settings.name == PassArgumentsScreen.routeName){
          final ScreenArguments args = settings.arguments;

          return MaterialPageRoute(
              builder: (BuildContext context){
                return PassArgumentsScreen(
                    title: args.title,
                    message: args.messgae
                );
              }
          );
        }

        return null;
      },
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Samples'),
      ),
      body: ListView(
        children: [
          ListTile(title: Text('Navigator', style: headerStyle)),
          ...navigators.map((d) => DemoTile(d)),
          ListTile(title: Text('Week of Widget', style: headerStyle)),
          ...weekOfWidgets.map((d) => DemoTile(d)),
          ListTile(title: Text('BoxConstraint', style: headerStyle)),
          ...boxConstraints.map((d) => DemoTile(d)),
        ],
      ),
    );
  }
}

class DemoTile extends StatelessWidget {
  final MyRouts demo;

  DemoTile(this.demo);

  Widget build(BuildContext context) {
    return ListTile(
      title: Text(demo.name),
      onTap: () {
        Navigator.pushNamed(context, demo.route);
      },
    );
  }
}