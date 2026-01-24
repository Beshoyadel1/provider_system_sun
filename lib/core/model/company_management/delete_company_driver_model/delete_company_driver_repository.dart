import 'package:dio/dio.dart';
import '../../../../core/model/company_management/delete_company_driver_model/delete_company_driver_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteCompanyDriverFunction({
  required DeleteCompanyDriverRequest deleteCompanyDriverRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteCompanyDriverRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.driver}/DeleteCompanyDriver",
    );
    AppSnackBar.showSuccess("Delete Company Driver successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
