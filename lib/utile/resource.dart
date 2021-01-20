import 'package:flutter/cupertino.dart';
import 'package:navigator/animation/26_zoom_view.dart';

EdgeInsets rootMidPadding = EdgeInsets.only(left: 10, right: 10);

const Color quickBlue6601 = Color(0x66014F90);
const Color colorBlue3F = Color(0xFF3F45AA);
const Color colorBlue40 = Color(0xFF4042ab);
const Color colorBlueD7 = Color(0xFFd7d8ee);

const Color colorGrayA3 = Color(0xFFa3a3a3);

const Color colorBlack3E = Color(0xFF3e3e3e);
const Color colorBlack26 = Color(0xFF262626);
const Color colorBlack16 = Color(0xFF161616);

final logoPath01 = 'assets/img_logo_01.svg';
final logoPath02 = 'assets/img_logo_02.svg';
final logoPath03 = 'assets/img_logo_03.svg';
final logoPath04 = 'assets/img_logo_04.svg';

List<GroupItemModel> mEndGroupModel = [
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
];

List<GroupItemModel> mSideGroupModel = [
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
];

List<GroupItemModel> fEndGroupModel = [
  GroupItemModel(
    distance: '4촌',
    firstTitle: '고모할아버지',
    secondTitle: '고모할머니',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '4촌',
    firstTitle: '증조부',
    secondTitle: '외증조부',
    thirdTitle: '증조모',
    fourthTitle: '외증조모',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '5촌',
    firstTitle: '내종당숙',
    secondTitle: '내종외당숙',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '5촌',
    firstTitle: '당숙',
    secondTitle: '외당숙',
    thirdTitle: '당숙모',
    fourthTitle: '외당숙모',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
];

List<GroupItemModel> fSideGroupModel = [
  GroupItemModel(
    distance: '3촌',
    firstTitle: '고모',
    secondTitle: '이모',
    thirdTitle: '고모부',
    fourthTitle: '이모부',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '3촌',
    firstTitle: '숙(백)부',
    secondTitle: '외삼촌',
    thirdTitle: '숙(백)모',
    fourthTitle: '외숙모',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '4촌',
    firstTitle: '내종형제',
    secondTitle: '이종형제',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '4촌',
    firstTitle: '종형제',
    secondTitle: '외종형제',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '5촌',
    firstTitle: '내종질',
    secondTitle: '이종질',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '5촌',
    firstTitle: '종질',
    secondTitle: '외종질',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
];

List<GroupItemModel> topGroupModel = [
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
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
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
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
  GroupItemModel(
    distance: '1촌',
    firstTitle: '시아버지',
    secondTitle: '시어머니',
  ),
  GroupItemModel(
    distance: '1촌',
    firstTitle: '아버지',
    secondTitle: '어머니',
    firstPath: logoPath03,
    secondPath: logoPath04,
  ),
];

List<GroupItemModel> bottomGroupModel = [
  GroupItemModel(
    distance: '',
    firstTitle: '형님',
    secondTitle: '아주버님',
    thirdTitle: '아주버님',
    fourthTitle: '형님',
    firstPath: logoPath01,
    secondPath: logoPath01,
  ),
  GroupItemModel(
    distance: '',
    firstTitle: '아가씨',
    secondTitle: '도련님',
    thirdTitle: '서방님',
    fourthTitle: '동서',
    firstPath: logoPath01,
    secondPath: logoPath01,
  ),
  GroupItemModel(
    distance: '3촌(조카)',
    firstTitle: '생질',
    secondTitle: '질',
    thirdTitle: '생질녀',
    fourthTitle: '질녀',
    firstPath: logoPath01,
    secondPath: logoPath01,
  ),
  GroupItemModel(
    distance: '4촌',
    firstTitle: '이손',
    secondTitle: '증손',
    thirdTitle: '이손녀',
    fourthTitle: '증손녀',
    firstPath: logoPath01,
    secondPath: logoPath01,
  ),
  GroupItemModel(
    distance: '1촌',
    firstTitle: '아들',
    secondTitle: '딸',
  ),
  GroupItemModel(
    distance: '2촌',
    firstTitle: '손자',
    secondTitle: '손녀',
  ),
  GroupItemModel(
    distance: '',
    firstTitle: '언니',
    secondTitle: '오빠',
    thirdTitle: '형부',
    fourthTitle: '올케',
    firstPath: logoPath02,
    secondPath: logoPath02,
  ),
  GroupItemModel(
    distance: '',
    firstTitle: '여동생',
    secondTitle: '남동생',
    thirdTitle: '제부',
    fourthTitle: '올케',
    firstPath: logoPath02,
    secondPath: logoPath02,
  ),
  GroupItemModel(
    distance: '3촌(조카)',
    firstTitle: '생질',
    secondTitle: '질',
    thirdTitle: '생질녀',
    fourthTitle: '질녀',
    firstPath: logoPath02,
    secondPath: logoPath02,
  ),
  GroupItemModel(
    distance: '4촌',
    firstTitle: '이손',
    secondTitle: '증손',
    thirdTitle: '이손녀',
    fourthTitle: '증손녀',
    firstPath: logoPath02,
    secondPath: logoPath02,
  ),
];
