import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../features/service_settings/presentation/pages/first_screen_service_settings/screens/list_data_first_screen_service_setting.dart';
import '../../../../../core/theming/colors.dart';

class FirstScreenServiceSettings extends StatelessWidget {
  const FirstScreenServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return const Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ListDataFirstScreenServiceSetting()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
