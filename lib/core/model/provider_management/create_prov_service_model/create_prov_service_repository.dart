import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/create_prov_service_model/create_prov_service_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createProvServiceFunction({required CreateProvServiceRequest createProvServiceRequest}) async {
  try {
    String jsonString = json.encode(createProvServiceRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.provService}/CreateProvService",
    ).then((value) {
      AppSnackBar.showSuccess("Create Prov Service successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}