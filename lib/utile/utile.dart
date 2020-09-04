import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

final String host = "https://ggvpuf5kd9.execute-api.ap-northeast-2.amazonaws.com";
final String authHost = "https://23fay7fefe.execute-api.ap-northeast-2.amazonaws.com";

ProgressDialog getProgressDialog(BuildContext context, String title) {
  ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
  pr.style(
    progress: 50.0,
    message: title,
    progressWidget:
        Container(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
    maxProgress: 100.0,
    progressTextStyle:
        TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    messageTextStyle:
        TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w600),
  );
  return pr;
}

showAlertDialog(BuildContext context, String message) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, "OK");
            },
          ),
          FlatButton(
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
