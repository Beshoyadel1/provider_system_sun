import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/screens/floating_action_button_screen.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/add_spare_parts_in_service_settings.dart';
import '../../../../../../features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../../features/service_settings/presentation/bloc/prov_services_cubit/prov_services_cubit.dart';
import '../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/screens/list_data_car_spare_parts_in_service_settings.dart';
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
        floatingActionButton: FloatingActionButtonScreen(
         onPressed: (){
           Navigator.push(
             context,
             NavigateToPageWidget(
                 const AddSparePartsInServiceSettings()
             ),
           );
         },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}