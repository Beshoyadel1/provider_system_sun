import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/delete_tax_model/delete_tax_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteTaxFunction({
  required DeleteTaxRequest deleteTaxRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteTaxRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.tax}/DeleteTax",
    );
    AppSnackBar.showSuccess("Delete Tax successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}