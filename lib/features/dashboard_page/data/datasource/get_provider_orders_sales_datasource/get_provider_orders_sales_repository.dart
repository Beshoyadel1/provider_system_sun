import 'package:dio/dio.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/api/dio_function/dio_controller.dart';
import 'package:sun_web_system/core/api/dio_function/failures.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/dashboard_page/data/model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';
import 'package:sun_web_system/features/dashboard_page/data/model/get_provider_orders_sales_model/get_provider_orders_sales_request.dart';


Future<GetProviderOrdersSalesModel?> getProviderOrdersSalesFunction({
  required GetProviderOrdersSalesRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderOrdersSales,
    );

    return GetProviderOrdersSalesModel.fromJson(response.data);

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
    return null;
  }
}