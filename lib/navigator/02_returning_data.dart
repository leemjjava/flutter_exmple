import 'package:flutter/material.dart';
import '../utile/utile.dart';

class ReturningDataDemo extends StatelessWidget{
  static const String routeName = '/navigator/returing_data';

  void returnDataFunc(BuildContext context, String data) {
    showAlertDialog(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('returning Data Demo'),
      ),
      body: Center(
        child: SelectionButton(returnDataFunc: returnDataFunc,),
      )
    );
  }
}

class SelectionButton extends StatelessWidget{

  SelectionButton({
    Key key,
    @required this.returnDataFunc,
    }) : super( key: key);

  final Function(BuildContext, String) returnDataFunc;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Pick an option, any option!'),
      onPressed: (){
        _navigateAndDisplaySelection(context);
      },
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async{
    String result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SelectionScreen()),
    );

    if(returnDataFunc != null )returnDataFunc(context ,result);
  }
}

class SelectionScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  child: Text('Yep!'),
                  onPressed: (){
                    Navigator.pop(context, 'Yep!');
                  }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  child: Text('Nope!'),
                  onPressed: (){
                    Navigator.pop(context, 'Nope!');
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}