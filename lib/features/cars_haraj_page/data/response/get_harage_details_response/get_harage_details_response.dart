import 'package:sun_web_system/core/api/api_json.dart';
import '../../../../../../features/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';

class GetHarageDetailsResponse {
  final bool success;
  final HarageData? data;

  GetHarageDetailsResponse({
    required this.success,
    this.data,
  });

  factory GetHarageDetailsResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    json = ApiJson.object(json);
    return GetHarageDetailsResponse(
      success: json['success'] ?? false,

      data: json['data'] is Map<String, dynamic>
          ? HarageData.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}
