import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/update_branch_model/update_branch_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateBranchFunction({required UpdateBranchRequest updateBranchRequest}) async {
  try {
    String jsonString = json.encode(updateBranchRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.updateBranch,
    ).then((value) {
      AppSnackBar.showSuccess("Update Branch successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}