import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/update_car_model/update_car_model_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateCarModelFunction({required UpdateCarModelRequest updateCarModelRequest}) async {
  try {
    String jsonString = json.encode(updateCarModelRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
        ApiLink.updateCarModel
    ).then((value) {
      AppSnackBar.showSuccess("Update Car Model successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}