import 'package:sun_web_system/features/service_settings/data/model/get_provider_service_packages_model/package_provider_service_packages_model.dart';
import '../service_branch.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_provider_service_packages_model/service_provider_service_packages_model.dart';

import 'package:sun_web_system/features/service_settings/data/model/get_provider_service_packages_model/package_item_model.dart';

class ProviderServicePackagesModel {
  final List<int> branchIds;
  final List<ServiceBranch> availableBranches;

  List<int> get effectiveBranchIds => branchIds.isNotEmpty
      ? branchIds
      : package.branchIds.isNotEmpty
          ? package.branchIds
          : availableBranches.map((branch) => branch.id).toSet().toList();
  final PackageProviderServicePackagesModel package;

  final List<ServiceProviderServicePackagesModel> services;

  final List<PackageItemModel> items;

  ProviderServicePackagesModel({
    this.branchIds = const [],
    this.availableBranches = const [],
    required this.package,
    required this.services,
    required this.items,
  });

  factory ProviderServicePackagesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProviderServicePackagesModel(
      branchIds: parseServiceBranchIds(json['branchIds']),
      availableBranches:
          parseAvailableServiceBranches(json['availableBranches']),
      package: PackageProviderServicePackagesModel.fromJson(
        json['package'],
      ),
      services: (json['services'] as List? ?? [])
          .map(
            (e) => ServiceProviderServicePackagesModel.fromJson(e),
          )
          .toList(),
      items: (json['items'] as List? ?? [])
          .map(
            (e) => PackageItemModel.fromJson(e),
          )
          .toList(),
    );
  }
}
