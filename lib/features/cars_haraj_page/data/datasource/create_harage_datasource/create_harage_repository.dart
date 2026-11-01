import 'package:sun_web_system/core/api/api_result.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../../../../features/cars_haraj_page/data/request/create_update_harage_request/create_update_harage_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';


Future<void> createHarageFunction({
  required CreateUpdateHarageRequest createUpdateHarageRequest,
}) async {
  try {
    final jsonString = json.encode(
      createUpdateHarageRequest.toCreateJson(),
    );


   final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.createHarage,
    );
    ApiResult.requireSuccess(response);

  } catch (e) {
    debugPrint('CREATE ERROR: $e');

    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    rethrow;
  }
}