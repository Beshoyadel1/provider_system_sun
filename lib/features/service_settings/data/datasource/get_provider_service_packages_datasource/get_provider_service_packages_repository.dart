import 'package:dio/dio.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_provider_service_packages_model/provider_service_packages_model.dart';
import '../../request/get_provider_service_packages_request/get_provider_service_packages_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/language/language_constant.dart';

Future<List<ProviderServicePackagesModel>>
getProviderServicePackagesFunction({
  required GetProviderServicePackagesRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderServicePackages,
    );

    if (response.data["success"] != true) {
      return [];
    }

    final List<dynamic> data =
        response.data["data"] ?? [];

    return data
        .map(
          (e) => ProviderServicePackagesModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  } on DioException catch (e) {
    throw Exception(
      responseOfStatusCode(e.response?.statusCode),
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}