import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigator/utile/utile.dart';

class OcrTest extends StatefulWidget {
  static const String routeName = '/examples/orc_text';

  @override
  OcrTestState createState() => OcrTestState();
}

class OcrTestState extends State<OcrTest> {
  String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tesseract Demo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(child: renderMain()),
      ),
    );
  }

  Widget renderMain() {
    return Column(
      children: [
        SizedBox(height: 40),
        text == null ? CircularProgressIndicator() : Container(),
        SizedBox(height: 40),
        Expanded(
          child: SingleChildScrollView(
            child: Text(text ?? '데이터 없음'),
          ),
        ),
        InkWellCS(
          backgroundColor: Colors.blue,
          child: Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            child: Text(
              "촬영",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          onTap: getText,
        ),
        SizedBox(height: 10),
        InkWellCS(
          backgroundColor: Colors.blue,
          child: Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            child: Text(
              "가져오기",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          onTap: getGallery,
        ),
      ],
    );
  }

  getGallery() async {
    this.text = null;
    setState(() {});

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final url = pickedFile.path;

    this.text = await FlutterTesseractOcr.extractText(url, language: "kor+eng", args: {
      "preserve_interword_spaces": "1",
    });

    setState(() {});
  }

  getText() async {
    this.text = null;
    setState(() {});

    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    final url = pickedFile.path;

    this.text = await FlutterTesseractOcr.extractText(url, language: "kor+eng", args: {
      "preserve_interword_spaces": "1",
    });

    setState(() {});
  }
}
