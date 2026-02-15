import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/list_data_first_screen_advertisements.dart';
import '../../../../../core/theming/colors.dart';

class FirstScreenAdvertisements extends StatelessWidget {
  const FirstScreenAdvertisements({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ListDataFirstScreenAdvertisements()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
