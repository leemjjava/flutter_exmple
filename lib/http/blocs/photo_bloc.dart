import 'package:photo_manager/photo_manager.dart';
import 'package:rxdart/rxdart.dart';
import '../models/error.dart';

class PhotoBloc {
  final _assetEntityFetcher = PublishSubject<List<AssetEntity>>();
  Stream<List<AssetEntity>> get assetEntityList => _assetEntityFetcher.stream;

  dispose() {
    _assetEntityFetcher.close();
  }

  void getLocalPhoto() async {
    var result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      List<AssetPathEntity> list =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> allImageList = [];

      for (AssetPathEntity data in list) {
        final assetCount = data.assetCount;
        List<AssetEntity> imageList = await data.getAssetListRange(start: 0, end: assetCount);
        allImageList.addAll(imageList);
      }
      _assetEntityFetcher.sink.add(allImageList);
    } else {
      final error = ErrorModel(
        statusCode: 0,
        error: -1,
        message: "사진촬영 권한 없음",
      );
      _assetEntityFetcher.sink.addError(error);
    }
  }
}
