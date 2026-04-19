import 'package:sun_web_system/core/api_functions/provider_management/get_prov_services_model/get_prov_services_response.dart';

abstract class ProvServicesState {}

class ProvServicesInitial extends ProvServicesState {}

class ProvServicesLoading extends ProvServicesState {}

class ProvServicesSuccess extends ProvServicesState {
  final List<GetProvServicesResponse> data;

  ProvServicesSuccess(this.data);
}

class ProvServiceUpdateSuccess extends ProvServicesState {}

class ProvServiceDeleteSuccess extends ProvServicesState {}

class ProvServicesError extends ProvServicesState {
  final String message;
  ProvServicesError(this.message);
}