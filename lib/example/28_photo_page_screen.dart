import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:navigator/utile/MultiTouchGestureRecognizer.dart';
import 'package:navigator/utile/resource.dart';

// ignore: must_be_immutable
class PhotoPageScreen extends StatefulWidget {
  static const String routeName = '/examples/photo_page_screen';
  int initIndex;
  PhotoPageScreen({this.initIndex = 0});

  @override
  _PhotoPageScreenState createState() => _PhotoPageScreenState();
}

class _PhotoPageScreenState extends State<PhotoPageScreen> {
  int selectIndex = 0;
  bool isBarShow = true;
  late double width;

  late PageController pageController;
  List<TransformationController> controllerList = [];
  ScrollPhysics scrollPhysics = CustomPageViewScrollPhysics();

  List<ImageItem> imageList = [
    ImageItem(imagePath: pageImage01),
    ImageItem(imagePath: pageImage02),
    ImageItem(imagePath: pageImage03),
    ImageItem(imagePath: pageImage04),
    ImageItem(imagePath: pageImage05),
    ImageItem(imagePath: pageImage06),
    ImageItem(imagePath: pageImage07),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initIndex);
    selectIndex = widget.initIndex;

    for (int i = 0; i < imageList.length; ++i) {
      controllerList.add(TransformationController());
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(child: renderMain()),
      ),
    );
  }

  Widget renderMain() {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          physics: scrollPhysics,
          itemCount: imageList.length,
          itemBuilder: (context, index) => renderImageNetwork(index),
          onPageChanged: _onPageChange,
        ),
        renderTopBar(),
      ],
    );
  }

  Widget renderImageNetwork(int index) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5,
      transformationController: controllerList[index],
      onInteractionUpdate: (details) => _onInteractionUpdate(details, index),
      onInteractionEnd: (details) => _onInteractionEnd(details, index),
      child: renderInteractiveChild(index),
    );
  }

  Widget renderInteractiveChild(int index) {
    final item = imageList[index];

    final recognizer = GestureRecognizerFactoryWithHandlers<MultiTouchGestureRecognizer>(
      () => MultiTouchGestureRecognizer(),
      (instance) {
        instance.minNumberOfTouches = 2;
        instance.onMultiTap = this.onTap;
      },
    );

    return RawGestureDetector(
      gestures: {MultiTouchGestureRecognizer: recognizer},
      child: Container(width: width, child: renderImage(item)),
    );
  }

  Widget renderImage(ImageItem item) {
    final imagePath = item.imagePath;
    final localImage = item.localImage;

    if (localImage != null) return renderImageMemory(localImage);
    if (imagePath == null) return Container();
    return renderHttpImage(imagePath);
  }

  Widget renderImageMemory(Uint8List file) {
    return Image.memory(
      file,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }

  Widget renderHttpImage(String path) {
    return CachedNetworkImage(
      imageUrl: path,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        );
      },
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget renderTopBar() {
    if (isBarShow == false) return Container();

    return Container(
      height: 104,
      padding: EdgeInsets.only(right: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.0),
          ],
        ),
      ),
      child: renderBarBtnRow(),
    );
  }

  Widget renderBarBtnRow() {
    final all = imageList.length;

    return Row(
      children: [
        SizedBox(width: 16),
        Text(
          all == 1 ? "" : "${selectIndex + 1}/$all",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
            height: 1,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Spacer(),
        InkWell(
          child: Icon(Icons.close, size: 30, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _onPageChange(int index) {
    controllerList[index].value = Matrix4.identity();
    selectIndex = index;
    setState(() {});
  }

  void _onInteractionUpdate(ScaleUpdateDetails details, int index) {
    final controller = controllerList[index];

    final scale = controller.value.getMaxScaleOnAxis();
    final maxWidth = (width * scale) - width;

    final row0 = controller.value.row0;
    final verticalMax = row0[3].abs();

    final isLeftScroll = verticalMax < 10;
    final isRightScroll = verticalMax > (maxWidth - 10);

    if (isLeftScroll || isRightScroll) {
      if (isLeftScroll && index == 0) return;
      if (isRightScroll && index == (controllerList.length - 1)) return;
      if (scrollPhysics is CustomPageViewScrollPhysics) return;

      scrollPhysics = CustomPageViewScrollPhysics();
      setState(() {});
    } else {
      if (scrollPhysics is NeverScrollableScrollPhysics) return;

      scrollPhysics = NeverScrollableScrollPhysics();
      setState(() {});
    }
  }

  void _onInteractionEnd(ScaleEndDetails details, int index) {
    final controller = controllerList[index];
    double correctScaleValue = controller.value.getMaxScaleOnAxis();

    if (correctScaleValue == 1.0) {
      if (scrollPhysics is CustomPageViewScrollPhysics) return;
      scrollPhysics = CustomPageViewScrollPhysics();
      setState(() {});
    }
  }

  void onTap(bool isMulti, bool isTouchUp) {
    if (isMulti == true) {
      scrollPhysics = NeverScrollableScrollPhysics();
      setState(() {});
    } else {
      scrollPhysics = CustomPageViewScrollPhysics();
      if (isTouchUp == true) isBarShow = !isBarShow;
      setState(() {});
    }
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 100, stiffness: 100, damping: 0.8);
}

class ImageItem {
  Uint8List? localImage;
  String? imagePath;

  ImageItem({
    this.localImage,
    this.imagePath,
  });
}
