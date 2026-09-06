import 'package:sun_web_system/features/service_settings/data/response/get_prov_services_response/get_prov_services_response.dart';

abstract class CreateProvServiceState {}

class CreateProvServiceInitial extends CreateProvServiceState {}

class CreateProvServiceLoading extends CreateProvServiceState {}

class CreateProvServiceSuccess extends CreateProvServiceState {
  final GetProvServicesResponse createdService;

  CreateProvServiceSuccess(this.createdService);
}

class CreateProvServiceError extends CreateProvServiceState {
  final String error;

  CreateProvServiceError(this.error);
}
