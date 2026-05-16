import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/prov_services_cubit/prov_services_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/list_data_added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../../core/theming/colors.dart';

class AddedMaintenanceAndInternalServicesInServiceSettings
    extends StatelessWidget {
  final String textServiceScreen;
  final Uint8List imageMemory;
  const AddedMaintenanceAndInternalServicesInServiceSettings({super.key,required this.textServiceScreen,required this.imageMemory});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CreateProvServiceCubit(),
        ),
        BlocProvider(
          create: (_) => ProvServicesCubit(),
        ),
      ],
      child:  Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(),
        body:  SafeArea(
          child: Padding(
            padding:const  EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child:  ListDataAddedMaintenanceAndInternalServicesInServiceSettings(
                        textServiceScreen:textServiceScreen ,
                        imageMemory:imageMemory,
                      )),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: ContainerLastTwoButtonInAddedMaintenanceAndInternalServicesInServiceSettings(),
      ),
    );
  }
}
