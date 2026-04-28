import 'package:dio/dio.dart';
import 'package:sun_web_system/core/api_functions/branch/get_provider_branches_model/get_provider_branches_request.dart';
import 'package:sun_web_system/core/api_functions/branch/get_provider_branches_model/provider_branch_model.dart';
import '../../../../core/api/dio_function/api_constants.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<List<ProviderBranchModel>> getProviderBranchesFunction({
  required GetProviderBranchesRequest getProviderBranchesRequest,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      getProviderBranchesRequest.toJson(),
      ApiLink.getProviderBranches,
    );

    final data = response.data;

    return ProviderBranchModel.fromList(data);

  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}