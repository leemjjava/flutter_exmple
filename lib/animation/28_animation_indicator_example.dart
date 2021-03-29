import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigator/components/animation/animated_liner_indicator.dart';
import 'package:navigator/components/card/circle_network_image.dart';
import 'package:navigator/navigator/10_address_search.dart';

const Color gray6D = Color(0xff6d6d6d);
const Color grayDD = Color(0xffdde1e2);
const Color white = Color(0xffffffff);
const Color blueCA = Color(0xffCACAE7);
const Color orangeF2 = Color(0xffF29061);

class AnimationIndicatorExample extends StatefulWidget {
  static const String routeName = '/misc/animation_indicator_example';

  @override
  AnimationIndicatorExampleState createState() => AnimationIndicatorExampleState();
}

class AnimationIndicatorExampleState extends State<AnimationIndicatorExample> {
  final scrollController = ScrollController();
  final verticalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: 'Animation Indicator'),
            renderMain(),
            SizedBox(height: 16),
            Expanded(child: renderBottom()),
          ],
        ),
      ),
    );
  }

  renderMain() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            '현재 UFO 숫자 50개',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.only(left: 16),
          height: 90,
          child: renderListView(),
        ),
        Container(height: 15.0),
        AnimatedLinerIndicator(
          scrollController: scrollController,
          valueColor: orangeF2,
          backgroundColor: white,
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: grayDD,
        ),
      ],
    );
  }

  Widget renderListView() {
    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: 50,
      itemBuilder: (_, index) => renderListItem(index),
    );
  }

  Widget renderListItem(int index) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(right: 8.0),
            child: renderImageLayout(null),
          ),
          Text(
            '이름',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: gray6D,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderImageLayout(String? path) {
    return Container(
      height: 60,
      width: 60,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(color: blueCA),
      ),
      child: CircleNetworkImage(path: path, imageSize: 54.0),
    );
  }

  Widget renderBottom() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: renderVerticalListView()),
          RotatedBox(
            quarterTurns: 1,
            child: AnimatedLinerIndicator(
              scrollController: verticalScrollController,
              valueColor: orangeF2,
              backgroundColor: white,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderVerticalListView() {
    return ListView.builder(
      controller: verticalScrollController,
      itemCount: 50,
      itemBuilder: (_, index) => renderVerticalListItem(),
    );
  }

  Widget renderVerticalListItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 8.0),
            child: renderImageLayout(null),
          ),
          Expanded(
            child: Text(
              '이름',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: gray6D,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
