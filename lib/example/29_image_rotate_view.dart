import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as DartImage;

class ImageRotateView extends StatefulWidget {
  static const String routeName = '/examples/image_rotate_view';
  const ImageRotateView({Key? key}) : super(key: key);

  @override
  State<ImageRotateView> createState() => _ImageRotateViewState();
}

class _ImageRotateViewState extends State<ImageRotateView> {
  Uint8List? image;
  Uint8List? rotateFile;

  int rotateValue = 0;

  DartImage.Image? basicImage; //원본 이미지 Image Object

  DartImage.Image? rotateImage;

  @override
  void initState() {
    super.initState();
    initImage();
  }

  void initImage() async {
    final bytes = await rootBundle.load('assets/eat_cape_town_sm.jpg');
    final image = bytes.buffer.asUint8List();
    this.image = image;
    basicImage = await compute(DartImage.decodeImage, image);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: imageLayout()),
              Positioned(left: 0, top: 0, right: 0, child: topBar()),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 80,
                  alignment: Alignment.topCenter,
                  child: rotateBtn(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topBar() {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(width: 8),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              height: 32,
              width: 32,
              child: Icon(Icons.close, size: 32, color: Colors.white),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: _imageRotate,
            child: Container(
              height: 32,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Text(
                rotateFile == null ? '적용' : '취소',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.0,
                  color: Colors.white,
                  letterSpacing: -0.0,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget imageLayout() {
    if (rotateFile != null) return rotateImageView();

    final image = this.image;
    if (image == null) return Container();

    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 56 + 16,
        bottom: 80 + 16,
      ),
      child: imageView(image),
    );
  }

  Widget imageView(Uint8List image) {
    //현재 이미지가 가로 fit 인지 세로 fit 인지 check
    final isWidth = isWidthFit();

    return SizedBox(
      height: isWidth ? null : double.infinity,
      width: isWidth ? double.infinity : null,
      child: RotatedBox(
        quarterTurns: rotateValue,
        child: Image.memory(
          image,
          fit: isWidth ? BoxFit.fitWidth : BoxFit.fitHeight,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  Widget rotateImageView() {
    final rotateImage = this.rotateFile;
    if (rotateImage == null) return Container();

    final isWidth = isWidthFit();
    return SizedBox(
      height: isWidth ? null : double.infinity,
      width: isWidth ? double.infinity : null,
      child: Image.memory(
        rotateImage,
        fit: isWidth ? BoxFit.fitWidth : BoxFit.fitHeight,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
      ),
    );
  }

  Widget rotateBtn() {
    return InkWell(
      onTap: _onTapRotationBtn,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 17),
        width: 32,
        height: 32,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Icon(
          Icons.rotate_right_outlined,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  /// 현재 이미지가 가로 fit 인지 세로 fit 인지 검사하는 함수
  bool isWidthFit() {
    final image = rotateImage ?? basicImage;
    if (image == null) return true;

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final screenWidth = mediaQuery.size.width - 32;
    final screenHeight = mediaQuery.size.height - 136 - topPadding - 32;
    final screenRatio = screenHeight / screenWidth;
    final ratio = image.height / image.width;

    if (ratio < screenRatio) return true;

    return false;
  }

  void _onTapRotationBtn() {
    switch (rotateValue) {
      case 0:
        rotateValue = 45;
        break;
      case 45:
        rotateValue = 90;
        break;
      case 90:
        rotateValue = 135;
        break;
      case 135:
        rotateValue = 0;
        break;
    }
    setState(() {});
  }

  Future<void> _imageRotate() async {
    if (rotateFile != null) {
      rotateFile = null;
      rotateValue = 0;
      setState(() {});
      return;
    }

    final uint8List = image;
    if (uint8List == null) return;

    List<int> imageBytes = uint8List.toList();
    final originalImage = DartImage.decodeImage(imageBytes);
    if (originalImage == null) return;

    final fixedImage = DartImage.copyRotate(originalImage, (rotateValue * 2));
    final fixedImageList = DartImage.encodeJpg(fixedImage);
    rotateFile = Uint8List.fromList(fixedImageList);
    rotateValue = 0;
    setState(() {});
  }
}
