import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/rates/create_rate_model/create_rate_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createRateFunction({required CreateRateRequest createRateRequest}) async {
  try {
    String jsonString = json.encode(createRateRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.rate}/CreateRate",
    ).then((value) {
      AppSnackBar.showSuccess("Create Rate successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}