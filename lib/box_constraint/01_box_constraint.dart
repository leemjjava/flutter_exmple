import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BoxConstraintEx extends StatelessWidget{
  static const String routeName = '/box_constraint/dismissible';

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;

    return Scaffold(
        appBar: AppBar(title: Text('Box Constraint TEST'),),
//        body: getContainer(),
        body: getColumn(),
//        body: getRow(),
//        body: getContainerWithSizeBox(),
//        body: getListView(),
//        body: getListViewInnerListView(),
//        body: getButtons(context),
    );
  }

  Widget getContainerWithSizeBox(){
    return Container(
      color: Colors.green,
      child: SizedBox(
        width: 100,
        height: 100,
      ),
    );
  }

  Widget getContainer(){
    return Container(
            constraints: BoxConstraints(
                maxHeight: 400,
                maxWidth: 400,
                minWidth: 300,
                minHeight: 300
            ),
        color:Colors.yellow,
        child:Center(

            child:Container(
              width:100,
              height:100,
              color:Colors.blue,
            )
        )
    );
  }

  Widget getColumn(){
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: getTextList(),
      ),
    );
  }

  Widget getRow(){
    return Container(
      color: Colors.green,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: getTextList(),
      ),
    );
  }


  Widget getListView(){
    return Container(
        constraints: BoxConstraints(
            maxWidth: 200,
        ),
        color:Colors.yellow,
        child:ListView(
          children: <Widget>[
            Card(child: Text('Hello everyone~')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
            ListTile(title: Text('Nice to see you')),
          ],
        )
    );
  }

  Widget getListViewInnerListView(){
    return Container(
        constraints: BoxConstraints(
            maxHeight: double.infinity,
            maxWidth: double.infinity
        ),
        color:Colors.yellow,
        child: ListView(
          // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 160.0,
              color: Colors.red,
            ),
            Container(//Container없이 ListView를 바로 사용하면 에러 발생 함.
              width: 160.0,
              color: Colors.blue,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: getListList(),
              ),
            ),
            Container(
              width: 160.0,
              color: Colors.green,
            ),
            Container(
              width: 160.0,
              color: Colors.yellow,
            ),
            Container(
              width: 160.0,
              color: Colors.orange,
            )
          ],
        )
    );
  }

  List<Widget> getTextList(){
    return <Widget>[
        Container(
        child: getTestText('1번'),
        color: Colors.lightBlue,
        ),
        Container(
        child: getTestText('2번'),
        color: Colors.lightBlue,
        ),
        Container(
        child: getTestText('3번'),
        color: Colors.lightBlue,
        ),
        Container(
        child: getTestText('4번'),
        color: Colors.lightBlue,
        ),
        Container(
        child: getTestText('5번'),
        color: Colors.lightBlue,
        ),
    ];
  }
  List<Widget> getListList(){
    return <Widget>[
      getContainerText('1번'),
      getContainerText('2번'),
      getContainerText('3번'),
      getContainerText('4번'),
      getContainerText('5번'),
      getContainerText('6번'),
      getContainerText('7번'),
      getContainerText('8번'),
      getContainerText('9번'),
      getContainerText('10번'),
      getContainerText('11번'),
      getContainerText('12번'),
      getContainerText('13번'),
      getContainerText('14번'),
      getContainerText('15번'),
      getContainerText('16번'),
      getContainerText('17번'),
      getContainerText('18번'),
      getContainerText('19번'),
      getContainerText('20번'),
      getContainerText('21번'),
      getContainerText('22번'),
      getContainerText('23번'),
      getContainerText('24번'),
      getContainerText('25번'),
      getContainerText('26번'),
    ];
  }

  Widget getContainerText(String data){
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: getTestText(data),
      color: Colors.lightBlue,
    );
  }

  Widget getTestText(String showData){
    return Text(
      showData,
      style: TextStyle(
          fontSize: 26
      ),
    );
  }

  Widget getButtons(BuildContext context){
    return Container(
      alignment: Alignment.bottomCenter,
      height: double.infinity,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text('버튼이유'),
              onPressed: () =>showAlertDialog(context),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child:RaisedButton(
              child: Text('버튼이유2'),
              onPressed: () =>showAlertDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Demo'),
          content: Text("Select button you want"),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }

}