import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreditCard extends StatelessWidget {
  CardModel model;
  double width;
  double height;

  CreditCard({
    required this.model,
    this.width = 220,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: model.color,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      height: height,
      width: width,
      child: renderCard(),
    );
  }

  Widget renderCard() {
    final textColor = model.textColor;
    final path = model.imagePath;
    final title = model.title;
    final content = model.cardNumber;

    return Column(
      children: [
        renderItemTitle(path, title, textColor),
        Expanded(
          child: renderContentTitle(content ?? '', textColor),
        ),
      ],
    );
  }

  Widget renderItemTitle(
    String path,
    String title,
    Color textColor,
  ) {
    return Row(
      children: [
        Image.asset(path, height: 20),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget renderContentTitle(String content, Color textColor) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        content,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CardModel {
  String title;
  String imagePath;
  Color color;
  Color textColor;
  String? cardNumber;

  CardModel({
    required this.title,
    required this.imagePath,
    required this.color,
    this.textColor = Colors.white,
    this.cardNumber,
  });
}
