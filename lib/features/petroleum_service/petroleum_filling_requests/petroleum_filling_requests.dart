import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/petroleum_service/Petroleum_Filling_Requests/screens/design_crave_digram_for_petroleum/design_crave_digram_for_petroleum.dart';
import '../../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_digram_for_petroleum/design_digram_for_petroleum.dart';
import '../../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/list_data_Petroleum_Filling_Requests.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';

class PetroleumFillingRequests extends StatelessWidget {
  const PetroleumFillingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;

    return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: ListDataPetroleumFillingRequests(),
                  ),
                ),
              ),
              if ((!isMobile))
                const Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 20,
                        children: [
                          DesignDigramForPetroleum(),
                          DesignCraveDigramForPetroleum(),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
