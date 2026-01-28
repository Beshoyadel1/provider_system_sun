import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/update_prov_service_model/update_prov_service_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateProvServiceFunction({required UpdateProvServiceRequest updateProvServiceRequest}) async {
  try {
    String jsonString = json.encode(updateProvServiceRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.updateProvService,
    ).then((value) {
      AppSnackBar.showSuccess("Update Prov Service successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}