import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/shared_packages_in_service_settings/create_package_dialog.dart';
import '../../../../../features/service_settings/presentation/pages/shared_packages_in_service_settings/screens/list_data_shared_packages_in_service_settings.dart';
import '../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/screens/floating_action_button_screen.dart';
import '../../../../../core/theming/colors.dart';


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

                      BlocProvider(
                        create: (_) => GetTaxCubit()..getTax(),
                      ),
                    ],
                    child: const CreatePackageDialog(
                      package: null,
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