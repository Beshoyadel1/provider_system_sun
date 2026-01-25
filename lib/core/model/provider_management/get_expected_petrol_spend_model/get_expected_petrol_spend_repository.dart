import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/get_expected_petrol_spend_model/get_expected_petrol_spend_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getExpectedPetrolSpendFunction({
  required GetExpectedPetrolSpendRequest getExpectedPetrolSpendRequestRequest,
}) async {
  try {
    await Network.getDataWithBodyAndParams(
      {},
      getExpectedPetrolSpendRequestRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.expectedPetrolSpend}/GetExpectedPetrolSpend",
    );
    AppSnackBar.showSuccess("Get Expected Petrol Spend successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}