import 'package:flutter/material.dart';
import 'package:navigator/components/image_corp/scale_control.dart';

///ResizebleWidget
/// [child] : ResizebleWidget 의 자식
/// [onDrag] : ResizebleWidget 의 위치 이동을 전달하기 위한 함수
/// [parentKey] : 부모 객체의 key 값
// ignore: must_be_immutable
class ResizebleWidget extends StatefulWidget {
  ResizebleWidget({
    required this.child,
    required this.onDrag,
    required this.padding,
    required this.screenSize,
    this.parentKey,
  });

  final Widget child;
  final Function onDrag;
  GlobalKey? parentKey;
  EdgeInsets padding;
  Size screenSize;

  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

class _ResizebleWidgetState extends State<ResizebleWidget> {
  /// Box 높이
  double height = 100.0;

  /// Box 넓이
  double width = 100.0;

  /// 위의 position 값
  double top = 0;

  /// 오른쪽의 position 값
  double left = 0;

  /// 드래그 시작시 Top 터치 위치와 Box 사이의 차이를 저장히가 위한 변수
  double startTopOffset = -1.0;

  /// 드래그 시작시 Left 터치 위치와 Box 사이의 차이를 저장히가 위한 변수
  double startLeftOffset = -1.0;

  /// 비율을 저장하기 위한 변수
  double ratio = -1;

  /// control Size
  final controlSize = 22;

  /// control Padding
  final controlPadding = 3;

  @override
  void initState() {
    super.initState();

    final height = widget.screenSize.height;
    final width = widget.screenSize.width;
    top = (height / 2) - 50;
    left = (width / 2) - 50;

    // 저장된 위치를 반영해서 View 를 그려준다.
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) => setDefaultBox());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._backGroundWidgets(),
        Positioned(top: top, left: left, child: _box()),
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
    final mediaQuery = MediaQuery.of(context);
    final padding = widget.padding.top + widget.padding.bottom;
    final size = mediaQuery.size;

    return [
      Positioned(
        left: left + width,
        top: top,
        right: 0,
        bottom: 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      Positioned(
        left: 0,
        top: top,
        right: size.width - left,
        bottom: size.height - (top + height + padding),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      Positioned(
        left: 0,
        top: top + height,
        right: size.width - (left + width),
        bottom: 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      Positioned(
        left: 0,
        top: 0,
        right: 0,
        bottom: size.height - (top + padding),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    ];
  }

  /// 크롭 영역을 표시하는 Box
  Widget _box() {
    return GestureDetector(
      onPanStart: _onBoxDragStart,
      onPanUpdate: _onBoxDragUpdate,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
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
        top: (top - controlPadding) - controlSize,
        left: (left - controlPadding) - controlSize,
        child: ScaleControl(
          type: ScaleType.topLeft,
          onDrag: (dx, dy) => _onDragScale(dx, dy, ScaleType.topLeft),
        ),
      ),
      Positioned(
        top: (top - controlPadding) - controlSize,
        left: (left + width + controlPadding) - controlSize,
        child: ScaleControl(
          type: ScaleType.topRight,
          onDrag: (dx, dy) => _onDragScale(dx, dy, ScaleType.topRight),
        ),
      ),
      Positioned(
        top: (top + height + controlPadding) - controlSize,
        left: (left - controlPadding) - controlSize,
        child: ScaleControl(
          type: ScaleType.bottomLeft,
          onDrag: (dx, dy) => _onDragScale(dx, dy, ScaleType.bottomLeft),
        ),
      ),
      Positioned(
        top: (top + height + controlPadding) - controlSize,
        left: (left + width + controlPadding) - controlSize,
        child: ScaleControl(
          type: ScaleType.bottomRight,
          onDrag: (dx, dy) => _onDragScale(dx, dy, ScaleType.bottomRight),
        ),
      ),
    ];
  }

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

  Widget _ratioBtn(IconData data, String title, double ratio) {
    final color = this.ratio == ratio ? const Color(0xff637FDF) : Colors.white;

    return InkWell(
      onTap: () => setState(() => _setRatio(ratio)),
      child: Column(
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: Icon(
              data,
              size: 32,
              color: color,
            ),
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void setDefaultBox() {
    final parentContext = widget.parentKey?.currentContext;
    final parentSize = widget.parentKey?.currentContext?.size;
    final basicSize = Size(width, height);
    final basicPos = Offset(left, top);

    if (parentContext == null || parentSize == null) {
      widget.onDrag(basicSize, basicPos);
      return;
    }

    final parentPos = _getPosition(parentContext);
    final mePos = _getPosition(context);
    if (parentPos == null || mePos == null) {
      widget.onDrag(basicSize, basicPos);
      return;
    }

    final parentH = parentSize.height;
    final parentW = parentSize.width;
    final setSize = parentH > parentW ? parentW : parentH;

    if (ratio == -1) {
      width = parentW;
      height = parentH;
    } else if (ratio == 1) {
      width = setSize;
      height = setSize;
    } else if (parentH > parentW) {
      width = setSize;
      height = setSize * ratio;
    } else if (parentH < parentW) {
      height = setSize;
      width = setSize / ratio;
    } else if (ratio < 1) {
      width = setSize;
      height = setSize * ratio;
    } else if (ratio > 1) {
      height = setSize;
      width = setSize / ratio;
    }

    final centerH = parentH + (parentPos.dy * 2);
    final centerW = parentW + (parentPos.dx * 2);

    // 화면 가운데를 기본값으로 세팅
    top = (((centerH / 2) - (height / 2)) - mePos.dy).ceilToDouble();
    left = (((centerW / 2) - (width / 2)) - mePos.dx).ceilToDouble();

    widget.onDrag(Size(width, height), Offset(left, top));
    setState(() {});
  }

  /// box Widget 드래그 시작 callback
  void _onBoxDragStart(DragStartDetails details) {
    // 현재 사용자가 터치한 값과 기존 Box Position 의 차이를 저장한다.
    startTopOffset = details.globalPosition.dx - left;
    startLeftOffset = details.globalPosition.dy - top;
  }

  /// box Widget 드래그 update callBack
  void _onBoxDragUpdate(DragUpdateDetails details) {
    final offset = details.globalPosition;

    // 저장한 터치와 Box 차이값을 빼서 위치를 잡아준다.
    left = offset.dx - startTopOffset;
    top = offset.dy - startLeftOffset;

    final parentContext = widget.parentKey?.currentContext;
    if (parentContext != null) {
      final checkOffset = _parentOffset(
        parentContext,
        left,
        top,
        width,
        height,
      );
      left = checkOffset.dx;
      top = checkOffset.dy;
    }

    setState(() => widget.onDrag(Size(width, height), Offset(left, top)));
  }

  /// ScaleControl 드래그 update callback
  void _onDragScale(double dx, double dy, ScaleType type) {
    var h, w, x, y = 0.0;

    switch (type) {
      case ScaleType.topLeft:
        x = left + dx;
        y = top + dy;

        w = width - dx;
        h = height - dy;
        break;
      case ScaleType.topRight:
        x = left;
        y = top + dy;

        w = width + dx;
        h = height - dy;
        break;
      case ScaleType.bottomLeft:
        x = left + dx;
        y = top;

        w = width - dx;
        h = height + dy;
        break;
      case ScaleType.bottomRight:
        x = left;
        y = top;

        w = width + dx;
        h = height + dy;
        break;
    }

    if (_stopCheckLeftTop(x, y)) return;
    final minWidth = 100.0;
    final minHeight = ratio == -1 ? 100.0 : minWidth * ratio;

    w = w > 100.0 ? w : minWidth;
    h = h > 100.0 ? h : minHeight;

    if (ratio != -1) return _ratioBoxSet(w, h, x, y, type);
    _normalBoxSet(w, h, x, y, type);
  }

  /// 터치 영역이 부모 영역을 벗어나면 box 를 그리지 않음
  bool _stopCheckLeftTop(double x, double y) {
    final parentContext = widget.parentKey?.currentContext;
    if (parentContext == null) return false;

    final limit = _getLimit(parentContext, width, height);
    final position = _getPosition(context);

    if (position == null) return false;

    if (limit.xStart > x) return true;
    if (limit.yStart > y) return true;

    return false;
  }

  /// 비율이 지정되어 있는 경우 위치/크기 처리
  void _ratioBoxSet(double w, double h, double x, double y, ScaleType type) {
    h = w * ratio;
    if (top != y) y = top + (height - h);

    final parentContext = widget.parentKey?.currentContext;
    if (parentContext == null) return _setBoxRectangle(w, h, x, y, type);

    bool isStop = _checkBoxStop(parentContext, Size(w, h), Offset(x, y));
    if (isStop) return;

    final offset = _parentOffset(parentContext, x, y, w, h, type: type);
    final size = _parentSizeCheck(parentContext, w, h, x, y);

    isStop = _checkBoxStop(parentContext, size, offset);
    if (isStop) return;

    _setBoxRectangle(size.width, size.height, offset.dx, offset.dy, type);
  }

  /// 비율이 지정되지 않은 경우 위치/높이 처리
  void _normalBoxSet(double w, double h, double x, double y, ScaleType type) {
    final parentContext = widget.parentKey?.currentContext;
    if (parentContext == null) return _setBoxRectangle(w, h, x, y, type);

    final offset = _parentOffset(parentContext, x, y, w, h, type: type);
    final size = _parentSizeCheck(parentContext, w, h, x, y);

    final isStop = _checkBoxStop(parentContext, size, offset);
    if (isStop) return;

    _setBoxRectangle(size.width, size.height, offset.dx, offset.dy, type);
  }

  /// 비율이 지정된 경우 크기가 더이상 커질 수 없는지? 위치가 더이상 바뀔 수 없는지? 검사하는 함수
  bool _checkBoxStop(
    BuildContext parentContext,
    Size boxSize,
    Offset boxOffset,
  ) {
    final limit = _getLimit(parentContext, boxSize.width, boxSize.height);
    final position = _getPosition(context);

    if (position == null) return false;

    if (limit.xStart > boxOffset.dx) return true;
    if (limit.yStart > boxOffset.dy) return true;

    final checkW = (boxOffset.dx + boxSize.width + position.dx);
    final checkH = (boxOffset.dy + boxSize.height + position.dy);

    if (limit.wLimit.toInt() < checkW.toInt()) return true;
    if (limit.hLimit.toInt() < checkH.toInt()) return true;

    return false;
  }

  /// 최종적으로 크기와 위치를 지정하는 함수
  void _setBoxRectangle(
    double w,
    double h,
    double dx,
    double dy,
    ScaleType type,
  ) {
    final minWidth = 100.0;
    final minHeight = ratio == -1 ? 100.0 : minWidth * ratio;

    if (h > minHeight) top = dy;
    if (w > minWidth) left = dx;

    setTopScale(h, w, type);

    width = w;
    height = h;

    setState(
      () => widget.onDrag(Size(width, height), Offset(left, top)),
    );
  }

  void setTopScale(double h, double w, ScaleType type) {
    if (type == ScaleType.bottomLeft) return;
    if (type == ScaleType.bottomRight) return;

    final minWidth = 100.0;
    final minHeight = ratio == -1 ? 100.0 : minWidth * ratio;

    if (h == minHeight && height != minHeight) top = (top + height) - minHeight;
    if (type != ScaleType.topLeft) return;
    if (w == minWidth && width != minWidth) left = (left + width) - minWidth;
  }

  /// 부모 위젯이 있는 경우 해당 범위를 넘어서지 않도록 dx, dy를 제한하는 함수
  Offset _parentOffset(
    BuildContext parentContext,
    double dx,
    double dy,
    double width,
    double height, {
    ScaleType? type,
  }) {
    if (type == ScaleType.bottomRight) return Offset(dx, dy);
    final limit = _getLimit(parentContext, width, height);

    if (dx < limit.xStart) {
      dx = limit.xStart;
    } else if (dx > limit.xLimit) {
      dx = limit.xLimit;
    }

    if (type == ScaleType.bottomLeft) return Offset(dx, dy);

    if (dy < limit.yStart) {
      dy = limit.yStart;
    } else if (dy > limit.yLimit) {
      dy = limit.yLimit;
    }
    return Offset(dx, dy);
  }

  /// 부모 위젯이 있는 경우 해당 범위를 넘어서지 않도록 Size 를 제한하는 함수
  Size _parentSizeCheck(
    BuildContext parentContext,
    double width,
    double height,
    double updateX,
    double updateY,
  ) {
    final limit = _getLimit(parentContext, width, height);
    final position = _getPosition(context);
    if (position == null) return Size(width, height);

    if (updateX < limit.xStart) width = this.width;
    final checkW = updateX + width + position.dx;
    if (limit.wLimit < checkW) width = this.width;

    if (updateY < limit.yStart) height = this.height;
    final checkH = updateY + height + position.dy;
    if (limit.hLimit < checkH) height = this.height;

    return Size(width, height);
  }

  void _setRatio(double ratio) {
    this.ratio = ratio;
    setDefaultBox();
  }

  /// 배경이 되는 Widget 의 크기와 높이를 가져와서 위치와 크기의 Limit 을 계산하는 함수
  LimitPosition _getLimit(
    BuildContext parentContext,
    double nowWidth,
    double nowHeight,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    final defaultLimit = LimitPosition(
      xStart: 0,
      xLimit: size.width,
      wLimit: size.width,
      yStart: 0,
      yLimit: size.height,
      hLimit: size.height,
    );

    final parentSize = parentContext.size;
    if (parentSize == null) return defaultLimit;

    final parentOffset = _getPosition(parentContext);
    if (parentOffset == null) return defaultLimit;

    // Box dx의 시작점은 배경이 되는 Widget 의 시작점부터 시작할수 있다.
    final xStart = parentOffset.dx;
    // Box dx의 시작점 + 너비는 배경이 되는 Widget 의 시작점 + 너비 만큼 커질수 있다.
    final wLimit = parentOffset.dx + parentSize.width;
    // Box dx의 limit 은 너비 Limit - 자신의 너비 만큼 갈 수 있다.
    final xLimit = wLimit - nowWidth;

    // // resizeWidget 이 현재 SafeArea 에 있기 때문에 top Padding 을 빼줘야 한다.
    // final topPadding = mediaQuery.padding.top;
    // Box dy의 시작점은 배경 Widget 의 dy + topPadding 이다.
    final yStart = parentOffset.dy - widget.padding.top;
    // Box dy의 시작점 + 높이는 배경이 되는 Widget 의 시작점 + 높이 만큼 커질수 있다.
    final hLimit = parentOffset.dy + parentSize.height;
    // Box dy의 limit 은 너비 Limit - 자신의 높이 만큼 갈 수 있다.
    final yLimit = hLimit - (height + widget.padding.top);

    return LimitPosition(
      xStart: xStart.ceilToDouble(),
      xLimit: xLimit.ceilToDouble(),
      wLimit: wLimit.ceilToDouble(),
      yStart: yStart.ceilToDouble(),
      yLimit: yLimit.ceilToDouble(),
      hLimit: hLimit.ceilToDouble(),
    );
  }

  Offset? _getPosition(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position;
  }
}

/// Box 가 이동할 수 있는 곳을 제한하기 위한 함수
/// [xStart] : Box 의 left 가 시작할수 있는 위치 값
/// [xLimit] : Box 의 left 가 최대한 갈수 있는 위치 값
/// [wLimit] : Box 가 현재 위치에서 가장 커질수 있는 너비
/// [yStart] : Box 의 top 이 시작할수 있는 위치 값
/// [yLimit] : Box 의 top 이 최대한 갈수 있는 위치 값
/// [hLimit] : Box 가 현재 위치에서 가장 커질수 있는 높이
class LimitPosition {
  double xStart;
  double xLimit;
  double wLimit;
  double yStart;
  double yLimit;
  double hLimit;

  LimitPosition({
    required this.xStart,
    required this.xLimit,
    required this.wLimit,
    required this.yStart,
    required this.yLimit,
    required this.hLimit,
  });
}
