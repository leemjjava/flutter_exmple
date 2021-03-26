import 'package:flutter/material.dart';

import 'keyboard_key.dart';

class NumberInputKeyboard extends StatefulWidget {
  final ValueSetter<String> onTap;
  final GestureTapCallback onBackspace;

  NumberInputKeyboard({
    required this.onTap,
    required this.onBackspace,
  });

  @override
  _NumberInputKeyboardState createState() => _NumberInputKeyboardState();
}

class _NumberInputKeyboardState extends State<NumberInputKeyboard> {
  String text = '';

  final keysList = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  renderSpecialCharacters() {
    return Row(
      children: [
        Expanded(
          child: KeyboardKey(
            label: '00',
            onTap: () {
              widget.onTap.call('00');
            },
          ),
        ),
        Expanded(
          child: KeyboardKey(
            label: '0',
            onTap: () {
              widget.onTap.call('0');
            },
          ),
        ),
        Expanded(
          child: KeyboardKey(
            label: Icon(
              Icons.keyboard_backspace,
            ),
            onTap: () {
              widget.onBackspace();
            },
          ),
        ),
      ],
    );
  }

  renderNumbers() {
    return keysList
        .map(
          (x) => Row(
            children: x
                .map(
                  (y) => Expanded(
                    child: KeyboardKey(
                      label: y,
                      onTap: () {
                        widget.onTap.call(y);
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...renderNumbers(),
        renderSpecialCharacters(),
      ],
    );
  }
}
