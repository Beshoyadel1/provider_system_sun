import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/service/create_service_model/create_service_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> createServiceFunction({
  required CreateServiceRequest createServiceRequest,
}) async {
  try {
    String jsonString = json.encode(createServiceRequest.toJson());
    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.service}/CreateService",
    ).then((value) {
      AppSnackBar.showSuccess("Create Service successfully");
    });
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
