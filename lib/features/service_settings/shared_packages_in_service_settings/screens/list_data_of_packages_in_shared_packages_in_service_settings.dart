import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_state.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/service_settings/custom_widget/container_shared_package_design_widget.dart';

class ListDataOfPackagesInSharedPackagesInServiceSettings
    extends StatelessWidget {
  const ListDataOfPackagesInSharedPackagesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderPackagesCubit, ProviderPackagesState>(
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

                final itemsList = package.items
                    .split(',')
                    .map((e) => e.trim())
                    .toList();

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ContainerSharedPackageDesignWidget(
                    textPackage: package.getLocalizedName(context),
                    price: package.price.toString(),
                    items: itemsList,
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
    );
  }
}