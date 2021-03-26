import 'package:flutter/cupertino.dart';

import 'backdrop.dart';
import 'money_input.dart';

class KeyboardLayout extends StatefulWidget {
  KeyboardLayout({
    Key? key,
    required this.body,
    required this.scrollController,
    required this.keyboardVisibleNotifier,
    this.customTec,
  }) : super(key: key);

  final Widget body;
  final KeyboardModelNotifier keyboardVisibleNotifier;
  final ScrollController scrollController;
  final TextEditingController? customTec;

  @override
  KeyboardLayoutState createState() => KeyboardLayoutState();
}

class KeyboardLayoutState extends State<KeyboardLayout> {
  double backdropHeight = 380;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        child: Backdrop(
          frontLayer: renderKeyboard(),
          backLayer: widget.body,
          panelVisible: widget.keyboardVisibleNotifier,
          frontPanelHeight: backdropHeight,
          frontHeaderHeight: 0,
          frontHeaderVisibleClosed: false,
          scrollController: widget.scrollController,
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          widget.keyboardVisibleNotifier.value = false;
        },
      ),
      onWillPop: () async {
        if (widget.keyboardVisibleNotifier.value == false) return true;
        widget.keyboardVisibleNotifier.value = false;
        FocusScope.of(context).requestFocus(new FocusNode());
        return false;
      },
    );
  }

  renderKeyboard() {
    return Column(
      key: ValueKey<int>(1),
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MoneyInput(
          onConfirm: _onKeyboardConfirm,
          height: backdropHeight,
          keyboardVisibleNotifier: widget.keyboardVisibleNotifier,
        ),
      ],
    );
  }

  _onKeyboardConfirm() {
    widget.keyboardVisibleNotifier.value = false;
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}

class KeyboardModelNotifier extends ChangeNotifier {
  GlobalKey? key;
  TextEditingController controller = TextEditingController();
  bool _value;

  KeyboardModelNotifier(
    this._value,
  );

  bool get value => _value;
  set value(bool newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  setIsVisible(bool newValue, GlobalKey key, TextEditingController controller) {
    this.key = key;
    this.controller = controller;
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }
}
