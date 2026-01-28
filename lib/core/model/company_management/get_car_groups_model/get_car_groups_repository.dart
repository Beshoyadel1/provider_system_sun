import 'package:dio/dio.dart';
import '../../../../core/model/company_management/get_car_groups_model/get_car_groups_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCarGroupsFunction({
  required GetCarGroupsRequest getCarGroupsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCarGroupsRequest.toJson(), // params
      ApiLink.getCarGroups,
    );
    AppSnackBar.showSuccess("Get Car Groups successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}