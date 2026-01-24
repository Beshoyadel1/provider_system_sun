import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/get_all_pages_about_model/get_all_pages_about_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getAllPagesAboutFunction({
  required GetAllPagesAboutRequest getAllPagesAboutRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getAllPagesAboutRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.about}/GetAllPagesAbout",
    );
    AppSnackBar.showSuccess("Get All Pages About successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
