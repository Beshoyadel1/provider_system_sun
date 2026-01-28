import 'package:dio/dio.dart';
import '../../../../core/model/harage/get_all_harage_model/get_all_harage_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> GetAllHarageFunction({
  required GetAllHarageRequest getAllHarageRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getAllHarageRequest.toJson(), // params
      ApiLink.getAllHarage,
    );
    AppSnackBar.showSuccess("Get All Harage successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}