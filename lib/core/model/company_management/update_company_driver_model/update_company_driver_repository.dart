import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/company_management/update_company_driver_model/update_company_driver_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateCompanyDriverFunction({required UpdateCompanyDriverRequest updateCompanyDriverRequest}) async {
  try {
    String jsonString = json.encode(updateCompanyDriverRequest.toJson());
    await Network.postDataWithBody(
      jsonString,
      ApiLink.updateCompanyDriver,
    ).then((value) {
      AppSnackBar.showSuccess("Update Company Driver successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}