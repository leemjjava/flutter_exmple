import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:navigator/http/models/select_entity.dart';
import 'package:photo_manager/photo_manager.dart';

const Color grayE4 = Color(0xFFE4E4E4);
const Color blue6601 = Color(0x66014F90);
const Color whiteFF = Color(0xFFFFFFFF);

class AssetImageCS extends StatelessWidget {
  final SelectEntity selectEntity;
  final double width;
  final double height;
  final BoxFit? boxFit;
  final int minusCount;

  const AssetImageCS({
    Key? key,
    required this.selectEntity,
    required this.width,
    required this.height,
    this.boxFit,
    this.minusCount = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectEntity.uint8List != null) {
      return _buildContainer(
        child: Image.memory(
          selectEntity.uint8List!,
          width: width,
          height: height,
          fit: boxFit,
        ),
      );
    }

    return FutureBuilder<Uint8List?>(
      builder: (BuildContext context, snapshot) {
        final data = snapshot.data;
        if (data == null) return _buildContainer();

        if (snapshot.hasData) {
          selectEntity.uint8List = data;

          return _buildContainer(
            child: Image.memory(
              data,
              width: width,
              height: height,
              fit: boxFit,
            ),
          );
        } else {
          return _buildContainer();
        }
      },
      future: selectEntity.entity.thumbDataWithSize(
        width.toInt(),
        height.toInt(),
      ),
    );
  }

  Widget _buildContainer({Widget? child}) {
    if (child == null) child = Container();
    bool isVideo = selectEntity.entity.type == AssetType.video;
    bool isSelect = selectEntity.isSelect;

    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          child,
          isVideo == true ? videoIcon() : Container(),
          isSelect == true ? selectWidget() : Container(),
          isSelect == true ? countWidget() : Container(),
        ],
      ),
    );
  }

  Widget videoIcon() {
    return Center(
      child: Icon(
        Icons.play_circle_filled,
        color: grayE4,
      ),
    );
  }

  Widget selectWidget() {
    return Container(
      color: blue6601,
      child: Center(
        child: Icon(Icons.check, color: grayE4),
      ),
    );
  }

  Widget countWidget() {
    if (minusCount != -1 && selectEntity.selectCount > minusCount) {
      --selectEntity.selectCount;
    }

    return Container(
      padding: EdgeInsets.all(5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "${selectEntity.selectCount}",
          style: TextStyle(
            color: whiteFF,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
