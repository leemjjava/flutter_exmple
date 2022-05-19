import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:navigator/components/image_corp/resize_widget.dart';
import 'package:navigator/utile/utile.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as DartImage;

class ImageCropView extends StatefulWidget {
  static const String routeName = '/examples/image_crop_view';
  const ImageCropView({Key? key}) : super(key: key);

  @override
  State<ImageCropView> createState() => _ImageCropViewState();
}

class _ImageCropViewState extends State<ImageCropView> {
  Uint8List? image;
  Uint8List? cropFile;

  DartImage.Image? basicImage; //원본 이미지 Image Object
  DartImage.Image? screenshotImage; //원본 이미지의 Screenshot Image Object

  final imageKey = GlobalKey(); //이미지를 감싸고 있는 SizedBox key
  final backImageKey = GlobalKey(); //이미지 위젯의 RepaintBoundary 위젯 key

  Offset insidePosition = const Offset(0, 0); //이미지 내부에서의 CropBox 위치

  final cropKey = GlobalKey();
  Size cropSize = Size(100, 100);
  DartImage.Image? cropImage;
  bool isLoading = false;

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
              resizebleWidget(),
              Positioned(left: 0, top: 0, right: 0, child: topBar()),
              if (isLoading) Center(child: CircularProgressIndicator()),
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
            onTap: onTapCropBtn,
            child: Container(
              height: 32,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Text(
                cropFile == null ? '자르기' : '취소',
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
    final image = this.cropFile ?? this.image;
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
      key: imageKey,
      height: isWidth ? null : double.infinity,
      width: isWidth ? double.infinity : null,
      child: RepaintBoundary(
        key: backImageKey,
        child: Image.memory(
          image,
          fit: isWidth ? BoxFit.fitWidth : BoxFit.fitHeight,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  Widget resizebleWidget() {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    return RepaintBoundary(
      key: cropKey,
      child: ResizebleWidget(
        parentKey: imageKey,
        onDrag: (size, offset) => insidePositionUpdate(size, offset),
        padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
        screenSize: Size(mediaQuery.size.width, mediaQuery.size.height),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
        ),
      ),
    );
  }

  /// 현재 이미지가 가로 fit 인지 세로 fit 인지 검사하는 함수
  bool isWidthFit() {
    final image = cropImage ?? basicImage;
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

  void insidePositionUpdate(Size size, Offset offset) {
    cropSize = size;
    final imageContext = imageKey.currentContext;
    if (imageContext == null) return;
    final imageOffset = _getPosition(imageContext);
    if (imageOffset == null) return;

    final mediaQuery = MediaQuery.of(context);
    // 화면에 표시된 이미지 Widget left Padding 값 계산
    final xStart = imageOffset.dx;
    // 화면에 표시된 이미지 Widget top padding 계산
    final yStart = imageOffset.dy - mediaQuery.padding.top;

    //실제 이미지의 그려야하는 위치 저장
    insidePosition = Offset(offset.dx - xStart, offset.dy - yStart);
  }

  Offset? _getPosition(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position;
  }

  void onTapCropBtn() async {
    if (cropFile != null) {
      cropImage = null;
      cropFile = null;
      setState(() {});
      return;
    }

    final resultImage = await _cropImage();

    if (resultImage == null) {
      showAlertDialog(context, '이미지 병합 실패');
      return;
    }

    this.cropFile = resultImage;
    setState(() {});
  }

  Future<Uint8List?> _cropImage() async {
    DartImage.Image? backImage = await _getBackImage();
    if (backImage == null) return null;

    final imageSize = imageKey.currentContext?.size;
    if (imageSize == null) return null;

    final cropWidth = cropSize.width;
    final cropHeight = cropSize.height;

    final widthRatio = backImage.width / imageSize.width;
    final heightRatio = backImage.height / imageSize.height;

    final resizeWidth = widthRatio * cropWidth;
    final resizeHeight = heightRatio * cropHeight;

    final resizeX = (backImage.width / imageSize.width) * insidePosition.dx;
    final resizeY = (backImage.height / imageSize.height) * insidePosition.dy;

    final cropImage = DartImage.copyCrop(
      backImage,
      resizeX.toInt(),
      resizeY.toInt(),
      resizeWidth.toInt(),
      resizeHeight.toInt(),
    );

    this.cropImage = cropImage;

    final list = DartImage.encodeJpg(cropImage);
    return Uint8List.fromList(list);
  }

  /// 타임스탬프를 찍기 위한 이미지를 제공하는 함수
  Future<DartImage.Image?> _getBackImage() async {
    DartImage.Image? backImage = basicImage?.clone();
    if (backImage == null) return null;

    final width = MediaQuery.of(context).size.width;
    //화면보다 이미지가 크면 원본 이미지를 리턴한다.
    if (backImage.width > width) return backImage;

    if (screenshotImage == null) screenshotImage = await _setScreenshotImage();
    return screenshotImage?.clone();
  }

  ///이미지가 너무 작은 경우를 대비하여 screenshot Image 를 저장하는 함수
  Future<DartImage.Image?> _setScreenshotImage() async {
    final unit8List = await _getUint8List(backImageKey);
    if (unit8List == null) return null;

    return await compute(DartImage.decodeImage, unit8List);
  }

  /// GlobalKey 를 제공받고 해당 Key 를 가지고 있는 위젯을 이미지로 변환하는 함수
  Future<Uint8List?> _getUint8List(GlobalKey widgetKey) async {
    RenderObject? renderObject = widgetKey.currentContext?.findRenderObject();
    RenderRepaintBoundary boundary = renderObject as RenderRepaintBoundary;

    var image = await boundary.toImage(pixelRatio: 5.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }
}
