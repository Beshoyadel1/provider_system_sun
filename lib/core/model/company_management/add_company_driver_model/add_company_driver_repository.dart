import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/company_management/add_company_driver_model/add_company_driver_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> addCompanyDriverFunction({required AddCompanyDriverRequest addCompanyDriverRequest}) async {
  try {
    String jsonString = json.encode(addCompanyDriverRequest.toJson());
    await Network.postDataWithBody(
      jsonString,
        ApiLink.addCompanyDriver
    ).then((value) {
      AppSnackBar.showSuccess("Add Company Driver successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}