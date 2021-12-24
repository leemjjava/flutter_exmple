import "package:flutter/gestures.dart";

typedef MultiTouchGestureRecognizerCallback = void Function(
    bool correctNumberOfTouches, bool isTouchUp);

class MultiTouchGestureRecognizer extends MultiTapGestureRecognizer {
  MultiTouchGestureRecognizerCallback? onMultiTap;
  int numberOfTouches = 0;
  int minNumberOfTouches = 0;

  MultiTouchGestureRecognizer() {
    super.onTapDown = (pointer, details) => this.addTouch(pointer, details);
    super.onTapUp = (pointer, details) => this.removeTouch(pointer, details);
    super.onTapCancel = (pointer) => this.cancelTouch(pointer);
    super.onTap = (pointer) => this.captureDefaultTap(pointer);
  }

  void addTouch(int pointer, TapDownDetails details) {
    this.numberOfTouches++;

    if (this.numberOfTouches == this.minNumberOfTouches) {
      if (onMultiTap != null) this.onMultiTap!(true, false);
    } else if (this.numberOfTouches != 0) {
      if (onMultiTap != null) this.onMultiTap!(false, false);
    }
  }

  void removeTouch(int pointer, TapUpDetails details) {
    this.numberOfTouches = 0;
    if (onMultiTap != null) this.onMultiTap!(false, true);
  }

  void cancelTouch(int pointer) {
    this.numberOfTouches = 0;
  }

  void captureDefaultTap(int pointer) {}

  @override
  set onTapDown(_onTapDown) {}

  @override
  set onTapUp(_onTapUp) {}

  @override
  set onTapCancel(_onTapCancel) {}

  @override
  set onTap(_onTap) {}
}
