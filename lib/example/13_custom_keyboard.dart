import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navigator/utile/utile.dart';

class CustomKeyboard extends StatefulWidget {
  static const String routeName = '/examples/custom_key_board';

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['00', '0', Icon(Icons.keyboard_backspace)],
  ];
  String amount = '';

  @override
  void initState() {
    super.initState();
  }

  onKeyTap(val) {
    if (val == '0' && amount.length == 0) return;
    setState(() => amount = amount + val);
  }

  onBackspacePress() {
    if (amount.length == 0) return;
    setState(() => amount = amount.substring(0, amount.length - 1));
  }

  renderKeyboard() {
    return keys.map((rowList) => Row(children: renderKeyWidgets(rowList))).toList();
  }

  List<Widget> renderKeyWidgets(List<dynamic> rowList) {
    return rowList.map(
      (item) {
        return Expanded(
          child: KeyboardKey(
            label: item,
            value: item,
            onTap: (val) {
              if (val is Widget) return onBackspacePress();

              onKeyTap(val);
            },
          ),
        );
      },
    ).toList();
  }

  renderAmount() {
    String display = '보낼금액';
    String showCapital;
    Widget capitalWidget = Container();

    TextStyle style = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );

    if (this.amount.length > 0) {
      NumberFormat f = NumberFormat('#,###');

      display = f.format(int.parse(amount)) + '원';
      style = style.copyWith(color: Colors.black);

      showCapital = numberToWon(amount);
      capitalWidget = Text(showCapital, style: style.copyWith(fontSize: 20));
    }

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(display, style: style),
            capitalWidget,
          ],
        ),
      ),
    );
  }

  renderConfirmButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.orange),
              onPressed: amount.length > 0 ? () {} : null,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: amount.length > 0 ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            renderAmount(),
            ...renderKeyboard(),
            renderConfirmButton(),
          ],
        ),
      ),
    );
  }
}

class KeyboardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  KeyboardKey({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderLabel() {
    if (widget.label is Widget) return widget.label;

    return Text(
      widget.label,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(widget.value),
      child: AspectRatio(
        aspectRatio: 2, // 넓이 / 높이 = 2
        child: Center(child: renderLabel()),
      ),
    );
  }
}
