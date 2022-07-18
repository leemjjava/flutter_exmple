import 'package:flutter/material.dart';
import 'package:navigator/components/card/credit_card.dart';
import 'package:navigator/utile/resource.dart';
import 'package:navigator/utile/ui.dart';

class CardList extends StatefulWidget {
  static const String routeName = '/examples/card_list';

  @override
  CardListState createState() => CardListState();
}

class CardListState extends State<CardList> {
  FixedExtentScrollController _scrollController = FixedExtentScrollController();
  int nowIndex = 0;
  final List<CardModel> list = [];

  @override
  void initState() {
    super.initState();
    list.addAll([bcCard, ctCard, dgbCard, ehCard]);
    list.addAll([gjCard, hdCard, hnCard, ibkCard, jbCard]);
    list.addAll([kakaoCard, kbCard, kBankCard, kdbCard, lotteCard]);
    list.addAll([nhCard, sbiCard, scCard, shCard, sinhCard]);
    list.addAll([smeCard, ssCard, suhCard, ucgCard, urCard]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: 'Card List'),
            SizedBox(
              width: double.infinity,
              height: 130,
              child: renderListView(220),
            ),
            Expanded(
              child: Center(
                child: CreditCard(
                  width: 320,
                  height: 200,
                  model: list[nowIndex],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderListView(double itemExtent) {
    int index = 0;

    return NotificationListener<ScrollNotification>(
      child: RotatedBox(
        quarterTurns: 3,
        child: ListWheelScrollView(
          controller: _scrollController,
          physics: FixedExtentScrollPhysics(),
          itemExtent: itemExtent,
          children: list.map((item) => renderListItem(item, index++)).toList(),
          onSelectedItemChanged: (int index) => nowIndex = index,
          offAxisFraction: 0,
          diameterRatio: 50,
        ),
      ),
      onNotification: _onScrollNotification,
    );
  }

  Widget renderListItem(CardModel model, int index) {
    return RotatedBox(
      quarterTurns: 1,
      child: InkWell(
        child: CreditCard(model: model),
        onTap: () => _scrollAnimation(index),
      ),
    );
  }

  _scrollAnimation(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateToItem(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );

      setState(() {});
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification == false) return true;
    _scrollAnimation(nowIndex);
    return true;
  }
}
