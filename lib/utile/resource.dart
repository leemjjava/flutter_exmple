import 'package:flutter/cupertino.dart';
import 'package:navigator/components/card/credit_card.dart';

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

final bcCard = CardModel(
  title: '비씨카드',
  imagePath: 'assets/card/card_ic_bc.png',
  color: Color(0xFFC83534),
  cardNumber: '비씨카드 Deep Dream Card',
);
final bnkCard = CardModel(
  title: '부산카드',
  imagePath: 'assets/card/card_ic_bnk.png',
  color: Color(0xFF969696),
  cardNumber: '부산카드 Deep Dream Card',
);
final ctCard = CardModel(
  title: '씨티카드',
  imagePath: 'assets/card/card_ic_ct.png',
  color: Color(0xFFE6E6E6),
  cardNumber: '씨티카드 Deep Dream Card',
  textColor: Color(0xFF000000),
);
final dgbCard = CardModel(
  title: '대구카드',
  imagePath: 'assets/card/card_ic_dgb.png',
  color: Color(0xFFCBD6E4),
  cardNumber: '대구카드 Deep Dream Card',
  textColor: Color(0xFF000000),
);
final ehCard = CardModel(
  title: '외환카드',
  imagePath: 'assets/card/card_ic_eh.png',
  color: Color(0xFFC1E1F2),
  cardNumber: '외환카드 Deep Dream Card',
  textColor: Color(0xFF000000),
);
final gjCard = CardModel(
  title: '광주카드',
  imagePath: 'assets/card/card_ic_gj.png',
  color: Color(0xFF002C6A),
  cardNumber: '광주카드 Deep Dream Card',
);
final hdCard = CardModel(
  title: '현대카드',
  imagePath: 'assets/card/card_ic_hd.png',
  color: Color(0xFF259BFE),
  cardNumber: '현대카드 Deep Dream Card',
);
final hnCard = CardModel(
  title: '하나카드',
  imagePath: 'assets/card/card_ic_hn.png',
  color: Color(0xFF008375),
  cardNumber: '신한 카드 Deep Dream Card',
);
final ibkCard = CardModel(
  title: 'IBK카드',
  imagePath: 'assets/card/card_ic_ibk.png',
  color: Color(0xFF748A93),
  cardNumber: 'IBK카드 Deep Dream Card',
);
final jbCard = CardModel(
  title: '전북카드',
  imagePath: 'assets/card/card_ic_jb.png',
  color: Color(0xFF000E5C),
  cardNumber: '전북카드 Deep Dream Card',
);
final kakaoCard = CardModel(
  title: '카카오뱅크 카드',
  imagePath: 'assets/card/card_ic_kakao.png',
  color: Color(0xFF3B1F1E),
  cardNumber: '카카오뱅크 카드 Deep Dream Card',
);
final kbCard = CardModel(
  title: 'KB국민카드',
  imagePath: 'assets/card/card_ic_kb.png',
  color: Color(0xFF776C61),
  cardNumber: 'KB국민카드 Deep Dream Card',
);
final kBankCard = CardModel(
  title: '케이뱅크 카드',
  imagePath: 'assets/card/card_ic_k_bank.png',
  color: Color(0xFFE2E2E2),
  cardNumber: '케이뱅크 카드 Deep Dream Card',
  textColor: Color(0xFF000000),
);
final kdbCard = CardModel(
  title: 'KDB산업 카드',
  imagePath: 'assets/card/card_ic_kdb.png',
  color: Color(0xFF90C2E9),
  cardNumber: 'KDB산업 카드 Deep Dream Card',
);
final lotteCard = CardModel(
  title: '롯데카드',
  imagePath: 'assets/card/card_ic_lotte.png',
  color: Color(0xFF6F10C1),
  cardNumber: '롯데카드 Deep Dream Card',
);
final nhCard = CardModel(
  title: '농협카드',
  imagePath: 'assets/card/card_ic_nh.png',
  color: Color(0xFF04A54C),
  cardNumber: '농협카드 Deep Dream Card',
);
final sbiCard = CardModel(
  title: 'SBI저축 카드',
  imagePath: 'assets/card/card_ic_sbi.png',
  color: Color(0xFFE6E6E6),
  cardNumber: 'SBI저축 Deep Dream Card',
  textColor: Color(0xFF000000),
);
final scCard = CardModel(
  title: 'SC제일 카드',
  imagePath: 'assets/card/card_ic_sc.png',
  color: Color(0xFF004E6D),
  cardNumber: 'SC제일 카드 Deep Dream Card',
);
final shCard = CardModel(
  title: '신한카드',
  imagePath: 'assets/card/card_ic_sh.png',
  color: Color(0xFF214597),
  cardNumber: '신한 카드 Deep Dream Card',
);
final sinhCard = CardModel(
  title: '신협카드',
  imagePath: 'assets/card/card_ic_sinh.png',
  color: Color(0xFF92ABC2),
  cardNumber: '신협카드 Deep Dream Card',
);
final smeCard = CardModel(
  title: '새마을카드',
  imagePath: 'assets/card/card_ic_sme.png',
  color: Color(0xFFE6E6E6),
  cardNumber: '새마을카드 Deep Dream Card',
  textColor: Color(0xFF000000),
);
final ssCard = CardModel(
  title: '삼성카드',
  imagePath: 'assets/card/card_ic_ss.png',
  color: Color(0xFF014DA1),
  cardNumber: '삼성카드 Deep Dream Card',
);
final suhCard = CardModel(
  title: '수협카드',
  imagePath: 'assets/card/card_ic_suh.png',
  color: Color(0xFF8CCBFF),
  cardNumber: '신한 카드 Deep Dream Card',
);
final ucgCard = CardModel(
  title: '우체국카드',
  imagePath: 'assets/card/card_ic_ucg.png',
  color: Color(0xFFB6A17B),
  cardNumber: '우체국카드 Deep Dream Card',
);
final urCard = CardModel(
  title: '우리카드',
  imagePath: 'assets/card/card_ic_ur.png',
  color: Color(0xFF0067AC),
  cardNumber: '우리카드 Deep Dream Card',
);
