import 'package:flutter/material.dart';
import 'package:navigator/components/card/asset_image.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/http/blocs/photo_bloc.dart';
import 'package:navigator/http/models/error.dart';
import 'package:navigator/http/models/select_entity.dart';
import 'package:navigator/utile/button.dart';
import 'package:navigator/utile/utile.dart';
import 'package:photo_manager/photo_manager.dart';

const Color grayCC = Color(0xFFCCCCCC);
const Color blue20 = Color(0xFF204D7E);
const Color whiteFF = Color(0xFFFFFFFF);
const Color grayEd = Color(0xFFEdEdEd);
const Color grayE4 = Color(0xFFE4E4E4);

class PhotoGridExample extends StatefulWidget {
  static const String routeName = '/examples/photo_grid';

  @override
  _PhotoGridExampleState createState() => _PhotoGridExampleState();
}

class _PhotoGridExampleState extends State<PhotoGridExample> {
  List<SelectEntity> _imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteFF,
      body: SafeArea(
        child: renderMain(),
      ),
    );
  }

  Widget renderMain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopBar(title: 'Photo Grid'),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '사진을 선택해 주세요',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        renderList(),
      ],
    );
  }

  Widget renderList() {
    return Container(
      color: whiteFF,
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) return renderFirstItem();
          return renderImageListItem(index - 1);
        },
      ),
    );
  }

  Widget renderFirstItem() {
    return InkResponse(
      child: Container(
        margin: EdgeInsets.only(right: 10, left: 16),
        decoration: BoxDecoration(border: Border.all(color: grayEd)),
        width: 150,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/camera.png", width: 30, height: 30),
            renderFirstItemText(),
          ],
        ),
      ),
      onTap: _firstItemOnTap,
    );
  }

  Widget renderFirstItemText() {
    int length = _imageList.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$length",
          style: TextStyle(
            color: length > 0 ? blue20 : grayEd,
            fontSize: 13,
          ),
        ),
        Text(
          "/10",
          style: TextStyle(color: grayE4, fontSize: 13),
        )
      ],
    );
  }

  Widget renderImageListItem(int index) {
    double size = 150;

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AssetImageCS(
              selectEntity: _imageList[index],
              width: size,
              height: size,
              boxFit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 15,
          child: InkResponse(
            child: Image.asset("assets/image_close.png", width: 25, height: 25),
            onTap: () {
              setState(() => _imageList.removeAt(index));
            },
          ),
        ),
      ],
    );
  }

  _firstItemOnTap() async {
    int maxCount = 10 - _imageList.length;

    if (maxCount <= 0) {
      final message = "더 이상 사진을 추가할 수 없습니다. 사진을 삭제하고 다시 시도해 주세요.";
      showAlertDialog(context, message);
      return;
    }

    final route = createSlideUpRoute(widget: PhotoGrid(maxCount: maxCount));
    final value = await Navigator.push(context, route);
    if (value == null) return;
    _imageList.addAll(value);
    setState(() {});
  }
}

class PhotoGrid extends StatefulWidget {
  final int maxCount;

  const PhotoGrid({
    Key? key,
    this.maxCount = 1,
  }) : super(key: key);

  @override
  PhotoGridState createState() => PhotoGridState();
}

class PhotoGridState extends State<PhotoGrid> {
  final _photoBloc = PhotoBloc();
  late List<SelectEntity> _imageList;
  int _selectCount = 0;
  int _minusCount = -1;
  late bool isSingleSelect;

  @override
  void initState() {
    super.initState();
    isSingleSelect = widget.maxCount == 1;
    _imageList = [];

    _photoBloc.getLocalPhoto();
    _photoBlocListen();
  }

  _photoBlocListen() {
    _photoBloc.assetEntityList.distinct().listen((List<AssetEntity> items) {
      final selectEntityList =
          items.map((entity) => SelectEntity(entity: entity)).toList();

      _imageList.addAll(selectEntityList);

      setState(() {});
    }).onError((error, stacktrace) {
      print(stacktrace);
      if (error is! ErrorModel) return;

      showAlertDialog(context, error.message);
    });
  }

  @override
  void dispose() {
    _photoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            TopBar(
              title: "사진 가져오기",
              closeIcon: Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: _imageList.map((entity) => gridImageItem(entity)).toList(),
              ),
            ),
            okBtn(),
          ],
        ),
      ),
    );
  }

  Widget gridImageItem(SelectEntity selectEntity) {
    return InkResponse(
      child: AssetImageCS(
        selectEntity: selectEntity,
        width: 300,
        height: 300,
        boxFit: BoxFit.cover,
        minusCount: _minusCount,
      ),
      onTap: () {
        if (isSingleSelect)
          singleSelectOnTap(selectEntity);
        else
          multiSelectOnTap(selectEntity);
      },
    );
  }

  singleSelectOnTap(SelectEntity selectEntity) {
    _selectCount++;
    selectEntity.isSelect = true;
    returnImage();
  }

  multiSelectOnTap(SelectEntity selectEntity) {
    if (isMaxCount(selectEntity)) {
      final message = "더 이상 사진을 추가할 수 없습니다. 사진을 삭제하고 다시 시도해 주세요.";
      showAlertDialog(context, message);
      return;
    }

    setState(() {
      final nowSelect = selectEntity.isSelect;

      if (nowSelect == false)
        entitySelect(selectEntity);
      else
        entityNotSelect(selectEntity);
    });
  }

  bool isMaxCount(SelectEntity selectEntity) {
    bool nowSelect = !selectEntity.isSelect;
    return nowSelect && widget.maxCount < _selectCount + 1;
  }

  entitySelect(SelectEntity selectEntity) {
    selectEntity.isSelect = true;
    ++_selectCount;
    _minusCount = -1;
    selectEntity.selectCount = _selectCount;
  }

  entityNotSelect(SelectEntity selectEntity) {
    selectEntity.isSelect = false;
    --_selectCount;
    _minusCount = selectEntity.selectCount;
    selectEntity.selectCount = -1;
  }

  Widget okBtn() {
    if (isSingleSelect) return Container();

    return ExpandBtnCS(
      title: "확인",
      buttonColor: _selectCount == 0 ? grayCC : blue20,
      textColor: whiteFF,
      fontSize: 20,
      height: 60,
      radius: 0,
      onPressed: returnImage,
    );
  }

  returnImage() {
    if (_selectCount == 0) return;

    final selectList = _imageList.where((entity) => entity.isSelect).map((entity) {
      entity.isSelect = false;
      return entity;
    }).toList();

    Navigator.pop(context, selectList);
  }
}
