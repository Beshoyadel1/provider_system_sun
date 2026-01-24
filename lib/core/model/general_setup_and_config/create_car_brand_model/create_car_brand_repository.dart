import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/create_car_brand_model/create_car_brand_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createCarBrandFunction({required CreateCarBrandRequest createCarBrandRequest}) async {
  try {
    String jsonString = json.encode(createCarBrandRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.carBrand}/CreateCarBrand",
    ).then((value) {
      AppSnackBar.showSuccess("Create Car Brand successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}

