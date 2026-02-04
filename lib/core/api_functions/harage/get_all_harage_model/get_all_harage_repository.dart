import 'package:dio/dio.dart';
import '../../../../core/api_functions/harage/get_all_harage_model/get_all_harage_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<void> getAllHarageFunction({
  required GetAllHarageRequest getAllHarageRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getAllHarageRequest.toJson(), // params
      ApiLink.getAllHarage,
    );
    AppSnackBar.showSuccess(AppLanguageKeys.getAllHarageSuccessfully);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}