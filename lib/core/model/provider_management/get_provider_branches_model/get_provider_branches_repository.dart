import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/get_provider_branches_model/get_provider_branches_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderBranchesFunction({
  required GetProviderBranchesRequest getProviderBranchesRequest,
}) async {
  try {
    await Network.getDataWithBodyAndParams(
      {},
      getProviderBranchesRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.branch}/GetProviderBranches",
    );
    AppSnackBar.showSuccess("Get Provider Branches successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}