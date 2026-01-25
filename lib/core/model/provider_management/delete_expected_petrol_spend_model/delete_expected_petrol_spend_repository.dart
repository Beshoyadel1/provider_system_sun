import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/delete_expected_petrol_spend_model/delete_expected_petrol_spend_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteExpectedPetrolSpendFunction({
  required DeleteExpectedPetrolSpendRequest deleteExpectedPetrolSpendRequest,
}) async {
  try {
    await Network.deleteDataWithBodyAndParams(
      {},
      deleteExpectedPetrolSpendRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.expectedPetrolSpend}/DeleteExpectedPetrolSpend",
    );
    AppSnackBar.showSuccess("Delete Expected Petrol Spend successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}