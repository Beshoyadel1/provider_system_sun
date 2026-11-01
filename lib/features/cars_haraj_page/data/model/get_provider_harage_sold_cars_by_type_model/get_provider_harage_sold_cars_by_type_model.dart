import 'package:sun_web_system/core/api/api_json.dart';
class GetProviderHarageSoldCarsByTypeModel {
  final int newCarsCount;
  final int usedCarsCount;

  GetProviderHarageSoldCarsByTypeModel({
    required this.newCarsCount,
    required this.usedCarsCount,
  });

  factory GetProviderHarageSoldCarsByTypeModel.fromJson(
      Map<String, dynamic> json) {
    json = ApiJson.object(json);

    final data = json['data'];

    return GetProviderHarageSoldCarsByTypeModel(
      newCarsCount: data['newCarsCount'] ?? 0,
      usedCarsCount: data['usedCarsCount'] ?? 0,
    );
  }
}
