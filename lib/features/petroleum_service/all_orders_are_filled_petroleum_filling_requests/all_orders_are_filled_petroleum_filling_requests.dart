import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../features/Petroleum_Service/All_Orders_Are_Filled_Petroleum_Filling_Requests/screens/list_data_All_Orders_Are_Filled_Petroleum_Filling_Requests.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';

class AllOrdersAreFilledPetroleumFillingRequests extends StatelessWidget {
  const AllOrdersAreFilledPetroleumFillingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;

    return const Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child:
                        ListDataAllOrdersAreFilledPetroleumFillingRequests()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
