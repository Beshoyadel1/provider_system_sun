import 'package:sun_web_system/core/api/api_json.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/api/dio_function/dio_controller.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import '../model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';
import '../request/get_provider_service_statistics_request/get_provider_service_statistics_request.dart';

Future<List<DataPoint>> getDashboardServiceChart({
  required int serviceId,
  required GetProviderServiceStatisticsRequest request,
}) async {
  final petrol = serviceId == MainCategoryConstants.petrolMainID;
  final response = await Network.postDataWithQuery(
    {...request.toJson(), if (!petrol) 'mainServiceId': serviceId},
    petrol
        ? ApiLink.getProviderPetrolSalesChart
        : ApiLink.getProviderMainServiceStatistics,
  );
  final body = response.data;
  if (body is! Map || ApiJson.object(body)['success'] != true) {
    throw Exception(AppLanguageKeys.errorLoadingData);
  }
  final data = ApiJson.object(body)['data'];
  if (data is! Map) throw const FormatException('Invalid service sales');
  return GetProviderOrdersSalesModel.fromJson({
    'data': petrol ? data : ApiJson.object(data)['salesChart'],
  }).dataPoints;
}
