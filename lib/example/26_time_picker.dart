import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:navigator/utile/utile.dart';

// ignore: must_be_immutable
class TimePicker extends StatelessWidget {
  static const String routeName = '/examples/time_picker';
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return DefaultLayout(
      body: Column(
        children: [
          TopBar(title: 'Time Picker'),
          Expanded(child: renderButton()),
        ],
      ),
    );
  }

  Widget renderButton() {
    return Center(
      child: InkWellCS(
        child: Text("Time Picker"),
        onTap: showTimePickerPop,
      ),
    );
  }

  showTimePickerPop() {
    Future<TimeOfDay?> selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      errorInvalidText: "정확히 입력해주세요.",
      confirmText: "확인",
      cancelText: "취소",
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF7595C0)),
            timePickerTheme: _myTimePickerTheme(ThemeData().timePickerTheme),
          ),
          child: child ?? Container(),
        );
      },
    );

    selectedTime.then((timeOfDay) {
      Fluttertoast.showToast(
        msg: timeOfDay.toString(),
        toastLength: Toast.LENGTH_LONG,
        //gravity: ToastGravity.CENTER,  //위치(default 는 아래)
      );
    });
  }

  TimePickerThemeData _myTimePickerTheme(TimePickerThemeData base) {
    Color myTimePickerMaterialStateColorFunc(
      Set<MaterialState> states, {
      bool withBackgroundColor = false,
    }) {
      final interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
        MaterialState.selected,
      };

      if (states.any(interactiveStates.contains)) return Color(0xFFE0EAFC);
      return withBackgroundColor ? Color(0xFFE8E9EC) : Colors.transparent;
    }

    return base.copyWith(
      hourMinuteTextColor: Colors.black,
      hourMinuteColor: MaterialStateColor.resolveWith(
        (Set<MaterialState> states) =>
            myTimePickerMaterialStateColorFunc(states, withBackgroundColor: true),
      ), //Background of Hours/Minute input
      dayPeriodTextColor: Colors.black,
      dayPeriodColor: MaterialStateColor.resolveWith(
        myTimePickerMaterialStateColorFunc,
      ), //Background of AM/PM.
      dialHandColor: Colors.black,
      dialBackgroundColor: Color(0xFFE8E9EC),
      dayPeriodBorderSide: BorderSide(color: Color(0xFFE8E9EC)),
    );
  }
}
