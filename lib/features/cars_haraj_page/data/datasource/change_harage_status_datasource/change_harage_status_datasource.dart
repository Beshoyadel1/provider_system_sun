import 'package:sun_web_system/core/api/api_result.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../features/cars_haraj_page/data/request/change_harage_status_request/change_harage_status_request.dart';

Future<void> changeHarageStatusFunction({
  required ChangeHarageStatusRequest request,
}) async {
  try {
    if (request.harageId <= 0 || !const [1, 2, 3, 4].contains(request.status)) {
      throw ArgumentError('Invalid Harage ID or status');
    }
    final jsonString = json.encode(
      request.toJson(),
    );

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.changeHarageStatus,
    );
    ApiResult.requireSuccess(response);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    rethrow;
  }
}
