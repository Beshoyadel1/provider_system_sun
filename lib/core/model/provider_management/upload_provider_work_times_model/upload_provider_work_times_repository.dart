import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/upload_provider_work_times_model/upload_provider_work_times_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> uploadProviderWorkTimesFunction({required UploadProviderWorkTimesRequest uploadProviderWorkTimesRequest}) async {
  try {
    String jsonString = json.encode(uploadProviderWorkTimesRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.workTIme}/UploadProviderWorkTimes",
    ).then((value) {
      AppSnackBar.showSuccess("Upload Provider Work Times successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}