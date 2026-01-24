import 'package:dio/dio.dart';
import '../../../../core/model/company_management/get_company_drivers_model/get_company_drivers_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCompanyDriversFunction({
  required GetCompanyDriversRequest getCompanyDriversRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCompanyDriversRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.driver}/GetCompanyDrivers",
    );
    AppSnackBar.showSuccess("Get Company Drivers successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}