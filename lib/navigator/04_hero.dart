import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MainScreen extends StatefulWidget{
  static const String routeName = '/navigator/hero';
  @override
  State<StatefulWidget> createState() => MainScreenState();
}


class MainScreenState extends State<MainScreen>{
  int index = 0;
  final pageList =[
    'https://picsum.photos/250?image=1',
    'https://picsum.photos/250?image=2',
    'https://picsum.photos/250?image=3',
    'https://picsum.photos/250?image=4',
    'https://picsum.photos/250?image=5',
    'https://picsum.photos/250?image=6',
    'https://picsum.photos/250?image=7',
    'https://picsum.photos/250?image=8',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=10',
    'https://picsum.photos/250?image=11',
    'https://picsum.photos/250?image=12'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MainScreen'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return DetailScreen(path: pageList[index],);
                }));
              },
              child: Hero(
                tag: 'firstHero',
                child:
                Container(
                    padding: EdgeInsets.all(10),
                    child:Stack(
                      children: <Widget>[
                        Center(child:  CircularProgressIndicator(),),
                        FadeInImage.memoryNetwork(
                          fadeInDuration: const Duration(seconds: 2),
                          placeholder: kTransparentImage,
                          image: pageList[index],
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),
          RaisedButton(
            child: Text('indexNow: $index'),
            onPressed: (){
              setState(() {
                index = index == 11? 0: index + 1;
              });
            },
          ),
        ],
      )
    );
  }
}

class DetailScreen extends StatelessWidget{
  final String path;

  DetailScreen({
    Key key,
    this.path
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Hero(
          tag: 'firstHero',
          child :Stack(
            children: <Widget>[
              Center(child:  CircularProgressIndicator(),),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child:FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: path,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
              ),
              ),
            ],
          )

        ),
      ),
    );
  }
}