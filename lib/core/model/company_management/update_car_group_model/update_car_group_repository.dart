import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/company_management/update_car_group_model/update_car_group_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateCarGroupFunction({required UpdateCarGroupRequest updateCarGroupRequest}) async {
  try {
    String jsonString = json.encode(updateCarGroupRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.carGroup}/UpdateCarGroup",
    ).then((value) {
      AppSnackBar.showSuccess("Update Car Group successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}