import 'package:sun_web_system/core/api_functions/provider_management/get_provider_service_packages_model/provider_service_packages_model.dart';

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
/// ✅ CREATE SUCCESS
class ProviderPackagesCreateSuccess extends ProviderPackagesState {}

/// ✅ UPDATE SUCCESS
class ProviderPackagesUpdateSuccess extends ProviderPackagesState {}