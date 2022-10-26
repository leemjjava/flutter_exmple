import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///TextField 에서 최대 입력 길이를 입력한 경우 CallBack 을 받기 위한 formatter
class MaxFormatter extends TextInputFormatter {
  int maxLength;
  VoidCallback? onMaxLength;

  MaxFormatter({
    this.maxLength = 3500,
    this.onMaxLength,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newTextLength = newValue.text.characters.length;
    if (newTextLength <= maxLength) return newValue;

    onMaxLength?.call();

    // maxLength 까지만 끊어서 String 을 가져온다.
    final iterator = CharacterRange(newValue.text);
    iterator.expandNext(maxLength);
    final newText = iterator.current;

    return TextEditingValue(
      text: newText.toString(),
      selection: getSelection(newValue, newText),
      composing: getComposing(newValue, newText),
    );
  }

  /// 새로운 값의 커서의 위치를 지정하는 TextSelection 객체를 생성하는 함수
  TextSelection getSelection(TextEditingValue newValue, String newText) {
    //커서의 시작값은 newValue 시작값과 newText 길이중에 짧은 것으로 선택한다.
    final baseOffset = math.min(newValue.selection.start, newText.length);
    //커서의 끝값은 newValue 끝값과 newText 길이중에 짧은 것으로 선택한다.
    final extentOffset = math.min(newValue.selection.end, newText.length);

    return newValue.selection.copyWith(
      baseOffset: baseOffset,
      extentOffset: extentOffset,
    );
  }

  /// 입력되고 있는 임시 텍스트의 길이를 지정하는 TextRange 객체를 생성하는 함수
  TextRange getComposing(TextEditingValue newValue, String newText) {
    // 현재 임시 텍스트가 없거나, newText length 가 임시 택스트 시작값과 같거나 작으면
    if (newValue.composing.isCollapsed) return TextRange.empty;
    if (newText.length <= newValue.composing.start) return TextRange.empty;

    return TextRange(
      start: newValue.composing.start, //newValue 의 시작값
      end: math.min(newValue.composing.end, newText.length), // 둘중에 작은 값
    );
  }
}
