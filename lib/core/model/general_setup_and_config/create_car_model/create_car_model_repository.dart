import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/create_car_model/create_car_model_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createCarModelFunction({required CreateCarModelRequest createCarModelRequest}) async {
  try {
    String jsonString = json.encode(createCarModelRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.createCarModel,
    ).then((value) {
      AppSnackBar.showSuccess("Create Car Model successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}

