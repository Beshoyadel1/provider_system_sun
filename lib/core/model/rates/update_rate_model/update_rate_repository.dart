import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/rates/update_rate_model/update_rate_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateRateFunction({required UpdateRateRequest updateRateRequest}) async {
  try {
    String jsonString = json.encode(updateRateRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.rate}/UpdateRate",
    ).then((value) {
      AppSnackBar.showSuccess("Update Rate successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}