# 그로우 앱

모두의 성장관리 앱, 그로우는 어제보다 나은 오늘을 만들어가는 성장 커뮤니티 앱

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
|   +-- chart 
|   +-- common 
|   +-- core
|   +-- grow_lib
|   +-- helper
|   +-- model 
|   +-- modules
|   +-- resources
|   +-- ui
|       +-- ui_folder
|           +-- binding
|           +-- controller
|           +-- util
|           +-- mixins
|           +-- widgets
|   +-- util
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
centerMessage() {
    return Text(
        '스플래시 스크린\n토큰 체크 후 메인화면 또는 로그인 화면 이동',
        textAlign: TextAlign.center,
    );
}

nextPageButton(){
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
            centerMessage(),
            nextPageButton(),
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

> 함수의 순서는 build -> views 순서로 작성한다.
> Screen의 화면을 구성하는 함수들은 build 함수 아래로 화면에 구현된 순서대로 작성한다.
> 기능상의 목적보단 가독성의 영역이기 때문에 가독성을 해치지 않는 한에서 자유롭게 위젯을 나눠주면 된다.
> 추가적으로 렌더링 함수의 이름은 역할을 최대한 설명하는 이름으로 정하고 언더스코어를 사용하지 않는다. 
> 렌더링 함수의 이름은 이름이 길어지더라도 최대한 한번에 이해하기 쉬운 이름을 채택한다.

## 중복 UI 제거
Screen 내에서 동일한 UI 1회 이상 반복사용 되는 경우 Method 로 선언하고 호출하는 형태로 사용한다.
하나의 Screen은 하나의 .dart 파일 아래에 두는 것을 원칙으로 하지만, 
.dart 파일이 과도하게 길어져서 가독성을 해치는 경우 파일을 분리할 수 있다.
UI directory 내의 다른 파일에서 중복 사용되면 ui/widgets 폴더에 Class 형태로 선언한다.
UI directory 넘어서서 중복 사용되는 경우 components 아래에 Class 형태로 선언한다.

### Controller

## 역할
Screen 하나당 1개 이상의 Controller 가 연결되어 있다.
Controller 는 GetController 를 상속 받는다.
binding 을 통해서 Controller 를 put 한다.

**예제**
*GetPage*
```
GetPage(
  name: Routes.gallery,
  page: () => GrowGalleryView(),
  binding: GrowGalleryBinding(),
),
```

*Bindings*

```
class GrowGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GrowGalleryController>(GrowGalleryController());
  }
}
```

Screen 의 모든 이벤트와 비지니스 로직을 담당한다.
TextEditingController, ScrollController 같은 컨트롤러의 선언과 이벤트 처리를 담당한다.
obs 선언과 update() 함수를 통한 UI 의 일반적인 업데이트도 담당한다.
Connect 를 통해서 모델을 전달받는 네트워크 통신 부분도 담당한다.

## Controller 코드정리
최상단에는 


## 네트워크 통신
스웨거에 나눠진 구분에 따라서 GrowHttp Class 를 상속받는 Connect Class 가 통신을 담당한다.

**예제**
*get*
```
  Future<SnsValidator?> checkSocialId({required String snsId}) async {
    var params = {'snsId': snsId};
    var response = await get(AuthAPI.checkSnsSignUp.endPoint, queries: params);

    if (response.isSucceed) {
      return SnsValidator.fromJson(response.data!);
    } else {
      return null;
    }
  }
```
*post*
```
  Future<ChallengeRankStatisticsModel?> getRankingList({
    required int challengeSeq,
    required int pageNo,
    int pageSize = 15,
  }) async {
    final params = <String, dynamic>{
      'challengeSeq': challengeSeq,
      'pageNo': pageNo,
      'pageSize': pageSize,
    };
    final res = await post(
      ChallengeAPI.challengeRankingList.endPoint,
      data: params,
    );
    if (res.isSucceed) {
      return ChallengeRankStatisticsModel.fromJson(res.data!);
    }
    return null;
  }

```
네트워크 통신 주소는 lib/common/url.dart 아래에 API 로 끝나는 enum 을 사용한다.

**예제**
```
ThanksAPI.deleteThanksCard.endPoint
```


### Gesture Detector vs InkWell
InkWell 리플이펙트가 적용이 가능하면 InkWell 을 최대한 사용해준다. 이미지이거나
특수한 상황에 리플이펙트가 적용이 어렵다면 GestureDetector 를 사용해서 액션을
받는다.

## 코딩 스타일
Format code on save 옵션을 체크하고 개발한다.
Line length 는 100 으로 설정하고 개발한다.
null safety 옵셔널 데이터를 사용할때 ! 사용을 지양한다.

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
공통적으로 사용되는 컬러값의 경우 colors.dart 파일에서 선언해서 관리한다.
변수명은 c + hexcode 로 한다.
퍼센트 값을 사용하는 회색의 경우 변수명은 nido + ColorName + 퍼센트 + p 로 한다.

**예제**
```
const Color c057bc7 = Color(0xff057bc7);
const Color c03a0f0 = Color(0xff03a0f0);
const Color c00aeff = Color(0xff00aeff);
const Color c00aeff = Color(0x3b00aeff);

const Color c0A000000 = Color(0x0A000000);
const Color c1F000000 = Color(0x1F000000);
const Color c3B000000 = Color(0x3B000000);
const Color c57000000 = Color(0x57000000);
const Color c61000000 = Color(0x61000000);

```

### Text Style
공통적으로 사용되는 Text Style 의 경우 styles.dart 파일에 선언하여 관리한다.
변수명은 fontFamily 로 한다.

**예제**
```
  static TextStyle notoMedium = const TextStyle(
    fontFamily: 'NotoSansKR Medium',
  );

```
