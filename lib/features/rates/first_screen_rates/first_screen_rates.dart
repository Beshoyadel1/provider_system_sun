import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/rates/first_screen_rates/logic/cubit_rates/provider_rates_cubit.dart';
import '../../../../../../features/rates/first_screen_rates/screens/list_data_first_screen_rate.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../core/theming/colors.dart';

class FirstScreenRates extends StatelessWidget {
  const FirstScreenRates({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;

    return BlocProvider(
      create: (context) => ProviderRatesCubit()..getProviderRates(providerId: 4),
      child: const Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(child: ListDataFirstScreenRate()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
