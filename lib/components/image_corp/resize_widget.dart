import 'package:flutter/material.dart';
import 'package:navigator/components/image_corp/scale_control.dart';

///ResizebleWidget
/// [child] : ResizebleWidget 의 자식
/// [onDrag] : ResizebleWidget 의 위치 이동을 전달하기 위한 함수
/// [limitBoxKey] : 이동 한계 Box Widget 의 key 값
// ignore: must_be_immutable
class ResizebleWidget extends StatefulWidget {
  ResizebleWidget({
    required this.child,
    required this.onDrag,
    required this.screenSize,
    this.limitBoxKey,
  });

  final Widget child;
  final ValueChanged<Rect> onDrag;
  Size screenSize;
  GlobalKey? limitBoxKey;

  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

class _ResizebleWidgetState extends State<ResizebleWidget> {
  /// 이동하는 Box Rect
  Rect boxRect = Rect.fromLTWH(0, 0, 100, 100);

  /// ResizeWidget 의 박스
  Rect meRect = const Rect.fromLTWH(0, 0, 0, 0);

  /// 드래그 시작시 Top 터치 위치와 Box 사이의 차이를 저장히가 위한 변수
  double startTopOffset = -1.0;

  /// 드래그 시작시 Left 터치 위치와 Box 사이의 차이를 저장히가 위한 변수
  double startLeftOffset = -1.0;

  /// 비율을 저장하기 위한 변수
  double ratio = -1;

  /// 위젯에서 사용하는 공통 double 값
  final controlSize = 22, controlPadding = 3, minSize = 100;

  @override
  void initState() {
    super.initState();

    final height = widget.screenSize.height;
    final width = widget.screenSize.width;

    // 화면 가운데를 기본값으로 세팅
    final defaultTop = (height / 2) - 50;
    final defaultLeft = (width / 2) - 50;
    _setBoxRect(top: defaultTop, left: defaultLeft);

    WidgetsBinding.instance.addPostFrameCallback(_initCallBack);
  }

  void _initCallBack(Duration timeStamp) {
    ///meRect 값을 초기화 한다.
    meRect = _getRect(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._backGroundWidgets(),
        Positioned(top: boxRect.top, left: boxRect.left, child: _box()),
        ..._controlWidgets(),
        Positioned(
          left: 0,
          right: 0,
          bottom: 26,
          child: _bottomRow(),
        ),
      ],
    );
  }

  /// 뒷 배경을 검정색으로 보이게 하기 위한 WidgetList
  List<Widget> _backGroundWidgets() {
    final bottomPos = meRect.height - boxRect.bottomLeft.dy;

    return [
      Positioned(
        left: 0,
        top: 0,
        right: 0,
        bottom: meRect.height - boxRect.top,
        child: grayView(),
      ), // Top to Top
      Positioned(
        left: 0,
        top: boxRect.bottomLeft.dy,
        right: 0,
        bottom: 0,
        child: grayView(),
      ), // Bottom to Bottom
      Positioned(
        left: 0,
        top: boxRect.top,
        right: meRect.width - boxRect.left,
        bottom: bottomPos,
        child: grayView(),
      ), //left to left
      Positioned(
        left: boxRect.topRight.dx,
        top: boxRect.top,
        right: 0,
        bottom: bottomPos,
        child: grayView(),
      ), // Right to Right
    ];
  }

  Widget grayView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.5),
    );
  }

  /// 크롭 영역을 표시하는 Box
  Widget _box() {
    return GestureDetector(
      onPanStart: _onBoxDragStart,
      onPanUpdate: _onBoxDragUpdate,
      child: Container(
        height: boxRect.height,
        width: boxRect.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffffffff),
            width: 3,
          ),
        ),
        child: widget.child,
      ),
    );
  }

  /// Box 크기를 조절하기 위한 control Widget List
  List<Widget> _controlWidgets() {
    return [
      Positioned(
        top: (boxRect.top - controlPadding) - controlSize,
        left: (boxRect.left - controlPadding) - controlSize,
        child: ScaleControl(type: ScaleType.topLeft, onDrag: _onDragScale),
      ),
      Positioned(
        top: (boxRect.top - controlPadding) - controlSize,
        left: (boxRect.left + boxRect.width + controlPadding) - controlSize,
        child: ScaleControl(type: ScaleType.topRight, onDrag: _onDragScale),
      ),
      Positioned(
        top: (boxRect.top + boxRect.height + controlPadding) - controlSize,
        left: (boxRect.left - controlPadding) - controlSize,
        child: ScaleControl(type: ScaleType.bottomLeft, onDrag: _onDragScale),
      ),
      Positioned(
        top: (boxRect.top + boxRect.height + controlPadding) - controlSize,
        left: (boxRect.left + boxRect.width + controlPadding) - controlSize,
        child: ScaleControl(type: ScaleType.bottomRight, onDrag: _onDragScale),
      ),
    ];
  }

  ///비율을 선택하는 버튼 Row
  Widget _bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        _ratioBtn(Icons.crop, '자유롭게', -1),
        SizedBox(width: 32),
        _ratioBtn(Icons.crop_din, '1:1', 1),
        SizedBox(width: 32),
        _ratioBtn(Icons.crop_5_4, '5:4', 5 / 4),
        SizedBox(width: 32),
        _ratioBtn(Icons.crop_3_2, '3:2', 3 / 2),
        const Spacer(),
      ],
    );
  }

  /// 비율 선택 버튼 위젯
  Widget _ratioBtn(IconData data, String title, double ratio) {
    final color = this.ratio == ratio ? const Color(0xff637FDF) : Colors.white;

    return InkWell(
      onTap: () => _setRatio(ratio),
      child: Column(
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: Icon(data, size: 32, color: color),
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }

  /// 사용자가 선택한 비율의 최대 크기로 박스를 지정한다.
  void _setMaxSizeBox() {
    final limitKey = widget.limitBoxKey;
    if (limitKey == null) return widget.onDrag(boxRect);

    final limitContext = widget.limitBoxKey?.currentContext;
    final limitRect = _getRect(limitContext);

    final parentH = (limitRect.height - 2);
    final parentW = (limitRect.width - 2);
    final setSize = parentH > parentW ? parentW : parentH;
    final parentRatio = parentH / parentW;

    double width = boxRect.width;
    double height = boxRect.height;

    if (ratio == -1) {
      width = parentW;
      height = parentH;
    } else if (ratio == 1) {
      width = setSize;
      height = setSize;
    } else if (parentRatio > ratio) {
      width = parentW;
      height = width * ratio;
    } else if (parentRatio < ratio) {
      height = parentH;
      width = height / ratio;
    }

    final centerH = parentH + (limitRect.top * 2);
    final centerW = parentW + (limitRect.left * 2);

    // 화면 가운데를 기본값으로 세팅
    final top = (((centerH / 2) - (height / 2)) - meRect.top).ceilToDouble();
    final left = (((centerW / 2) - (width / 2)) - meRect.left).ceilToDouble();

    _setBoxRect(left: left, top: top, width: width, height: height);
    widget.onDrag(boxRect);
    setState(() {});
  }

  /// box Widget 드래그 시작 callback
  void _onBoxDragStart(DragStartDetails details) {
    // 현재 사용자가 터치한 값과 기존 Box Position 의 차이를 저장한다.
    startTopOffset = details.globalPosition.dx - boxRect.left;
    startLeftOffset = details.globalPosition.dy - boxRect.top;
  }

  /// box Widget 드래그 update callBack
  void _onBoxDragUpdate(DragUpdateDetails details) {
    final offset = details.globalPosition;

    // 저장한 터치와 Box 차이값을 빼서 위치를 잡아준다.
    double left = offset.dx - startTopOffset;
    double top = offset.dy - startLeftOffset;

    final limitKey = widget.limitBoxKey;
    if (limitKey != null) {
      Rect rect = Rect.fromLTWH(left, top, boxRect.width, boxRect.height);
      rect = _parentOffset(rect);
      left = rect.left;
      top = rect.top;
    }

    _setBoxRect(left: left, top: top);
    setState(() => widget.onDrag(boxRect));
  }

  /// ScaleControl 드래그 update callback
  void _onDragScale(double dx, double dy, ScaleType type) {
    Rect rect = _nowBoxRect(dx, dy, type);

    if (_stopCheckLeftTop(rect.left, rect.top)) return;

    rect = _rectSetMin(rect);
    rect = _rectSetRatio(rect);

    final limitBoxKey = widget.limitBoxKey;
    if (limitBoxKey == null) return _setBox(rect, type);

    if (_checkBoxStop(rect)) return;

    rect = _parentOffset(rect, type: type);
    rect = _parentSizeCheck(rect);

    if (_checkBoxStop(rect)) return;

    _setBox(rect, type);
  }

  /// ScaleType 에 따라 Rect 를 생성하는 함수
  Rect _nowBoxRect(double dx, double dy, ScaleType type) {
    final left = boxRect.left;
    final top = boxRect.top;
    final width = boxRect.width;
    final height = boxRect.height;

    switch (type) {
      case ScaleType.topLeft:
        return Rect.fromLTWH(left + dx, top + dy, width - dx, height - dy);
      case ScaleType.topRight:
        return Rect.fromLTWH(left, top + dy, width + dx, height - dy);
      case ScaleType.bottomLeft:
        return Rect.fromLTWH(left + dx, top, width - dx, height + dy);
      case ScaleType.bottomRight:
        return Rect.fromLTWH(left, top, width + dx, height + dy);
    }
  }

  /// 터치 영역이 부모 영역을 벗어 나는지 검사하는 함수
  bool _stopCheckLeftTop(double left, double top) {
    final limitKey = widget.limitBoxKey;
    if (limitKey == null) return false;

    final limit = _getLimit(boxRect.size);

    if (limit.leftStart > left) return true;
    if (limit.topStart > top) return true;

    return false;
  }

  /// 그려질 Box 가 최초 크기보다 작다면 최소 크기로 설정하는 함수
  Rect _rectSetMin(Rect rect) {
    final minWidth = minSize;
    final minHeight = ratio == -1 ? minSize : minWidth * ratio;

    double w = rect.width > minSize ? rect.width : minWidth.toDouble();
    double h = rect.height > minSize ? rect.height : minHeight.toDouble();

    return Rect.fromLTWH(rect.left, rect.top, w, h);
  }

  /// 그려질 박스의 크기를 비율에 맞게 설정하는 함수
  Rect _rectSetRatio(Rect rect) {
    if (ratio == -1) return rect;

    final ratioHeight = rect.width * ratio;
    double ratioTop = rect.top;
    if (boxRect.top != ratioTop) {
      ratioTop = boxRect.top + (boxRect.height - ratioHeight);
    }

    return Rect.fromLTWH(rect.left, ratioTop, rect.width, ratioHeight);
  }

  /// 비율이 지정된 경우 크기가 더이상 커질 수 없는지? 위치가 더이상 바뀔 수 없는지? 검사하는 함수
  bool _checkBoxStop(Rect rect) {
    final limit = _getLimit(rect.size);

    if (limit.leftStart > rect.left) return true;
    if (limit.topStart > rect.top) return true;

    final checkW = (rect.left + rect.width + meRect.left);
    final checkH = (rect.top + rect.height + meRect.top);

    if (limit.maxDx.toInt() < checkW.toInt()) return true;
    if (limit.maxDy.toInt() < checkH.toInt()) return true;

    return false;
  }

  /// 부모 위젯이 있는 경우 해당 범위를 넘어서지 않도록 left, top 을 제한하는 함수
  Rect _parentOffset(Rect rect, {ScaleType? type}) {
    if (type == ScaleType.bottomRight) return rect;
    final limit = _getLimit(rect.size);

    double newLeft = rect.left;
    double newTop = rect.top;

    if (newLeft < limit.leftStart) {
      newLeft = limit.leftStart;
    } else if (newLeft > limit.leftLimit) {
      newLeft = limit.leftLimit;
    }

    if (type == ScaleType.bottomLeft) {
      return Rect.fromLTWH(newLeft, newTop, rect.width, rect.height);
    }

    if (newTop < limit.topStart) {
      newTop = limit.topStart;
    } else if (newTop > limit.topLimit) {
      newTop = limit.topLimit;
    }

    return Rect.fromLTWH(newLeft, newTop, rect.width, rect.height);
  }

  /// 부모 위젯이 있는 경우 해당 범위를 넘어서지 않도록 Size 를 제한하는 함수
  Rect _parentSizeCheck(Rect rect) {
    double width = rect.width;
    double height = rect.height;

    final limit = _getLimit(rect.size);

    if (rect.left < limit.leftStart) width = boxRect.width;
    final checkW = rect.left + width + meRect.left;
    if (limit.maxDx < checkW) width = boxRect.width;

    if (rect.top < limit.topStart) height = boxRect.height;
    final checkH = rect.top + height + meRect.top;
    if (limit.maxDy < checkH) height = boxRect.height;

    return Rect.fromLTWH(rect.left, rect.top, width, height);
  }

  /// 최종적으로 크기와 위치를 지정하는 함수
  void _setBox(Rect rect, ScaleType type) {
    final minWidth = minSize;
    final minHeight = ratio == -1 ? minSize : minWidth * ratio;

    double left = boxRect.left;
    double top = boxRect.top;

    if (rect.width > minWidth) left = rect.left;
    if (rect.height > minHeight) top = rect.top;

    rect = Rect.fromLTWH(left, top, rect.width, rect.height);
    final pos = _setTopScale(rect, type);

    _setBoxRect(
      left: pos.dx,
      top: pos.dy,
      width: rect.width,
      height: rect.height,
    );

    setState(() => widget.onDrag(boxRect));
  }

  /// top 이나 left 가 minSize 와 만나는 경우 처리를 위한 함수
  Offset _setTopScale(Rect rect, ScaleType type) {
    // bottomRight 경우에는 top left 가 변화가 없기 때문에 아무 처리도 하지 않는다.
    if (type == ScaleType.bottomRight) {
      return rect.topLeft;
    }
    if (type == ScaleType.topRight) {
      return Offset(rect.left, _checkSetMinTop(rect));
    }
    if (type == ScaleType.bottomLeft) {
      return Offset(_checkSetMinLeft(rect), rect.top);
    }
    return Offset(_checkSetMinLeft(rect), _checkSetMinTop(rect));
  }

  double _checkSetMinTop(Rect rect) {
    final minWidth = minSize;
    final minHeight = ratio == -1 ? minSize : minWidth * ratio;

    final preHeightMin = boxRect.height == minHeight;
    final nowHeightMin = rect.height == minHeight;
    final isHeightMin = preHeightMin == false && nowHeightMin == true;
    if (isHeightMin == false) return rect.top;

    return (rect.top + boxRect.height) - minHeight;
  }

  double _checkSetMinLeft(Rect rect) {
    final minWidth = minSize;

    final preWidthMin = boxRect.width == minWidth;
    final nowWidthMin = rect.width == minWidth;
    final isWidthMin = preWidthMin == false && nowWidthMin == true;
    if (isWidthMin == false) return rect.left;

    return (rect.left + boxRect.width) - minWidth;
  }

  void _setRatio(double ratio) {
    this.ratio = ratio;
    _setMaxSizeBox();
  }

  /// 배경이 되는 Widget 의 크기와 높이를 가져와서 위치와 크기의 Limit 을 계산하는 함수
  LimitPosition _getLimit(Size size) {
    final limitContext = widget.limitBoxKey?.currentContext;
    final limitRect = _getRect(limitContext);

    // Box dx의 시작점은 배경이 되는 Widget 의 left - ResizebleWidget.left 이다.
    final leftStart = limitRect.left - meRect.left;
    // Box 가 갈수 있는 최대 X 좌표값
    final maxDx = limitRect.bottomRight.dx;
    // Box dx의 limit 은 너비 Limit - (자신의 left + 자신의 너비) 만큼 갈 수 있다.
    final leftLimit = maxDx - (meRect.left + size.width);

    // Box dy의 시작점은 배경 Widget 의 top - ResizebleWidget.top 이다.
    final topStart = limitRect.top - meRect.top;
    // Box 가 갈수 있는 최대 Y 좌표값
    final maxDy = limitRect.bottomRight.dy;
    // Box dy의 limit 은 너비 Limit - (자신의 top + 자신의 높이) 만큼 갈 수 있다.
    final topLimit = maxDy - (meRect.top + size.height);

    return LimitPosition(
      leftStart: leftStart.ceilToDouble(),
      leftLimit: leftLimit.ceilToDouble(),
      maxDx: maxDx.ceilToDouble(),
      topStart: topStart.ceilToDouble(),
      topLimit: topLimit.ceilToDouble(),
      maxDy: maxDy.ceilToDouble(),
    );
  }

  Rect _getRect(BuildContext? context) {
    final pos = _getPosition(context) ?? Offset.zero;
    final size = context?.size ?? widget.screenSize;

    return Rect.fromLTWH(pos.dx, pos.dy, size.width, size.height);
  }

  /// BuildContext 를 이용해서 현재 위치값을 가져오는 함수
  Offset? _getPosition(BuildContext? context) {
    if (context == null) return null;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position;
  }

  void _setBoxRect({double? left, double? top, double? width, double? height}) {
    boxRect = Rect.fromLTWH(
      left ?? boxRect.left,
      top ?? boxRect.top,
      width ?? boxRect.width,
      height ?? boxRect.height,
    );
  }
}

/// Box 가 이동할 수 있는 곳을 제한하기 위한 함수
/// [leftStart] : Box 의 left 가 시작할수 있는 위치 값
/// [leftLimit] : Box 의 left 가 최대한 갈수 있는 위치 값
/// [maxDx] : Box 가 현재 위치에서 가장 커질수 있는 너비
/// [topStart] : Box 의 top 이 시작할수 있는 위치 값
/// [topLimit] : Box 의 top 이 최대한 갈수 있는 위치 값
/// [maxDy] : Box 가 현재 위치에서 가장 커질수 있는 높이
class LimitPosition {
  double leftStart;
  double leftLimit;
  double maxDx;
  double topStart;
  double topLimit;
  double maxDy;

  LimitPosition({
    required this.leftStart,
    required this.leftLimit,
    required this.maxDx,
    required this.topStart,
    required this.topLimit,
    required this.maxDy,
  });
}
