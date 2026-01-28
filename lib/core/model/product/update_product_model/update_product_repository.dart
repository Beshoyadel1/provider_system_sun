import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/product/update_product_model/update_product_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateProductFunction({required UpdateProductRequest updateProductRequest}) async {
  try {
    String jsonString = json.encode(updateProductRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.updateProduct,
    ).then((value) {
      AppSnackBar.showSuccess("Update Product successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}