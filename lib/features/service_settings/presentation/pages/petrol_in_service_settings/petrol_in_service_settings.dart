import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/prov_services_cubit/prov_services_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/petrol_in_service_settings/screens/list_data_petrol_in_service_settings.dart';

import '../../../../../core/theming/colors.dart';

class PetrolInServiceSettings extends StatelessWidget {
  final String textServiceScreen;
  final Uint8List imageMemory;
  const PetrolInServiceSettings({super.key,required this.textServiceScreen,required this.imageMemory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding:const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (_) => CreateProvServiceCubit(),
                          ),
                          BlocProvider(
                            create: (_) => ProvServicesCubit(),
                          ),
                        ],
                        child:  ListDataPetrolInServiceSettings(
                          imageMemory:imageMemory,
                          textServiceScreen:textServiceScreen ,
                        ))),
              ),
            ],
          ),
        ),
      ),
      //  bottomNavigationBar: ContainerLastTwoButtonInAddedMaintenanceAndInternalServicesInServiceSettings(),
    );
  }
}
