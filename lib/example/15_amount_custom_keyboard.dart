import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigator/components/keyboard/keyboard_layout.dart';
import 'package:navigator/utile/ui.dart';

class KeyboardModel {
  KeyboardModel({
    required this.key,
    required this.controller,
  });

  GlobalKey key;
  TextEditingController controller;
}

class AmountCustomKeyboard extends StatefulWidget {
  static const String routeName = '/navigator/amount_custom_keyboard';

  @override
  AmountCustomKeyboardState createState() => AmountCustomKeyboardState();
}

class AmountCustomKeyboardState extends State<AmountCustomKeyboard> {
  final scrollController = ScrollController();
  final keyboardNotifier = KeyboardModelNotifier(false);
  late List<KeyboardModel> modelList;

  @override
  void initState() {
    super.initState();
    modelList = [
      KeyboardModel(key: GlobalKey(), controller: TextEditingController()),
      KeyboardModel(key: GlobalKey(), controller: TextEditingController()),
      KeyboardModel(key: GlobalKey(), controller: TextEditingController()),
      KeyboardModel(key: GlobalKey(), controller: TextEditingController()),
      KeyboardModel(key: GlobalKey(), controller: TextEditingController()),
      KeyboardModel(key: GlobalKey(), controller: TextEditingController()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardLayout(
      body: renderBody(),
      keyboardVisibleNotifier: keyboardNotifier,
      scrollController: scrollController,
    );
  }

  Widget renderBody() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: 'Amount Custom Keyboard'),
            Expanded(
              child: renderMain(),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderMain() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
            defaultTextField(title: "실제 금액", index: 0),
            SizedBox(height: 20),
            defaultTextField(title: "거래 금액", index: 1),
            SizedBox(height: 20),
            defaultTextField(title: "고정 금액", index: 2),
            SizedBox(height: 20),
            defaultTextField(title: "할인 금액", index: 3),
            SizedBox(height: 20),
            defaultTextField(title: "이익 금액", index: 4),
            SizedBox(height: 20),
            defaultTextField(title: "손해 금액", index: 5),
          ],
        ),
      ),
    );
  }

  Widget defaultTextField({String? title, required int index}) {
    final key = modelList[index].key;
    final controller = modelList[index].controller;

    return TextFormField(
      key: key,
      controller: controller,
      cursorColor: Color(0xFF0d0d0d),
      showCursor: true,
      readOnly: true,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: title,
        errorStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: Icon(Icons.monetization_on_outlined),
      ),
      onTap: () {
        keyboardNotifier.setIsVisible(true, key, controller);
      },
    );
  }
}
