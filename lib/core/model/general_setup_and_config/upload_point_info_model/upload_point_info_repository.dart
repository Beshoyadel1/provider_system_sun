import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/upload_point_info_model/upload_point_info_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> uploadPointInfoFunction({required UploadPointInfoRequest uploadPointInfoRequest}) async {
  try {
    String jsonString = json.encode(uploadPointInfoRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.points}/UploadPointInfo",
    ).then((value) {
      AppSnackBar.showSuccess("Upload Point Info successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}