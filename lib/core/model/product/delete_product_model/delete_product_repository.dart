import 'package:dio/dio.dart';
import '../../../../core/model/product/delete_product_model/delete_product_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteProductFunction({
  required DeleteProductRequest deleteProductRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteProductRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.product}/DeleteProduct",
    );
    AppSnackBar.showSuccess("Delete Product successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}