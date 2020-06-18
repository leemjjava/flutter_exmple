import 'package:flutter/material.dart';

class StackEx extends StatefulWidget{
  static const String routeName = '/week_of_widget/stack';

  @override
  StackExState createState() => StackExState();
}

class StackExState extends State<StackEx> with TickerProviderStateMixin{
  StackFit _fit;
  Alignment _alignment;
  AnimationController _animationController;
  Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _fit = StackFit.loose;
    _alignment = Alignment.centerLeft;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = AlignmentTween(begin: Alignment.centerLeft).animate(_animationController);
  }

  _handleFit(StackFit fit) {
    setState(() {
      _fit = fit;
    });
  }

  _handelAlign(Alignment alignment){
    _animation = AlignmentTween(begin: _alignment, end: alignment).animate(_animationController);

    _animationController.reset();
    _animationController.forward();

    _alignment = alignment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('STACK EXAMPLE'),),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 100),
            child: getShowStack(),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: bottomButtons(),
          )
        ],
      ),
    );
  }

  Widget getShowStack() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          fit: _fit,
          alignment: _animation.value ,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              color: Colors.red,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
            Container(
              width: 50,
              height: 50,
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }

  Widget bottomButtons() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      color: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('StackFit'),
          fitButtons(),
          Text('AlignTop'),
          alignTopButtons(),
          Text('AlignCenter'),
          alignCenterButtons(),
          Text('AlignBottom'),
          alignBottomButtons(),
        ],
      )
    );
  }

  Widget fitButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(
            child: Text('loose'),
            onPressed:(){ _handleFit(StackFit.loose);}
        ),
        RaisedButton(
          child: Text('expand'),
            onPressed:(){ _handleFit(StackFit.expand);}
        ),
        RaisedButton(
          child: Text('passthrough'),
            onPressed:(){ _handleFit(StackFit.passthrough);}
        ),
      ],
    );
  }

  Widget alignTopButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(child: Text('Left'),
          onPressed: (){_handelAlign(Alignment.topLeft);},
        ),
        RaisedButton(child: Text('Center'),
          onPressed: (){ _handelAlign(Alignment.topCenter);},
        ),
        RaisedButton(child: Text('Right'),
          onPressed: (){ _handelAlign(Alignment.topRight);},
        ),
      ],
    );
  }

  Widget alignCenterButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(child: Text('Left'),
          onPressed: (){ _handelAlign(Alignment.centerLeft);},
        ),
        RaisedButton(child: Text('center'),
          onPressed: (){ _handelAlign(Alignment.center);},
        ),
        RaisedButton(child: Text('Right'),
          onPressed: (){ _handelAlign(Alignment.centerRight);},
        ),
      ],
    );
  }

  Widget alignBottomButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(child: Text('Left'),
          onPressed: (){ _handelAlign(Alignment.bottomLeft);},
        ),
        RaisedButton(child: Text('Center'),
          onPressed: (){ _handelAlign(Alignment.bottomCenter);},
        ),
        RaisedButton(child: Text('Right'),
          onPressed: (){ _handelAlign(Alignment.bottomRight);},
        ),
      ],
    );
  }


}

