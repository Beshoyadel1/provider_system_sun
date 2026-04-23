import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../../features/service_settings/logic/prov_services_cubit/prov_services_cubit.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/list_data_car_spare_parts_in_service_settings.dart';
import '../../../../../../core/theming/colors.dart';

class CarSparePartsInServiceSettings extends StatelessWidget {
  final String textServiceScreen;
  final Uint8List imageMemory;

  const CarSparePartsInServiceSettings(
      {super.key, required this.textServiceScreen, required this.imageMemory});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CreateProvServiceCubit(),
        ),
        BlocProvider(
          create: (_) => ProvServicesCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child: ListDataCarSparePartsInServiceSettings(
                        textServiceScreen: textServiceScreen,
                        imageMemory: imageMemory,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
