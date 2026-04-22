import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_state.dart';
import 'package:sun_web_system/features/service_settings/shared_packages_in_service_settings/create_package_dialog.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/service_settings/custom_widget/container_shared_package_design_widget.dart';

class ListDataOfPackagesInSharedPackagesInServiceSettings
    extends StatelessWidget {
  const ListDataOfPackagesInSharedPackagesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderPackagesCubit, ProviderPackagesState>(
      listener: (context, state) {
        if (state is ProviderPackagesDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Deleted successfully")),
          );

          context.read<ProviderPackagesCubit>().getPackages(); // 🔥 refresh
        }

        /// ERROR
        if (state is ProviderPackagesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<ProviderPackagesCubit, ProviderPackagesState>(
        builder: (context, state) {
          if (state is ProviderPackagesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProviderPackagesSuccess) {
            final packages = state.packages;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: packages.map((e) {
                  final package = e.package;

                  final itemsList =
                  package.items.split(',').map((e) => e.trim()).toList();

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ContainerSharedPackageDesignWidget(
                      textPackage: package.getLocalizedName(context),
                      price: package.price.toString(),
                      items: itemsList,

                        onPressedEdit: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<ProviderPackagesCubit>(),
                                ),
                                BlocProvider(
                                  create: (_) => GetTaxCubit()
                                    ..getTaxAndSelect(package.taxId),
                                ),
                              ],
                              child: CreatePackageDialog(
                                package: package,
                              ),
                            ),
                          );

                          if (result == true) {
                            context.read<ProviderPackagesCubit>().getPackages();
                          }
                        },

                      onPressedDelete: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Confirm Delete"),
                            content: const Text(
                                "Are you sure you want to delete this package?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          context.read<ProviderPackagesCubit>().deletePackage(
                                id: package.id,
                              );
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }

          if (state is ProviderPackagesError) {
            return Text(state.message);
          }

          return const SizedBox();
        },
      ),
    );
  }
}
