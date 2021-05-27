import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef OnLastSelectItem = void Function(BoxGridModel model);

// ignore: must_be_immutable
class BoxGrid extends StatefulWidget {
  BoxGrid({
    Key? key,
    required this.models,
    this.onLastSelectItem,
    this.radius = 6.0,
    this.rowCount = 3,
    this.imageSize = 42,
    this.fontSize = 12,
  }) : super(key: key);

  final List<BoxGridModel> models;
  OnLastSelectItem? onLastSelectItem;
  double radius, imageSize, fontSize;
  int rowCount;

  @override
  BoxGridState createState() => BoxGridState();
}

class BoxGridState extends State<BoxGrid> {
  BoxGridModel? selectModel;
  late int rowCount;

  @override
  Widget build(BuildContext context) {
    rowCount = widget.rowCount;
    if (rowCount < 2) rowCount = 2;
    if (rowCount > 5) rowCount = 5;

    return renderBtnGrid(widget.models);
  }

  renderBtnGrid(List<BoxGridModel> list) {
    final btnList = list.map((model) => renderBtn(model)).toList();

    List<List<Widget>> allList = [[]];
    for (int i = 0; i < btnList.length; ++i) {
      if (i % rowCount == 0) allList.add([]);

      final btn = btnList[i];
      allList[(allList.length - 1)].add(btn);
    }

    List<Widget> columnList = allList.map((rowList) => renderBtnRow(rowList)).toList();
    return Column(children: columnList);
  }

  Widget renderBtnRow(List<Widget> rowList) {
    if (rowList.length == 0) return Container();

    final padding = _getGridPadding();

    List<Widget> rowItem = [];
    for (int i = 0; i < rowCount; ++i) {
      final row = rowList.length > i ? rowList[i] : Container();
      rowItem.add(Expanded(flex: 15, child: row));
      rowItem.add(SizedBox(width: padding));
    }

    rowItem.removeAt(rowItem.length - 1);

    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Row(children: rowItem),
    );
  }

  renderBtn(BoxGridModel model) {
    final borderColor = model.isSelect ? model.selectBorderColor : model.borderColor;
    final color = model.isSelect ? model.selectColor : model.backgroundColor;

    final textColor = model.isSelect ? model.selectTextColor : model.textColor;

    final imagePath = model.isSelect ? model.selectedImagePath : model.imagePath;

    return InkWell(
      child: AspectRatio(
        aspectRatio: model.ratio,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            border: Border.all(color: borderColor, width: 1),
            color: color,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              renderRowImage(imagePath),
              SizedBox(height: imagePath == null ? 0 : 5),
              Text(
                model.title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: _getGridFontSize(),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _checkModels(model);
        setState(() {});
      },
    );
  }

  renderRowImage(String? path) {
    if (path == null) return Container();
    final size = _getGridImageSize();

    return SvgPicture.asset(
      path,
      width: double.infinity,
      height: size,
      fit: BoxFit.fitHeight,
      alignment: Alignment.center,
    );
  }

  _checkModels(BoxGridModel model) {
    for (BoxGridModel model in widget.models) {
      model.isSelect = false;
    }
    model.isSelect = true;
    _callBackSelectModel(model);
  }

  _callBackSelectModel(BoxGridModel model) {
    final onLastSelectModel = widget.onLastSelectItem;
    if (onLastSelectModel != null) onLastSelectModel(model);
  }

  _getGridImageSize() {
    double width = MediaQuery.of(context).size.width - 32;
    return width * (widget.imageSize / 328);
  }

  _getGridFontSize() {
    double width = MediaQuery.of(context).size.width - 32;
    return width * (widget.fontSize / 328);
  }

  _getGridPadding() {
    final paddingDp = 7;

    double width = MediaQuery.of(context).size.width - 32;
    return width * (paddingDp / 328);
  }
}

class BoxGridModel {
  BoxGridModel({
    required this.title,
    this.imagePath,
    this.selectedImagePath,
    this.textColor = const Color(0xff000000),
    this.selectTextColor = const Color(0xffffffff),
    this.borderColor = const Color(0xffd7d8ee),
    this.selectBorderColor = const Color(0xffa2a4d4),
    this.backgroundColor = const Color(0xffffffff),
    this.selectColor = const Color(0xffdddeed),
    this.ratio = 1,
    this.isSelect = false,
  });

  final String title;
  String? imagePath;
  String? selectedImagePath;
  Color textColor;
  Color selectTextColor;
  Color borderColor;
  Color selectBorderColor;
  Color backgroundColor;
  Color selectColor;
  double ratio;
  bool isSelect;
}
