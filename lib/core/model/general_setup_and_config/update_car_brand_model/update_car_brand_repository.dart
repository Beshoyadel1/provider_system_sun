import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/update_car_brand_model/update_car_brand_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateCarBrandFunction({required UpdateCarBrandRequest updateCarBrandRequest}) async {
  try {
    String jsonString = json.encode(updateCarBrandRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.carBrand}/UpdateCarBrand",
    ).then((value) {
      AppSnackBar.showSuccess("Update Car Brand successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}