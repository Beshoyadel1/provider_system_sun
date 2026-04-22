import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_state.dart';
import 'package:sun_web_system/features/service_settings/shared_packages_in_service_settings/create_package_dialog.dart';
import '../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/add_shared_packages_in_service_settings.dart';
import '../../../../../features/service_settings/shared_packages_in_service_settings/screens/list_data_shared_packages_in_service_settings.dart';
import '../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/floating_action_button_screen.dart';
import '../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/language/language_constant.dart';


class SharedPackagesInServiceSettings extends StatelessWidget {
  const SharedPackagesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderPackagesCubit()..getPackages(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ListDataSharedPackagesInServiceSettings(),
                  ),
                ),
              ],
            ),
          ),
        ),


        floatingActionButton: BlocBuilder<ProviderPackagesCubit, ProviderPackagesState>(
          builder: (context, state) {
            final isLoading = state is ProviderPackagesLoading;

            return FloatingActionButtonScreen(
              onPressed: isLoading
                  ? null
                  : () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<ProviderPackagesCubit>(),
                      ),

                      /// ✅ FIX: create بدون package
                      BlocProvider(
                        create: (_) => GetTaxCubit()..getTax(),
                      ),
                    ],
                    child: const CreatePackageDialog(
                      package: null, // ✅ مهم جدًا
                    ),
                  ),
                );

                if (result == true) {
                  context.read<ProviderPackagesCubit>().getPackages();
                }
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
/*
*  BlocBuilder<ProviderPackagesCubit, ProviderPackagesState>(
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
      ),*/