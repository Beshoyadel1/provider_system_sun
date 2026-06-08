
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/service_card.dart';
import '../../../../../../features/service_settings/presentation/bloc/prov_services_cubit/prov_services_cubit.dart';
import '../../../../../../features/service_settings/presentation/bloc/prov_services_cubit/prov_services_state.dart';

class ProvServiceBrandsListView extends StatelessWidget {
  final int serviceId;

  const ProvServiceBrandsListView({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProvServicesCubit()
        ..getProvServices(serviceId: serviceId),
      child: BlocConsumer<ProvServicesCubit, ProvServicesState>(
        listener: (context, state) {
          if (state is ProvServiceUpdateSuccess) {
            AppSnackBar.showSuccess(AppLanguageKeys.success);
          }

          if (state is ProvServicesError) {
            AppSnackBar.showError(state.message);
          }
        },
        builder: (context, state) {
          if (state is ProvServicesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProvServicesSuccess) {
            final services = state.data;

            if (services.isEmpty) {
              return const SizedBox();
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return ServiceCard(service: services[index]);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}