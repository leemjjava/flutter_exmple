import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleNetworkImage extends StatelessWidget {
  final String? path;
  final double imageSize;

  CircleNetworkImage({
    this.path,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return renderImage();
  }

  Widget renderImage() {
    final pathData = path;

    if (pathData == null) return renderNonImage();
    if (!pathData.startsWith('http')) return renderNonImage();
    return renderHttpImage(pathData);
  }

  Widget renderNonImage() {
    return SizedBox(
      height: imageSize,
      width: imageSize,
      child: Image.asset('assets/ufo.png', fit: BoxFit.cover),
    );
  }

  Widget renderHttpImage(String path) {
    return CachedNetworkImage(
      imageUrl: path,
      imageBuilder: (context, imageProvider) => Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(imageSize / 2),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      //placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
