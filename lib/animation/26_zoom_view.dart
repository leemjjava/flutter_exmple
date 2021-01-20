import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navigator/utile/button.dart';
import 'package:navigator/utile/resource.dart';
import 'package:navigator/utile/utile.dart';
import 'package:zoom_widget/zoom_widget.dart';

typedef OnItemTap = void Function(String firstNname, String secondName);

class GroupItemModel {
  String firstTitle;
  String secondTitle;
  String thirdTitle;
  String fourthTitle;
  String distance;
  String firstPath;
  String secondPath;

  GroupItemModel({
    this.firstTitle,
    this.secondTitle,
    this.thirdTitle,
    this.fourthTitle,
    this.distance,
    this.firstPath = 'assets/img_logo_01.svg',
    this.secondPath = 'assets/img_logo_02.svg',
  });
}

class ZoomView extends StatefulWidget {
  static const String routeName = '/misc/zoom_view';

  @override
  ZoomViewState createState() => ZoomViewState();
}

class ZoomViewState extends State<ZoomView> {
  String selectTitle = '엄마';
  final zoomContainerHeight = 280.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    final ratio = (queryData.size.width - 32) / zoomContainerHeight;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            renderTopBar(),
            Expanded(child: renderMainContent(ratio)),
            Padding(
              padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: renderSubmitBtn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderTopBar() {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16),
      height: 90,
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWellCS(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 34,
              width: 40,
              child: SvgPicture.asset(
                'assets/arrow_icon.svg',
                width: 24,
                height: 24,
                color: colorGrayA3,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          Text(
            '관계 정정',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderMainContent(double ratio) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              renderUserInfo('요청 보낼 관계', selectTitle, color: colorBlue40),
              SizedBox(width: 26),
              renderUserInfo('나', '나', size: 71),
            ],
          ),
          Expanded(
            child: Center(
              child: FamilyDiagram(
                ratio: ratio,
                mEndGroupModel: mEndGroupModel,
                mSideGroupModel: mSideGroupModel,
                fEndGroupModel: fEndGroupModel,
                fSideGroupModel: fSideGroupModel,
                topGroupModel: topGroupModel,
                bottomGroupModel: bottomGroupModel,
                zoomContainerHeight: zoomContainerHeight,
                onItemTap: (String firstName, String secondName) async {
                  if (secondName == null || secondName == '') {
                    _showSelectTitle(firstName);
                    return;
                  }

                  String showTitle = await showBottomSheet(firstName, secondName);
                  _showSelectTitle(showTitle);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showSelectTitle(String title) {
    if (title == null) return;
    setState(() => selectTitle = title);
  }

  Widget renderUserInfo(String title, String selectItem, {Color color, double size}) {
    return Container(
      width: 120,
      height: 170,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color ?? colorBlack26,
            ),
          ),
          Expanded(
            child: Center(
              child: renderImageWidget(borderColor: color, size: size),
            ),
          ),
          renderNameWidget(selectItem, borderColor: color),
        ],
      ),
    );
  }

  Widget renderImageWidget({Color borderColor, double size}) {
    double height = size ?? 87;
    double radiusCircular = (height + 12) / 2;
    double borderWidth = borderColor == null ? 0 : 2;

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.white,
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
        child: renderNonImage(height),
      ),
    );
  }

  Widget renderNonImage(double imageHeight) {
    return SvgPicture.asset(
      'assets/ic_profile_signin.svg',
      width: imageHeight,
      height: imageHeight,
    );
  }

  Widget renderNameWidget(String selectItem, {Color borderColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 130,
      height: 37,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? colorBlueD7,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        children: [
          Text(
            selectItem,
            style: TextStyle(fontSize: 14, color: colorBlack3E),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_drop_down, size: 30, color: colorBlue40),
            ),
          )
        ],
      ),
    );
  }

  Widget renderSubmitBtn() {
    return ExpandBtnCS(
      title: '정정 요청하기',
      buttonColor: colorBlue40,
      textColor: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 60,
      radius: 6,
      onPressed: () {},
    );
  }

  Future<String> showBottomSheet(String firstName, String secondName) async {
    final sheet = RelationsChoiceSheet(firstName: firstName, secondName: secondName);
    String choiceTitle = await Get.bottomSheet<String>(sheet);

    return choiceTitle;
  }
}

// ignore: must_be_immutable
class FamilyDiagram extends StatelessWidget {
  double zoomContainerHeight = 320, ratio;
  List<GroupItemModel> mEndGroupModel, mSideGroupModel;
  List<GroupItemModel> fEndGroupModel, fSideGroupModel;
  List<GroupItemModel> topGroupModel, bottomGroupModel;
  OnItemTap onItemTap;

  FamilyDiagram({
    @required this.ratio,
    @required this.mEndGroupModel,
    @required this.mSideGroupModel,
    @required this.fEndGroupModel,
    @required this.fSideGroupModel,
    @required this.topGroupModel,
    @required this.bottomGroupModel,
    this.zoomContainerHeight,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    double zoomViewWidth = 2500;
    double zoomViewHeight = 2500 / ratio;

    return Container(
      width: double.infinity,
      height: zoomContainerHeight,
      decoration: BoxDecoration(
        border: Border.all(color: colorBlueD7, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
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
            child: renderEndColumn(mEndGroupModel),
          ),
          Container(
            width: 450,
            child: renderSideColumn(mSideGroupModel),
          ),
          Container(
            width: 700,
            child: renderCenterColumn(topGroupModel, bottomGroupModel),
          ),
          Container(
            width: 450,
            child: renderSideColumn(fSideGroupModel),
          ),
          Container(
            width: 450,
            child: renderEndColumn(fEndGroupModel),
          ),
        ],
      ),
    );
  }

  Widget renderEndColumn(List<GroupItemModel> endModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderNoLineTowItemRow(endModel[0], endModel[1]),
        renderHorizentalLine(50),
        renderNoLineTowItemRow(endModel[2], endModel[3]),
        SizedBox(height: 300),
      ],
    );
  }

  Widget renderSideColumn(List<GroupItemModel> sideGroupModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 150),
        renderNoLineTowItemRow(sideGroupModel[0], sideGroupModel[1]),
        renderHorizentalLine(50),
        renderNoLineTowItemRow(sideGroupModel[2], sideGroupModel[3]),
        renderHorizentalLine(50),
        renderNoLineTowItemRow(sideGroupModel[4], sideGroupModel[5]),
      ],
    );
  }

  Widget renderCenterColumn(
    List<GroupItemModel> topGroupModel,
    List<GroupItemModel> bottomGroupModel,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderBasicText('해당하는 아이콘을 누르시면 가족관계 선택이 됩니다.', fontSize: 30),
        SizedBox(height: 20),
        renderTitle(),
        SizedBox(height: 50),
        renderCenterTopColumn(topGroupModel),
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
        renderCenterBottomRow(bottomGroupModel),
      ],
    );
  }

  Widget renderCenterTopColumn(List<GroupItemModel> topGroupModel) {
    return Column(
      children: [
        renderFullTowItemRow(topGroupModel[0], topGroupModel[1]),
        renderFullTowItemRow(topGroupModel[2], topGroupModel[3]),
        renderFullLineRow(topGroupModel[4], topGroupModel[5]),
      ],
    );
  }

  Widget renderCenterBottomRow(List<GroupItemModel> bottomGroupModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              renderGroupItemNoLine(bottomGroupModel[0]),
              renderGroupItemNoLine(bottomGroupModel[1]),
              renderGroupItemNoLine(bottomGroupModel[2]),
              renderGroupItemNoLine(bottomGroupModel[3]),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            renderChildGroupItem(bottomGroupModel[4]),
            renderChildGroupItem(bottomGroupModel[5]),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              renderGroupItemNoLine(bottomGroupModel[6]),
              renderGroupItemNoLine(bottomGroupModel[7]),
              renderGroupItemNoLine(bottomGroupModel[8]),
              renderGroupItemNoLine(bottomGroupModel[9]),
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
              child: SvgPicture.asset(
                logoPath01,
                width: 100,
                height: 100,
              ),
            ),
          ),
          Expanded(flex: 3, child: renderUserColumn()),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                logoPath02,
                width: 100,
                height: 100,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget renderUserColumn() {
    return Column(
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
                Expanded(flex: 1, child: renderVerticalLine(double.infinity)),
                Expanded(flex: 9, child: Container()),
                Expanded(flex: 1, child: renderVerticalLine(double.infinity)),
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
        firstModel != null ? renderGroupItem(firstModel) : Container(),
        secondModel != null ? renderGroupItem(secondModel) : Container(),
      ],
    );
  }

  Widget renderNoLineTowItemRow(GroupItemModel firstModel, GroupItemModel secondModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        firstModel != null ? renderGroupItemNoLine(firstModel) : Container(),
        secondModel != null ? renderGroupItemNoLine(secondModel) : Container(),
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
              renderRouteWidget(
                model.firstTitle,
                model.thirdTitle,
                model.firstPath,
              ),
              renderRouteWidget(
                model.secondTitle,
                model.fourthTitle,
                model.secondPath,
              ),
            ],
          ),
          renderLineText(model.firstTitle, model.secondTitle, isNoLine: true),
          renderLineText(model.thirdTitle, model.fourthTitle, isNoLine: true),
        ],
      ),
    );
  }

  Widget renderGroupItem(GroupItemModel model) {
    final containerWidth = 190.0;

    return Container(
      width: containerWidth,
      child: Column(
        children: [
          SizedBox(height: 20),
          renderCenterText(model.distance),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderRouteWidget(
                model.firstTitle,
                model.thirdTitle,
                model.firstPath,
              ),
              renderRouteWidget(
                model.secondTitle,
                model.fourthTitle,
                model.secondPath,
              ),
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
          renderLineText(model.firstTitle, model.secondTitle),
          renderLineText(model.thirdTitle, model.fourthTitle),
          Container(
            height: 10,
            alignment: Alignment.center,
            child: renderHorizentalLine(double.infinity),
          ),
        ],
      ),
    );
  }

  Widget renderChildGroupItem(GroupItemModel model) {
    final containerWidth = 190.0;

    return Container(
      width: containerWidth,
      child: Column(
        children: [
          Container(
            height: 20,
            alignment: Alignment.center,
            child: renderHorizentalLine(double.infinity),
          ),
          renderLineText(model.distance, ''),
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
              renderRouteWidget(
                model.firstTitle,
                model.thirdTitle,
                model.firstPath,
              ),
              renderRouteWidget(
                model.secondTitle,
                model.fourthTitle,
                model.secondPath,
              ),
            ],
          ),
          renderLineText(model.firstTitle, model.secondTitle, isNoLine: true),
          renderLineText(model.thirdTitle, model.fourthTitle, isNoLine: true),
        ],
      ),
    );
  }

  Widget renderLineText(String firstTitle, String secondTitle, {bool isNoLine = false}) {
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
          "가족관계도(여자)",
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

  Widget renderRouteWidget(String firstName, String secondName, String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(45),
      ),
      child: InkWellCS(
        splashColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(
            imagePath,
            width: 70,
            height: 70,
          ),
        ),
        onTap: () {
          onItemTap(firstName, secondName);
        },
      ),
    );
  }
}

class RelationsChoiceSheet extends StatelessWidget {
  RelationsChoiceSheet({
    @required this.firstName,
    @required this.secondName,
  });

  final String firstName;
  final String secondName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 248,
      width: double.infinity,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.0),
          topRight: Radius.circular(26.0),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '가족 관계를 선택해주세요 :)',
                style: TextStyle(
                  fontSize: 17,
                  color: colorBlack16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpandBtnCS(
                    title: firstName,
                    buttonColor: colorBlue40,
                    textColor: Colors.white,
                    height: 50,
                    radius: 10,
                    onPressed: () {
                      Get.back(result: firstName);
                    },
                  ),
                  SizedBox(height: 16),
                  ExpandBtnCS(
                    title: secondName,
                    buttonColor: colorBlue40,
                    textColor: Colors.white,
                    height: 50,
                    radius: 10,
                    onPressed: () {
                      Get.back(result: secondName);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
