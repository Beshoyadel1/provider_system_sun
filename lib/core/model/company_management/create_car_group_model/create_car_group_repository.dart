import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/company_management/create_car_group_model/create_car_group_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createCarGroupFunction({required CreateCarGroupRequest createCarGroupRequest}) async {
  try {
    String jsonString = json.encode(createCarGroupRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.createCarGroup,
    ).then((value) {
      AppSnackBar.showSuccess("Create Car Group successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}