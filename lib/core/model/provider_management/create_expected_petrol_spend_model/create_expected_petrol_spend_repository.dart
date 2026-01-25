import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/add_branch_model/add_branch_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> addBranchFunction({required AddBranchRequest addBranchRequest}) async {
  try {
    String jsonString = json.encode(addBranchRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.branch}/AddBranch",
    ).then((value) {
      AppSnackBar.showSuccess("Create Product successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}