import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navigator/components/card/bubble_card.dart';
import 'package:navigator/components/topbar/top_bar.dart';

class BubbleListExample extends StatefulWidget {
  static const String routeName = '/examples/bubble_list';

  @override
  _BubbleListExampleState createState() => _BubbleListExampleState();
}

class _BubbleListExampleState extends State<BubbleListExample> {
  bool isBottomShow = false;
  final tec = TextEditingController();
  FocusNode node = FocusNode();
  final List<BubbleModel> list = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; ++i) {
      final content;
      final time = DateFormat.yMMMMd().format(DateTime.now());
      if ((i % 2) == 0)
        content = '테스트';
      else
        content = '안드로이드 기기에 IP 주소를 확인해 주세요. (설정 -> 와이파이 -> 네트워크 세부정보 에서 확인하실 수 있습니다.)';

      final model = BubbleModel(
        content: content,
        date: time,
        isLeft: (i % 2) == 0,
      );

      list.add(model);
    }
  }

  @override
  void dispose() {
    super.dispose();
    node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: SafeArea(child: renderMain()),
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      ),
    );
  }

  Widget renderMain() {
    return Column(
      children: [
        TopBar(title: 'Card List'),
        Expanded(child: renderListView()),
        if (isBottomShow) renderBottomView(),
      ],
    );
  }

  Widget renderListView() {
    final reverseList = list.reversed.toList();

    return ListView.builder(
      reverse: true,
      itemBuilder: (_, index) {
        return renderListItem(reverseList[index]);
      },
      itemCount: reverseList.length,
    );
  }

  Widget renderListItem(BubbleModel model) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: BubbleCard(
          label: model.content,
          subLabel: model.date,
          isLeftPointer: model.isLeft,
        ),
      ),
      onTap: _itemOnTap,
    );
  }

  Widget renderBottomView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFE8E8E8)),
      ),
      child: renderTextFieldRow(),
    );
  }

  Widget renderTextFieldRow() {
    return Row(
      children: [
        Expanded(child: renderTextField()),
        InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: double.infinity,
            child: Icon(Icons.send),
          ),
          onTap: () {
            final text = tec.text;
            if (text.isEmpty) return;
            tec.text = '';
            isBottomShow = false;

            final time = DateFormat.yMMMMd().format(DateTime.now());
            final model = BubbleModel(
              content: text,
              date: time,
              isLeft: (list.length % 2) == 0,
            );
            list.add(model);

            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      controller: tec,
      focusNode: node,
      autofocus: true,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      ),
    );
  }

  _itemOnTap() {
    isBottomShow = !isBottomShow;
    setState(() {});

    if (isBottomShow == false) return;
    final widgetBinding = WidgetsBinding.instance;
    if (widgetBinding == null) return;
    widgetBinding.addPostFrameCallback((_) => node.requestFocus());
  }
}

class BubbleModel {
  String content;
  String date;
  bool isLeft;

  BubbleModel({
    required this.content,
    required this.date,
    this.isLeft = false,
  });
}
