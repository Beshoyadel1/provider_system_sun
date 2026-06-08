import 'package:sun_web_system/features/service_settings/data/model/get_provider_service_packages_model/provider_service_packages_model.dart';

abstract class ProviderPackagesState {}

class ProviderPackagesDeleteSuccess extends ProviderPackagesState {}

class ProviderPackagesInitial extends ProviderPackagesState {}

class ProviderPackagesLoading extends ProviderPackagesState {}

class ProviderPackagesSuccess extends ProviderPackagesState {
  final List<ProviderServicePackagesModel> packages;

  ProviderPackagesSuccess(this.packages);
}

class ProviderPackagesError extends ProviderPackagesState {
  final String message;

  ProviderPackagesError(this.message);
}
class ProviderPackagesCreateSuccess extends ProviderPackagesState {}

class ProviderPackagesUpdateSuccess extends ProviderPackagesState {}