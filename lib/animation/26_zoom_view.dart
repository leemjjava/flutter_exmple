import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigator/navigator/10_address_search.dart';
import 'package:navigator/utile/button.dart';
import 'package:navigator/utile/utile.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ZoomView extends StatefulWidget {
  static const String routeName = '/misc/zoom_view';

  @override
  ZoomViewState createState() => ZoomViewState();
}

class ZoomViewState extends State<ZoomView> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  String selectTitle = '엄마';
  double zoomContainerHeight = 320;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double ratio = (queryData.size.width - 40) / zoomContainerHeight;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              TopBar(
                title: "관계 재요청",
                closeIcon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              Expanded(child: renderMainContent(ratio)),
              Container(
                padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: ExpandBtnCS(
                  title: '보내기',
                  buttonColor: Colors.deepPurple,
                  textColor: Colors.white,
                  height: 60,
                  radius: 10,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderMainContent(double ratio) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              renderUserInfo('요청 보낼 관계', selectTitle, color: Colors.deepPurple),
              SizedBox(width: 50),
              renderUserInfo('본인', '나'),
            ],
          ),
          SizedBox(height: 20),
          renderZoomView(ratio),
        ],
      ),
    );
  }

  Widget renderUserInfo(String title, String selectItem, {Color color}) {
    return Container(
      width: 120,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.black),
          ),
          SizedBox(height: 10),
          renderImageWidget(borderColor: color),
          SizedBox(height: 10),
          renderNameWidget(selectItem),
        ],
      ),
    );
  }

  Widget renderImageWidget({Color borderColor}) {
    double imageHeight = 100;
    double radiusCircular = (imageHeight / 2);
    double borderWidth = borderColor == null ? 0 : 2;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Color(0xFFCCCCCC),
          width: borderWidth,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(radiusCircular),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(radiusCircular),
        ),
        child: nonImage(imageHeight),
      ),
    );
  }

  Widget nonImage(double imageHeight) {
    return Image.asset(
      'assets/person_default.png',
      height: imageHeight,
      width: imageHeight,
      fit: BoxFit.fitHeight,
    );
  }

  Widget renderNameWidget(String selectItem, {Color borderColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Row(
        children: [
          Text(
            selectItem,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_drop_down, size: 30, color: Colors.deepPurple),
            ),
          )
        ],
      ),
    );
  }

  Widget renderZoomView(double ratio) {
    double zoomViewWidth = 2500;
    double zoomViewHeight = 2500 / ratio;

    return Container(
      width: double.infinity,
      height: zoomContainerHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple[100], width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Zoom(
          width: zoomViewWidth,
          height: zoomViewHeight,
          enableScroll: false,
          initZoom: 0.0,
          onPositionUpdate: (Offset position) {},
          onScaleUpdate: (double scale, double zoom) {},
          child: renderContentRow(),
        ),
      ),
    );
  }

  Widget renderContentRow() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 450,
            child: renderEndColumn(),
          ),
          Container(
            width: 450,
            child: renderSideColumn(),
          ),
          Container(
            width: 700,
            child: renderCenterColumn(),
          ),
          Container(
            width: 450,
            child: renderSideColumn(),
          ),
          Container(
            width: 450,
            child: renderEndColumn(),
          ),
        ],
      ),
    );
  }

  Widget renderEndColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderNoLineTowItemRow(
          GroupItemModel(
            distance: '4촌',
            firstTitle: '고모할아버지',
            secondTitle: '고모할머니',
          ),
          GroupItemModel(
            distance: '4촌',
            firstTitle: '증조부',
            secondTitle: '외증조부',
            thirdTitle: '증조모',
            fourthTitle: '외증조모',
          ),
        ),
        renderHorizentalLine(50),
        renderNoLineTowItemRow(
          GroupItemModel(
            distance: '5촌',
            firstTitle: '내종당숙',
            secondTitle: '내종외당숙',
          ),
          GroupItemModel(
            distance: '5촌',
            firstTitle: '당숙',
            secondTitle: '외당숙',
            thirdTitle: '당숙모',
            fourthTitle: '외당숙모',
          ),
        ),
        SizedBox(height: 300),
      ],
    );
  }

  Widget renderSideColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 150),
        renderNoLineTowItemRow(
          GroupItemModel(
            distance: '3촌',
            firstTitle: '고모',
            secondTitle: '이모',
            thirdTitle: '고모부',
            fourthTitle: '이모부',
          ),
          GroupItemModel(
            distance: '3촌',
            firstTitle: '숙(백)부',
            secondTitle: '외삼촌',
            thirdTitle: '숙(백)모',
            fourthTitle: '외숙모',
          ),
        ),
        renderHorizentalLine(50),
        renderNoLineTowItemRow(
          GroupItemModel(
            distance: '4촌',
            firstTitle: '내종형제',
            secondTitle: '이종형제',
          ),
          GroupItemModel(
            distance: '4촌',
            firstTitle: '종형제',
            secondTitle: '외종형제',
          ),
        ),
        renderHorizentalLine(50),
        renderNoLineTowItemRow(
          GroupItemModel(
            distance: '5촌',
            firstTitle: '내종질',
            secondTitle: '이종질',
          ),
          GroupItemModel(
            distance: '5촌',
            firstTitle: '종질',
            secondTitle: '외종질',
          ),
        ),
      ],
    );
  }

  Widget renderCenterColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderBasicText('해당하는 아이콘을 누르시면 가족관계 선택이 됩니다.', fontSize: 30),
        SizedBox(height: 20),
        renderTitle(),
        SizedBox(height: 50),
        renderCenterTopColumn(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 20,
              alignment: Alignment.center,
              child: renderHorizentalLine(double.infinity),
            ),
            Container(
              height: 20,
              alignment: Alignment.center,
              child: renderHorizentalLine(double.infinity),
            ),
          ],
        ),
        renderMainGroup(),
        renderCenterBottomRow(),
      ],
    );
  }

  Widget renderCenterTopColumn() {
    return Column(
      children: [
        renderFullTowItemRow(
          GroupItemModel(
            distance: '3촌',
            firstTitle: '증조부',
            secondTitle: '외증조부',
            thirdTitle: '증조모',
            fourthTitle: '외증조모',
          ),
          GroupItemModel(
            distance: '3촌',
            firstTitle: '증조부',
            secondTitle: '외증조부',
            thirdTitle: '증조모',
            fourthTitle: '외증조모',
          ),
        ),
        renderFullTowItemRow(
          GroupItemModel(
            distance: '2촌',
            firstTitle: '조부',
            secondTitle: '외조부',
            thirdTitle: '조모',
            fourthTitle: '외조모',
          ),
          GroupItemModel(
            distance: '2촌',
            firstTitle: '조부',
            secondTitle: '외조부',
            thirdTitle: '조모',
            fourthTitle: '외조모',
          ),
        ),
        renderFullLineRow(
          GroupItemModel(
            distance: '1촌',
            firstTitle: '시아버지',
            secondTitle: '시어머니',
          ),
          GroupItemModel(
            distance: '1촌',
            firstTitle: '아버지',
            secondTitle: '어머니',
          ),
        ),
      ],
    );
  }

  Widget renderCenterBottomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '',
                  firstTitle: '형님',
                  secondTitle: '아주버님',
                  thirdTitle: '아주버님',
                  fourthTitle: '형님',
                ),
              ),
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '',
                  firstTitle: '아가씨',
                  secondTitle: '도련님',
                  thirdTitle: '서방님',
                  fourthTitle: '동서',
                ),
              ),
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '3촌(조카)',
                  firstTitle: '생질',
                  secondTitle: '질',
                  thirdTitle: '생질녀',
                  fourthTitle: '질녀',
                ),
              ),
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '4촌',
                  firstTitle: '이손',
                  secondTitle: '증손',
                  thirdTitle: '이손녀',
                  fourthTitle: '증손녀',
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            renderChildGroupItem(
              GroupItemModel(
                distance: '1촌',
                firstTitle: '아들',
                secondTitle: '딸',
              ),
            ),
            renderChildGroupItem(
              GroupItemModel(
                distance: '2촌',
                firstTitle: '손자',
                secondTitle: '손녀',
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '',
                  firstTitle: '언니',
                  secondTitle: '오빠',
                  thirdTitle: '형부',
                  fourthTitle: '올케',
                ),
              ),
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '',
                  firstTitle: '여동생',
                  secondTitle: '남동생',
                  thirdTitle: '제부',
                  fourthTitle: '올케',
                ),
              ),
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '3촌(조카)',
                  firstTitle: '생질',
                  secondTitle: '질',
                  thirdTitle: '생질녀',
                  fourthTitle: '질녀',
                ),
              ),
              renderGroupItemNoLine(
                GroupItemModel(
                  distance: '4촌',
                  firstTitle: '이손',
                  secondTitle: '증손',
                  thirdTitle: '이손녀',
                  fourthTitle: '증손녀',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderMainGroup() {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerRight,
              child: Icon(Icons.face, size: 100, color: Colors.blue),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      renderBasicText('남편'),
                      renderBasicText('나'),
                    ],
                  ),
                ),
                renderVerticalLine(double.infinity),
                renderHorizentalLine(50),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.face, size: 100, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  Widget renderFullLineRow(GroupItemModel firstModel, GroupItemModel secondModel) {
    return Stack(
      children: [
        renderFullTowItemRow(firstModel, secondModel),
        Positioned.fill(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: renderVerticalLine(double.infinity),
                ),
                Expanded(flex: 9, child: Container()),
                Expanded(
                  flex: 2,
                  child: renderVerticalLine(double.infinity),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget renderFullTowItemRow(GroupItemModel firstModel, GroupItemModel secondModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        renderGroupItem(firstModel),
        renderGroupItem(secondModel),
      ],
    );
  }

  Widget renderNoLineTowItemRow(GroupItemModel firstModel, GroupItemModel secondModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        renderGroupItemNoLine(firstModel),
        renderGroupItemNoLine(secondModel),
      ],
    );
  }

  Widget renderGroupItemNoLine(GroupItemModel model) {
    final containerWidth = 220.0;

    return Container(
      width: containerWidth,
      child: Column(
        children: [
          SizedBox(height: 5),
          renderCenterText(model.distance),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderRouteWidget(model.firstTitle),
              renderRouteWidget(model.secondTitle),
            ],
          ),
          lineTextRow(model.firstTitle, model.secondTitle, isNoLine: true),
          lineTextRow(model.thirdTitle, model.fourthTitle, isNoLine: true),
        ],
      ),
    );
  }

  Widget renderGroupItem(GroupItemModel model) {
    final containerWidth = 170.0;

    return Container(
      width: containerWidth,
      child: Column(
        children: [
          SizedBox(height: 20),
          renderCenterText(model.distance),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderRouteWidget(model.firstTitle),
              renderRouteWidget(model.secondTitle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderHorizentalLine(25),
              renderHorizentalLine(25),
            ],
          ),
          renderVerticalLine(containerWidth / 2),
          lineTextRow(model.firstTitle, model.secondTitle),
          lineTextRow(model.thirdTitle, model.fourthTitle),
          Container(
            height: 10,
            alignment: Alignment.center,
            child: renderHorizentalLine(double.infinity),
          ),
        ],
      ),
    );
  }

  Widget lineTextRow(String firstTitle, String secondTitle, {bool isNoLine = false}) {
    if (firstTitle == null || firstTitle == '') return Container();
    if (secondTitle == null) secondTitle = '';

    return Container(
      height: 30,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: renderCenterText(firstTitle)),
          isNoLine == true ? Container() : renderHorizentalLine(double.infinity),
          Expanded(child: renderCenterText(secondTitle)),
        ],
      ),
    );
  }

  Widget renderChildGroupItem(GroupItemModel model) {
    final containerWidth = 170.0;

    return Container(
      width: containerWidth,
      child: Column(
        children: [
          Container(
            height: 20,
            alignment: Alignment.center,
            child: renderHorizentalLine(double.infinity),
          ),
          lineTextRow(model.distance, ''),
          renderVerticalLine(containerWidth / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderHorizentalLine(25),
              renderHorizentalLine(25),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderRouteWidget(model.firstTitle),
              renderRouteWidget(model.secondTitle),
            ],
          ),
          lineTextRow(model.firstTitle, model.secondTitle, isNoLine: true),
          lineTextRow(model.thirdTitle, model.fourthTitle, isNoLine: true),
        ],
      ),
    );
  }

  Widget renderCenterText(String title) {
    if (title == null) return Container();

    return Center(child: renderBasicText(title));
  }

  Widget renderBasicText(String title, {double fontSize = 20}) {
    return Text(title, style: TextStyle(fontSize: fontSize));
  }

  Widget renderTitle() {
    return SizedBox(
      width: 1000,
      height: 70,
      child: Center(
        child: Text(
          "가족관계도",
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget renderVerticalLine(double width) {
    return Container(color: Colors.black, width: width, height: 1);
  }

  Widget renderHorizentalLine(double height) {
    return Container(color: Colors.black, width: 1, height: height);
  }

  Widget renderRouteWidget(String title) {
    return InkWellCS(
      splashColor: Colors.grey,
      child: Icon(
        Icons.face,
        size: 70,
        color: Colors.blue,
      ),
      onTap: () {
        setState(() => selectTitle = title);
      },
    );
  }
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Zoom View Example'),
        ),
        body: Center(
          child: Text("디테일 화면입니다."),
        ),
      ),
    );
  }
}

class GroupItemModel {
  String firstTitle;
  String secondTitle;
  String thirdTitle;
  String fourthTitle;
  String distance;

  GroupItemModel({
    this.firstTitle,
    this.secondTitle,
    this.thirdTitle,
    this.fourthTitle,
    this.distance,
  });
}
