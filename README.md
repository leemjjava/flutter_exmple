# 예제 파일

플러터 개발을 위한 테스트 코드를 저장하는 예제 파일

## 코딩규칙
코딩 규칙은 Google 팀의 pedantic 룰을 따른다. [여기에서](https://pub.dev/packages/pedantic) 
상세 내용을 확인할 수 있다. Dart 에서 공식으로 추천하는 lint 스타일인
[Effective Dart](https://dart.dev/guides/language/effective-dart)
에서 [몇가지 추가사항](https://pub.dev/packages/pedantic#stricter-than-effective-dart)
이 포함된 룰이다. Coding Standard 는 언제까지나 가독성을 위한 것이기 때문에
언제든 협의를 통해 변경할 수 있다. 기본으로 사용되지 않는 lint 룰은 [여기서](https://pub.dev/packages/pedantic#unused-lints)
확인 가능하고 기본으로 사용되는 lint 룰은 [여기서](https://github.com/google/pedantic/blob/master/lib/analysis_options.1.9.0.yaml)
확인 가능하다. `flutter analyze` 를 실행하면 린트를 실행할 수 있다.

## 폴더구조
```
+-- android
+-- assets (이미지, 폰트 및 앱에 탑재되는 static 파일)
+-- build
+-- ios
+-- lib
|   +-- animation (애니메이션 예제)
|   +-- components (컴포넌트 폴더)
|   +-- example (예제)
|   +-- http (http 통신)
|   +-- layouts (스크린 레아이웃 폴더)
|   +-- utils (공용 함수 폴더) 
|   +-- week_of_widget(week of widget 예제)
```

## components

### 컴포넌트 폴더 구조
컴포넌트로 구성한 widget을 그룹화해서(예시 - progress, alert) 패키지로 모아둔다.

### 위젯 코드정리
각 컴포넌트의 세부 위젯들은 공유가 되는 위젯들이 아니면 위젯 내부의 함수를 사용해서
코드 정리를 한다. 더 나아가 최상위 위젯의 `build` 함수에는 최대한 위젯을 직접
코딩하지 않도록 한다. 각 컴포넌트를 최대한 세부 위젯으로 나눠서 해당 세부 위젯을
리턴해주는 함수 또는 또다른 위젯을 코딩하여 `build` 함수를 위젯 구조대로
정리한다. 레이아웃이나 Row 또는 Column 등 위치를 세팅하는 위젯은 `build` 함수에
사용해도 된다.

**예제**  
*Good*
```
renderCenterMessage() {
    return Text(
        '스플래시 스크린\n토큰 체크 후 메인화면 또는 로그인 화면 이동',
        textAlign: TextAlign.center,
    );
}

renderNextPageButton(){
    return RaisedButton(
        child: Text(
            '홈 이동',
        ),
        onPressed: () {
            Get.toNamed('/');
        },
    );
}

build (ctx) {
    return Column(
        children: [
            renderCenterMessage(),
            renderNextPageButton(),
        ],
    );
}
```
*bad*
```
build (ctx) {
    return Column(
        children: [
            Text(
                '스플래시 스크린\n토큰 체크 후 메인화면 또는 로그인 화면 이동',
                textAlign: TextAlign.center,
            ),
            RaisedButton(
                child: Text(
                    '홈 이동',
                ),
                onPressed: () {
                    Get.toNamed('/');
                },
            ),
        ],
    );
}
```

> 함수의 순서는 initState -> dispose -> build -> render -> onTap -> etcMethod 순서로 작성한다.
> inistState 시와 dispose시에 호출할 함수들은 build 함수 전에 작성한다.
> Screen의 화면을 구성하는 함수들은 build 함수 아래로 화면에 구현된 순서대로 작성한다.
> 기능상의 목적보단 가독성의 영역이기 때문에 가독성을 해치지 않는 한에서 자유롭게 위젯을 나눠주면 된다.
> 추가적으로 렌더링 함수의 이름은 `render` 로 항상 시작하고 언더스코어를 사용하지 않는다. 
> 렌더링 함수의 이름은 이름이 길어지더라도 최대한 한번에 이해하기 쉬운 이름을 채택한다.

### Gesture Detector vs InkWell
InkWell 리플이펙트가 적용이 가능하면 InkWell 을 최대한 사용해준다. 이미지이거나
특수한 상황에 리플이펙트가 적용이 어렵다면 GestureDetector 를 사용해서 액션을
받는다.

## ViewModel 구조

### server model
네트워크 통신을 통해 제공받은 Json String 을 저장하기 위한 Model 이다.
fromJson factory 함수를 이용하여 Json String 을 변수에 저장한다.

### local model
local 패키지 하위에 존재하는 model 로써 어플리케이션 단에서 사용하기 위한 Model 이다.
ChangeNotifier 을 상속받은 LocalModel 의 경우 데이터 입력 상태에 따라 Screen 을 변경하기 위한 Model 이다.
Screen 을 변경할 수 있는 변수의 경우 getter, setter 를 구현하고 notifyListeners() 을 호출한다.

### service
service 패키지는 서버 통신을 통해서 ViewModel 에게 Model 을 제공하는 역할을 한다.
GraphQL을 통해서 데이터를 제공받을 경우에는 BasicService 를 상속 받아서 구현한다.
http 통신을 통해서 데이터를 제공받을 경우에는 현재까지는 전송부까지 직접 구현한다.
각각의 service 들은 네트워크를 통해서 resource 를 제공받고, 
Dart Model 로 변환하여 ViewModel 에게 제공한다.

### view model
resource 제공자(예 - service, method channel 등)에게서 Model 을 제공받아, View 에게 전달하는 역할이다.

### bloc cubit
전역으로 어떠한 Model 에 접근해야 할 필요가 있는 경우 Cubit 을 사용한다.
Cubit 은 특정 Model 혹은 List<Model> 을 소유하고 있고, 자체적으로 변경 업데이트 한다.
해당 Model 에 상태를 확인해야 하는 View 는 BlocProvider 를 이용해서 Cubit 을 구독한다.

## View 구조

### Layout
가장 바깥쪽에 Scaffold, SafeArea, TopBar 등을 지정하는 역할을 하는 Widget 이다.

### View Update
기본적으로 Screen 은 Stateless Widget 으로 구현한다.
서버에서 데이터를 받아와서 View 를 업데이트 하는 경우에 ViewModel 과 FutureBuilder 를 사용한다.

**예제**
```

Widget renderMain() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          renderImagePage(),
          renderTitle(),
          renderRoomList(),
          renderContractInfo(),
          renderFacilityInfo(),
          renderMap(),
          renderFeaturePoint(),
          renderContentInfo(),
        ],
      ),
    );
  }

  Widget renderImagePage() {
    return FutureBuilder<ResultHouseImageList?>(
      future: viewModel.getImageList(houseTypeCode, divisionName, divisionId),
      builder: (_, final snapshot) {
        if (snapshot.hasError) showToastHouse();
        return HouseImagePage(model: snapshot.data);
      },
    );
  }

```

여러차례 View 를 업데이트 하는 경우 StatefulWidget 을 이용한다.
StatefulWidget 을 사용하는 경우 initState 시에 데이터를 읽어오고 setState 를 호출한다.
StatefulWidget 을 Screen 으로 사용하는 경우 route animation 이 종료된 후에 setState() 를 호출한다. 

**예제**
```

  @override
  void initState() {
    super.initState();
    _setData();
  }

  _setData() async {
    try {
      this.list = await AuthViewModel().getWishList();
      _setStateEndAnimation();
    } catch (error, stacktrace) {
      if (isProgressShow(context)) Navigator.pop(context);

      print("onError: $error");
      print(stacktrace.toString());
      if (error is ErrorModel) {
        final message = error.message;
        print(message);

        if (error.code == '401') return showKakaoAlert(context, message);
        showToast("서버와 통신 중 에러가 발생하였습니다.");
      }

      if (error is TimeoutException) {
        print("TimeoutException");
        showToast("통신이 원활하지 않습니다. 네트워크 상태를 확인하세요.");
      }
    }
  } 

  void _setStateEndAnimation() {
    var route = ModalRoute.of(context);
    if (route == null) return setState(() {});
    final animation = route.animation;
    if (animation == null) return setState(() {});

    if (animation.isCompleted) return setState(() {});

    void handler(status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
        animation.removeStatusListener(handler);
      }
    }

    animation.addStatusListener(handler);
  }

```

전역에 선언되어 있는 Model 을 Listen 하여 View 를 업데이트 하는 경우 Cubit 을 사용한다.

**예제**
```

  @override
  Widget build(BuildContext context) {
    this.context = context;
    model = context.watch<UserProfileCubit>().state;
    if (model == null) return LogoutScreen();

    return DefaultLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            renderTopRow(),
            SizedBox(height: 48),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: renderProfile(),
            ),
            SizedBox(height: 32),
            SizedBox(height: 53, child: renderMid()),
            SizedBox(height: 16),
            Container(color: nidoGreyF5, height: 8),
            MyList(),
          ],
        ),
      ),
    );
  }

```

한 화면에서 데이터 값에 따라 Widget 이 변경되는 경우 ChangeNotifierProvider 와
Consumer 를 이용해서 Widget 을 Update 한다.

**예제**
```

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ChangeNotifierProvider(
      create: (context) => loginModel,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: DefaultLayout(body: renderBody()),
      ),
    );
  }

  Widget renderBody() {
    return Column(
      children: [
        Expanded(child: renderScrollView()),
        Consumer<LoginModel>(
          builder: (context, moveOutRating, child) {
            final isDisable = _inputDataCheck() == false;
            return BottomButton(
              title: '로그인',
              onTap: _onLoginBtnTap,
              isDisable: isDisable,
            );
          },
        ),
      ],
    );
  }

```

## Assets

### Images
네트워크 이미지를 다룰때는 무조건 cached_network_image 를 사용한다. 데이터를 세이브하고
로딩 속도를 많이 올려줄 수 있다.

특정 패턴대로 이미지를 정리 해두면 Flutter 에서 자동으로 해상도별 이미지를 활용한다.
한가지 아쉬운점은 우리가 일반적으로 사용하는 mdpi, hdp, xhdpi...가 아닌 x2.0, x3.0
... 등 배수를 사용해 사이즈별 이미지를 적용한다. 상세내용은 [여기서](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware) 
볼 수 있다. `AssetImage` 위젯을 사용해서 이미지를 렌더링하면 된다.

## Themes

### Color Scheme
공통적으로 사용되는 컬러값의 경우 resource 파일에서 선언해서 관리한다.
변수명은 nido + ColorName + hexcode 2자리로 한다.
퍼센트 값을 사용하는 회색의 경우 변수명은 nido + ColorName + 퍼센트 + p 로 한다.

**예제**
```
const Color nidoBlue05 = Color(0xff057bc7);
const Color nidoBlue03 = Color(0xff03a0f0);
const Color nidoBlue00 = Color(0xff00aeff);
const Color nidoBlue0023p = Color(0x3b00aeff);

const Color nidoGrey04p = Color(0x0A000000);
const Color nidoGrey12p = Color(0x1F000000);
const Color nidoGrey23p = Color(0x3B000000);
const Color nidoGrey34p = Color(0x57000000);
const Color nidoGrey38p = Color(0x61000000);

```

### Text Style
공통적으로 사용되는 Text Style 의 경우 resource 파일에 선언하여 관리한다.
변수명은 body + fontSize + height + fontWeight 로 한다.

**예제**
```
const TextStyle body11185 = TextStyle(
  fontSize: 11,
  height: (18 / 11),
  fontWeight: FontWeight.w500,
);

const TextStyle body12164 = TextStyle(
  fontSize: 12,
  height: (16 / 12),
  fontWeight: FontWeight.w400,
);

```
