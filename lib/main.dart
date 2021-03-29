import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:navigator/animation/20_page_view_fade.dart';
import 'package:navigator/animation/24_animation_alert.dart';
import 'package:navigator/animation/25_transform_example.dart';
import 'package:navigator/example/01_name_routes_arguments.dart';
import 'package:navigator/week_of_widget/16_nested_scroll_view.dart';
import 'package:navigator/week_of_widget/17_layout_example.dart';
import 'package:navigator/week_of_widget/18_Asynchronous.dart';
import 'animation/01_animated_container.dart';
import 'animation/02_page_route_builder.dart';
import 'animation/03_animation_controller.dart';
import 'animation/04_tweens.dart';
import 'animation/05_animated_builder.dart';
import 'animation/06_custom_tween.dart';
import 'animation/07_tween_sequence.dart';
import 'animation/08_tween_builder.dart';
import 'animation/09_time_machine.dart';
import 'animation/10_animated_widget_with_clipper.dart';
import 'animation/11_basic_animation_controller.dart';
import 'animation/12_fade_transition.dart';
import 'animation/13_expand_card.dart';
import 'animation/14_carousel.dart';
import 'animation/15_focus_image.dart';
import 'animation/16_card_swipe.dart';
import 'animation/17_repeating_animation.dart';
import 'animation/19_physics_card_drag.dart';
import 'animation/21_fade_out_route.dart';
import 'animation/22_backdrop.dart';
import 'animation/23_animation_button.dart';
import 'animation/27_fade_size_animation.dart';
import 'animation/28_animation_indicator_example.dart';
import 'animation/29_page_tap_example.dart';
import 'example/02_returning_data.dart';
import 'example/03_to_do_list.dart';
import 'example/04_hero.dart';
import 'example/05_login_test.dart';
import 'example/06_login_test_two.dart';
import 'example/07_input_user.dart';
import 'example/08_custom_bar.dart';
import 'example/09_webSocket.dart';
import 'example/10_address_search.dart';
import 'example/11_open_container_transform.dart';
import 'example/12_text_field.dart';
import 'example/13_custom_keyboard.dart';
import 'example/14_get_x_statement.dart';
import 'example/15_amount_custom_keyboard.dart';
import 'example/16_card_list.dart';
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
          create: (context) => TokenBloc(),
          dispose: (context, TokenBloc value) => value.dispose(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyRouts {
  final String name;
  final String route;
  final WidgetBuilder builder;

  const MyRouts({
    required this.name,
    required this.route,
    required this.builder,
  });
}

final animation = [
  MyRouts(
      name: 'AnimatedContainer',
      route: AnimatedContainerDemo.routeName,
      builder: (context) => AnimatedContainerDemo()),
  MyRouts(
      name: 'PageRouteBuilder',
      route: PageRouteBuilderDemo.routeName,
      builder: (context) => PageRouteBuilderDemo()),
  MyRouts(
      name: 'Animation Controller',
      route: AnimationControllerDemo.routeName,
      builder: (context) => AnimationControllerDemo()),
  MyRouts(name: 'Tweens', route: TweenDemo.routeName, builder: (context) => TweenDemo()),
  MyRouts(
      name: 'AnimatedBuilder',
      route: AnimatedBuilderDemo.routeName,
      builder: (context) => AnimatedBuilderDemo()),
  MyRouts(
      name: 'Custom Tween',
      route: CustomTweenDemo.routeName,
      builder: (context) => CustomTweenDemo()),
  MyRouts(
      name: 'Tween Sequences',
      route: TweenSequenceDemo.routeName,
      builder: (context) => TweenSequenceDemo()),
  MyRouts(
      name: 'Tween builder',
      route: TweenBuilderDemo.routeName,
      builder: (context) => TweenBuilderDemo()),
  MyRouts(
      name: 'Rotation Transition',
      route: TimeMachineDemo.routeName,
      builder: (context) => TimeMachineDemo()),
  MyRouts(
      name: 'Animated Widget',
      route: MyHomePage.routeName,
      builder: (context) => MyHomePage()),
  MyRouts(
      name: 'Basic Animation',
      route: BasicAnimationDemo.routeName,
      builder: (context) => BasicAnimationDemo()),
  MyRouts(
      name: 'Fade Transition',
      route: FadeTransitionDemo.routeName,
      builder: (context) => FadeTransitionDemo()),
  MyRouts(
      name: 'Expandable Card',
      route: ExpandCardDemo.routeName,
      builder: (context) => ExpandCardDemo()),
  MyRouts(
      name: 'Carousel',
      route: CarouselDemo.routeName,
      builder: (context) => CarouselDemo()),
  MyRouts(
      name: 'Focus Image',
      route: FocusImageDemo.routeName,
      builder: (context) => FocusImageDemo()),
  MyRouts(
      name: 'Card Swipe',
      route: CardSwipeDemo.routeName,
      builder: (context) => CardSwipeDemo()),
  MyRouts(
      name: 'Repeating Animation',
      route: RepeatingAnimationDemo.routeName,
      builder: (context) => RepeatingAnimationDemo()),
  MyRouts(
      name: 'Spring Physics',
      route: PhysicsCardDragDemo.routeName,
      builder: (context) => PhysicsCardDragDemo()),
  MyRouts(
      name: 'Page View Fade',
      route: PageViewFade.routeName,
      builder: (context) => PageViewFade()),
  MyRouts(
      name: 'Fade Out Route',
      route: FadeOutRoute.routeName,
      builder: (context) => FadeOutRoute()),
  MyRouts(
      name: 'Backdrop',
      route: BackdropExample.routeName,
      builder: (context) => BackdropExample()),
  MyRouts(
    name: 'AnimationButton',
    route: AnimationButton.routeName,
    builder: (BuildContext context) => AnimationButton(),
  ),
  MyRouts(
    name: 'AnimationAlert',
    route: AnimationAlert.routeName,
    builder: (BuildContext context) => AnimationAlert(),
  ),
  MyRouts(
    name: 'TransformExample',
    route: TransformExample.routeName,
    builder: (BuildContext context) => TransformExample(),
  ),
  MyRouts(
    name: 'FadeSizeAnimation',
    route: FadeSizeAnimationExample.routeName,
    builder: (BuildContext context) => FadeSizeAnimationExample(),
  ),
  MyRouts(
    name: 'Animation Indicator',
    route: AnimationIndicatorExample.routeName,
    builder: (BuildContext context) => AnimationIndicatorExample(),
  ),
  MyRouts(
    name: 'Page Tap',
    route: PageTapExample.routeName,
    builder: (BuildContext context) => PageTapExample(),
  ),
];

final examples = [
  MyRouts(
    name: 'Named Routs Arguments',
    route: ArgumentsDemo.routeName,
    builder: (BuildContext context) => ArgumentsDemo(),
  ),
  MyRouts(
    name: 'Returning Data',
    route: ReturningDataDemo.routeName,
    builder: (BuildContext context) => ReturningDataDemo(),
  ),
  MyRouts(
    name: 'Todo List',
    route: TodoScreen.routeName,
    builder: (BuildContext context) => TodoScreen(
      todoList: List.generate(
        20,
        (i) => Todo('Todo $i', 'a description of what needs to be done for Todo $i'),
      ),
    ),
  ),
  MyRouts(
    name: 'Hero',
    route: MainScreen.routeName,
    builder: (BuildContext context) => MainScreen(),
  ),
  MyRouts(
    name: 'Login',
    route: LoginEx.routeName,
    builder: (BuildContext context) => LoginEx(),
  ),
  MyRouts(
    name: 'LoginExTwo',
    route: LoginExTwo.routeName,
    builder: (BuildContext context) => LoginExTwo(),
  ),
  MyRouts(
    name: 'UserInputEx',
    route: UserInputEx.routeName,
    builder: (BuildContext context) => UserInputEx(),
  ),
  MyRouts(
    name: 'CustomBarWidget',
    route: CustomBarWidget.routeName,
    builder: (BuildContext context) => CustomBarWidget(),
  ),
  MyRouts(
    name: 'WebSocketView',
    route: WebSocketView.routeName,
    builder: (BuildContext context) => WebSocketView(),
  ),
  MyRouts(
    name: 'AddressSearch',
    route: SearchAddress.routeName,
    builder: (BuildContext context) => SearchAddress(),
  ),
  MyRouts(
    name: 'OpenContainerTransformDemo',
    route: OpenContainerTransformDemo.routeName,
    builder: (BuildContext context) => OpenContainerTransformDemo(),
  ),
  MyRouts(
    name: 'TextField',
    route: TextFieldDemo.routeName,
    builder: (BuildContext context) => TextFieldDemo(),
  ),
  MyRouts(
    name: 'CustomKeyboard',
    route: CustomKeyboard.routeName,
    builder: (BuildContext context) => CustomKeyboard(),
  ),
  MyRouts(
    name: 'ReactiveScreen',
    route: ReactiveScreen.routeName,
    builder: (BuildContext context) => ReactiveScreen(),
  ),
  MyRouts(
    name: 'TextFieldCustom',
    route: AmountCustomKeyboard.routeName,
    builder: (BuildContext context) => AmountCustomKeyboard(),
  ),
  MyRouts(
    name: 'Card List',
    route: CardList.routeName,
    builder: (BuildContext context) => CardList(),
  ),
];

final weekOfWidgets = [
  MyRouts(
      name: 'Custom Paint',
      route: CustomPaintEx.routeName,
      builder: (BuildContext context) => CustomPaintEx()),
  MyRouts(
      name: 'Backdrop Filter',
      route: BackdropFilterEx.routeName,
      builder: (BuildContext context) => BackdropFilterEx()),
  MyRouts(
      name: 'Dismissible',
      route: DismissibleEx.routeName,
      builder: (BuildContext context) => DismissibleEx()),
  MyRouts(
      name: 'Value Listenable Builder',
      route: ValueListenableBuilderEx.routeName,
      builder: (BuildContext context) => ValueListenableBuilderEx(
            title: 'Value Listen',
          )),
  MyRouts(
      name: 'SliverEx',
      route: SliverEx.routeName,
      builder: (BuildContext context) => SliverEx()),
  MyRouts(
      name: 'SliverListGridEx',
      route: SliverListGridEx.routeName,
      builder: (BuildContext context) => SliverListGridEx()),
  MyRouts(
      name: 'DraggableEx',
      route: DraggableEx.routeName,
      builder: (BuildContext context) => DraggableEx()),
  MyRouts(
      name: 'AnimatedListSample',
      route: AnimatedListSample.routeName,
      builder: (BuildContext context) => AnimatedListSample()),
  MyRouts(
      name: 'AnimatedIconEx',
      route: AnimatedIconEx.routeName,
      builder: (BuildContext context) => AnimatedIconEx()),
  MyRouts(
      name: 'ReorderListViewEx',
      route: ReorderListViewEx.routeName,
      builder: (BuildContext context) => ReorderListViewEx()),
  MyRouts(
      name: 'AnimatedSwitcher',
      route: AnimatedSwitcherEx.routeName,
      builder: (BuildContext context) => AnimatedSwitcherEx()),
  MyRouts(
      name: 'IndexStack',
      route: IndexStackEx.routeName,
      builder: (BuildContext context) => IndexStackEx()),
  MyRouts(
      name: 'Stack',
      route: StackEx.routeName,
      builder: (BuildContext context) => StackEx()),
  MyRouts(
      name: 'DraggableScrollableSheet',
      route: DraggableScrollableSheetEx.routeName,
      builder: (BuildContext context) => DraggableScrollableSheetEx()),
  MyRouts(
      name: 'animated_list_example',
      route: AnimatedListExample.routeName,
      builder: (BuildContext context) => AnimatedListExample()),
  MyRouts(
      name: 'nested_scroll_view',
      route: NestedScrollViewExample.routeName,
      builder: (BuildContext context) => NestedScrollViewExample()),
  MyRouts(
      name: 'layout_example',
      route: LayoutExample.routeName,
      builder: (BuildContext context) => LayoutExample()),
  MyRouts(
      name: 'async_example',
      route: AsyncExample.routeName,
      builder: (BuildContext context) => AsyncExample()),
];

final boxConstraints = [
  MyRouts(
      name: 'Box Constraint',
      route: BoxConstraintEx.routeName,
      builder: (BuildContext context) => BoxConstraintEx()),
];

final animationMap =
    Map.fromEntries(animation.map((MyRouts item) => MapEntry(item.route, item.builder)));

final examplesMap =
    Map.fromEntries(examples.map((MyRouts item) => MapEntry(item.route, item.builder)));

final weekOfWidgetMap = Map.fromEntries(
    weekOfWidgets.map((MyRouts item) => MapEntry(item.route, item.builder)));

final boxConstraintMap = Map.fromEntries(
    boxConstraints.map((MyRouts item) => MapEntry(item.route, item.builder)));

final allRoutes = <String, WidgetBuilder>{
  ...examplesMap,
  ...weekOfWidgetMap,
  ...boxConstraintMap,
  ...animationMap,
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
      routes: allRoutes,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == PassArgumentsScreen.routeName) {
          final ScreenArguments args = settings.arguments as ScreenArguments;

          return MaterialPageRoute(builder: (BuildContext context) {
            return PassArgumentsScreen(
              title: args.title,
              message: args.messgae,
            );
          });
        }

        return null;
      },
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('MJ Example'),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: [
          ListTile(title: Text('Examples', style: headerStyle)),
          ...examples.map((d) => DemoTile(d)),
          ListTile(title: Text('Week of Widget', style: headerStyle)),
          ...weekOfWidgets.map((d) => DemoTile(d)),
          ListTile(title: Text('BoxConstraint', style: headerStyle)),
          ...boxConstraints.map((d) => DemoTile(d)),
          ListTile(title: Text('Animation', style: headerStyle)),
          ...animation.map((d) => DemoTile(d)),
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
      title: Text(
        demo.name,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, demo.route);
      },
    );
  }
}
