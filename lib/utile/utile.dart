import 'package:flutter/material.dart';

final String host = "https://ggvpuf5kd9.execute-api.ap-northeast-2.amazonaws.com";
final String authHost = "https://23fay7fefe.execute-api.ap-northeast-2.amazonaws.com";

// ProgressDialog getProgressDialog(BuildContext context, String title) {
//   ProgressDialog pr = new ProgressDialog(context,
//       type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
//   pr.style(
//     progress: 50.0,
//     message: title,
//     progressWidget:
//         Container(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
//     maxProgress: 100.0,
//     progressTextStyle:
//         TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//     messageTextStyle:
//         TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w600),
//   );
//   return pr;
// }

showAlertDialog(BuildContext context, String? message) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('알림'),
        content: Text(message ?? 'NO MESSAGE'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, "OK");
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
          ),
        ],
      );
    },
  );
}

void printAnimation(AnimationStatus status) {
  switch (status) {
    case AnimationStatus.forward:
      print('forward');
      break;
    case AnimationStatus.reverse:
      print('reverse');
      break;
    case AnimationStatus.completed:
      print('completed');
      break;
    case AnimationStatus.dismissed:
      print('dismissed');
      break;
    default:
  }
}

// ignore: must_be_immutable
class InkWellCS extends StatelessWidget {
  InkWellCS({
    Key? key,
    this.child,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.splashColor,
  }) : super(key: key);

  final Widget? child;
  final GestureTapCallback? onTap;
  final Color? splashColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        splashColor: splashColor,
        child: child,
        onTap: onTap,
      ),
    );
  }
}

Route createSlideUpRoute({
  required Widget widget,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

String numberToWon(String number) {
  final han1 = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"];
  final han2 = ["", "십", "백", "천"];
  final han3 = ["", "만", "억", "조", "경"];
  StringBuffer stringBuffer = StringBuffer();

  int len = number.length;
  for (int i = len - 1; i >= 0; i--) {
    String item = number.substring(len - i - 1, len - i);
    final index = int.parse(item);
    String han1Item = han1[index];

    if (index > 0) {
      if (index != 1) stringBuffer.write(han1Item);
      stringBuffer.write(han2[i % 4]);
    } else
      stringBuffer.write(han1Item);
    if (i % 4 == 0) {
      if (index == 1) stringBuffer.write(han1Item);
      stringBuffer.write(han3[(i / 4).round()]);
    }
  }
  stringBuffer.write(" 원");
  String won = stringBuffer.toString();

  won = won.replaceAll("억만", "억");
  won = won.replaceAll("조억", "조");
  won = won.replaceAll("경조", "경");

  return won;
}
