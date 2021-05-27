import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactiveScreen extends StatefulWidget {
  static const String routeName = '/examples/reactive_screen';

  @override
  _ReactiveScreenState createState() => _ReactiveScreenState();
}

class _ReactiveScreenState extends State<ReactiveScreen> {
  final ReactiveController controller = Get.put(ReactiveController())!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reactive'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Reactive'),
            renderObxCount01(),
            renderObxCount02(),
            renderObxSum(),
            renderObxUser(),
            renderObxList(),
            ElevatedButton(
              child: Text('COUNT 1 UP!'),
              onPressed: () => controller.count1++,
            ),
            ElevatedButton(
              child: Text('COUNT 2 UP!'),
              onPressed: () => controller.count2++,
            ),
            ElevatedButton(
              child: Text('Change User'),
              onPressed: () => controller.change(id: 2, name: '레드벨벳'),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderObxCount01() {
    return GetX<ReactiveController>(builder: (controller) {
      return Text('Count 1 : ${controller.count1.value}');
    });
  }

  Widget renderObxCount02() {
    return Obx(() => Text('Count 2 : ${controller.count2.value}'));
  }

  Widget renderObxSum() {
    return Obx(() => Text('SUM : ${controller.sum}'));
  }

  Widget renderObxUser() {
    return Obx(
      () => Text(
        'USER : ${controller.user.value.id}'
        '/${controller.user.value.name}',
      ),
    );
  }

  Widget renderObxList() {
    return Obx(() => Text('LIST : ${controller.testList}'));
  }
}

class User {
  int id;
  String name;

  User({
    required this.id,
    required this.name,
  });
}

class ReactiveController extends GetxController {
  RxInt count1 = 0.obs;
  var count2 = 0.obs;

  var user = new User(id: 1, name: '코드팩토리').obs;
  List testList = [1, 2, 3, 4, 5].obs;

  get sum => count1.value + count2.value;

  change({
    required int id,
    required String name,
  }) {
    user.update((val) {
      if (val == null) return;
      val.name = name;
      val.id = id;
    });
  }

  @override
  void onInit() {
    super.onInit();

    ever(count1, (_) => print('EVER : COUNT1 이 변경 될때마다 실행'));
    once(count1, (_) => print('ONCE : 처음으로 COUNT1 이 변경 되었을때'));

    debounce(
      count1,
      (_) => print('DEBOUNCE : 1초간 디바운스 한 뒤에 실행'),
      time: Duration(seconds: 1),
    );

    interval(
      count1,
      (_) => print('INTERVAL : 1초간 이터벌이 지나면 실행'),
      time: Duration(seconds: 1),
    );
  }
}
