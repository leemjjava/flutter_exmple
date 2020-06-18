import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import '../utile/utile.dart';

class AnimatedSwitcherEx extends StatefulWidget{
  static const String routeName = '/week_of_widget/animated_switcher';

  @override
  AnimatedSwitcherExState createState() => AnimatedSwitcherExState();
}

class AnimatedSwitcherExState extends State<AnimatedSwitcherEx>{
  int _count = 0;
  RandomColor _randomColor = RandomColor();
  MediaQueryData diviceData;
  bool isShow = false;
  Color numberBackground;

  @override
  void initState() {
    super.initState();
    print('initState');
    numberBackground = _randomColor.randomColor();

  }

  Widget myText(){
    return Text(
      '$_count',
      // This key causes the AnimatedSwitcher to interpret this as a "new"
      // child each time the count changes, so that it will begin its animation
      // when the count changes.
      style: TextStyle(
        fontSize: 50,
        color: Colors.white
      ),
    );
  }

  Widget myContainer(){
    print('myContainer');
    return Container(
      height: 100,
      width: 100,
      key: ValueKey<int>(_count),
      color: numberBackground,
      child: Center(child: myText(),),
    );
  }

  @override
  Widget build(BuildContext context) {
    diviceData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('animated switcher example'),),
      body: Stack(
        children: <Widget>[
          animatedSwitcherContainer(),
          animatedPositioned(),
          Positioned(
            bottom: 10,
            right: 10,
            child: FlatButton(
                onPressed: (){
                  setState(() {
                    isShow = !isShow;
                  });
                },
                child: Text('눌러라', style: TextStyle(color: Colors.white),),
                color: Colors.blue,
            ),
          ),
        ],
      )
    );
  }

  Widget animatedSwitcherContainer(){
    return Center(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              printAnimation(animation.status);
              print('transitionBuilder');

              numberBackground = _randomColor.randomColor();
              return ScaleTransition(child: child, scale: animation);
//              return RotationTransition(turns: animation, child: child,);
            },
            child:myContainer(),
          ),
          FlatButton(
            color: Colors.blue,
            child: const Text('Increment', style: TextStyle(color: Colors.white),),
            onPressed: () {
              setState(() {
                _count += 1;
              });
            },
          ),
        ],
      )
    );
  }

  Widget animatedPositioned(){

    double boxHeight = 200;
    double boxWidth = diviceData.size.width - 20;

    double statusBarHeight = diviceData.padding.top;
    double topData = (diviceData.size.height / 2) - ((boxHeight / 2)+ statusBarHeight);

    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      top: isShow ? 0 : topData,
      right: 10,
      child: Container(
        height: boxHeight,
        width: boxWidth,
        color: Colors.blueAccent,
      ),
    );
  }


}