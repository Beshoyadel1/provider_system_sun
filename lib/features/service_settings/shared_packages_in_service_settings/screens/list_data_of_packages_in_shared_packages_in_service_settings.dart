import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
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
          AppSnackBar.showSuccess(AppLanguageKeys.success);
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const TextInAppWidget(
                              text: AppLanguageKeys.delete,
                              textSize: 18,
                              textColor: AppColors.redColor,
                            ),
                            content: const TextInAppWidget(
                              text: AppLanguageKeys.confirmDelete,
                              textSize: 14,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const TextInAppWidget(
                                  text: AppLanguageKeys.cancel,
                                  textSize: 14,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.redColor,
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const TextInAppWidget(
                                  textSize: 14,
                                  text: AppLanguageKeys.delete,
                                  textColor: AppColors.whiteColor,
                                ),
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
