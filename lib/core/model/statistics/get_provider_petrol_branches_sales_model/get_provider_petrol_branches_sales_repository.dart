import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_provider_petrol_branches_sales_model/get_provider_petrol_branches_sales_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderPetrolBranchesSalesFunction({
  required GetProviderPetrolBranchesSalesRequest getProviderPetrolBranchesSalesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderPetrolBranchesSalesRequest.toJson(), // params
        ApiLink.getProviderPetrolBranchesSales
    );
    AppSnackBar.showSuccess("Get Provider Petrol Branches Sales successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
