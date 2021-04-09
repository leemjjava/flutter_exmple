import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectEntity {
  SelectEntity({
    Key? key,
    required this.entity,
  });

  final AssetEntity entity;
  bool isSelect = false;
  Uint8List? uint8List;
  int selectCount = -1;
}
