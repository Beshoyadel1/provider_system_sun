import 'package:dio/dio.dart';
import '../../../../core/model/harage/delete_harage_model/delete_harage_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteHarageFunction({
  required DeleteHarageRequest deleteHarageRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteHarageRequest.toJson(), // params
      ApiLink.deleteHarage,
    );
    AppSnackBar.showSuccess("Delete Harage successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}