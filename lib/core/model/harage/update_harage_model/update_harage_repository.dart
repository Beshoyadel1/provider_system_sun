import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/harage/update_harage_model/update_harage_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> updateHarageFunction({required UpdateHarageRequest updateHarageRequest}) async {
  try {
    String jsonString = json.encode(updateHarageRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.updateHarage,
    ).then((value) {
      AppSnackBar.showSuccess("Update Harage successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}

