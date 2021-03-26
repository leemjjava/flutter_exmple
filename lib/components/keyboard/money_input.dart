import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navigator/components/button/primary_button.dart';
import 'package:navigator/components/keyboard/number_input.dart';

import 'keyboard_layout.dart';

class MoneyInput extends StatefulWidget {
  final EdgeInsets bodyPadding;
  final GestureTapCallback? onConfirm;
  final double? height;
  final KeyboardModelNotifier keyboardVisibleNotifier;

  MoneyInput({
    this.bodyPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.onConfirm,
    this.height,
    required this.keyboardVisibleNotifier,
  });

  @override
  _MoneyInputState createState() => _MoneyInputState();
}

class _MoneyInputState extends State<MoneyInput> {
  late KeyboardModelNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.keyboardVisibleNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Column(
        children: [
          renderHeaders(),
          Expanded(child: renderBody()),
        ],
      ),
    );
  }

  Widget renderHeaders() {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: renderHeaderChip(
                label: '+1만',
                onTap: () => onAddNumberTap(10000, notifier.controller),
              ),
            ),
            Container(width: 8.0),
            Expanded(
              child: renderHeaderChip(
                label: '+10만',
                onTap: () => onAddNumberTap(100000, notifier.controller),
              ),
            ),
            Container(width: 8.0),
            Expanded(
              child: renderHeaderChip(
                label: '+100만',
                onTap: () => onAddNumberTap(1000000, notifier.controller),
              ),
            ),
            Container(width: 8.0),
            Expanded(
              child: renderHeaderChip(
                label: '+1000만',
                onTap: () => onAddNumberTap(10000000, notifier.controller),
              ),
            ),
            Container(width: 8.0),
            Expanded(
              child: renderHeaderChip(
                label: '전액',
                onTap: () => onAddNumberTap(999999999, notifier.controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderHeaderChip({
    required String label,
    required GestureTapCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Center(child: Text(label)),
          ),
        ),
      ),
    );
  }

  Widget renderBody() {
    return Padding(
      padding: widget.bodyPadding,
      child: Column(
        children: [
          Expanded(
            child: NumberInputKeyboard(
              onTap: (val) => onNumberTap(val, notifier.controller),
              onBackspace: () => onBackspaceTap(notifier.controller),
            ),
          ),
          PrimaryButton(label: '확인', onTap: widget.onConfirm),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  onNumberTap(String number, TextEditingController controller) {
    final text = controller.text;
    final textSelection = controller.selection;

    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      number,
    );

    final finalText = accountString(newText);
    setText(finalText, controller);
  }

  onBackspaceTap(TextEditingController controller) {
    final text = controller.text;
    final textSelection = controller.selection;
    final selectionLength = textSelection.end - textSelection.start;

    if (selectionLength > 0) {
      final newText = text.replaceRange(textSelection.start, textSelection.end, '');
      setText(newText, controller);
      return;
    }

    if (textSelection.start == 0) return;

    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;

    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(newStart, newEnd, '');
    final finalText = accountString(newText);

    setText(finalText, controller);
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  onAddNumberTap(int amount, TextEditingController controller) {
    int curNumber = 0;
    if (controller.text.length > 0) curNumber = int.parse(controller.text);

    final newString = (curNumber + amount).toString();
    final account = accountString(newString);
    setText(account, controller);
  }

  String accountString(String newText) {
    if (newText.isEmpty) return newText;

    final amount = newText.replaceAll(',', '');
    return NumberFormat('#,###').format(int.parse(amount));
  }

  setText(String text, TextEditingController controller) {
    final textSelection = controller.selection;
    final size = text.length;

    controller.text = text;
    controller.selection = textSelection.copyWith(
      baseOffset: size,
      extentOffset: size,
    );
  }
}
