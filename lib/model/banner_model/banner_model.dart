import 'dart:typed_data';

class BannersModel {
  int imageid;
  Uint8List image;
  String stringImage;
  int storeid;

  BannersModel({
    required this.imageid,
    required this.image,
    required this.stringImage,
    required this.storeid,
  });
}
