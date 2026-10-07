import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/screens/floating_action_button_screen.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/add_spare_parts_in_service_settings.dart';
import '../../../../../../features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../../features/service_settings/presentation/bloc/prov_services_cubit/prov_services_cubit.dart';
import '../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/screens/list_data_car_spare_parts_in_service_settings.dart';
import '../../../../../../core/theming/colors.dart';

class CarSparePartsInServiceSettings extends StatefulWidget {
  final String textServiceScreen;
  final Uint8List imageMemory;

  const CarSparePartsInServiceSettings(
      {super.key, required this.textServiceScreen, required this.imageMemory});

  @override
  State<CarSparePartsInServiceSettings> createState() =>
      _CarSparePartsInServiceSettingsState();
}

class _CarSparePartsInServiceSettingsState
    extends State<CarSparePartsInServiceSettings> {
  int _revision = 0;

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
                    key: ValueKey(_revision),
                    textServiceScreen: widget.textServiceScreen,
                    imageMemory: widget.imageMemory,
                  )),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButtonScreen(
          onPressed: () async {
            final saved = await Navigator.push<bool>(
              context,
              NavigateToPageWidget(const AddSparePartsInServiceSettings()),
            );
            if (saved == true && mounted) setState(() => _revision++);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
