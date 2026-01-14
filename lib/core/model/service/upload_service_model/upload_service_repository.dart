import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/service/upload_service_model/upload_service_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> uploadServiceFunction({
  required UploadServiceRequest uploadServiceRequest,
}) async {
  try {
    String jsonString = json.encode(uploadServiceRequest.toJson());
    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.service}/UploadService",
    ).then((value) {
      AppSnackBar.showSuccess("Upload Service successfully");
    }
    );
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
