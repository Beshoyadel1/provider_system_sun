import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/car_model_settings/presentation/pages/first_screen_car_model_settings/screens/second_container_first_screen_car_model_settings/choose_brand_car/list_of_choose_brand_car_in_second_container_first_screen_car_brand_settings.dart';
import 'package:sun_web_system/features/car_model_settings/presentation/pages/first_screen_car_model_settings/screens/second_container_first_screen_car_model_settings/choose_model_car/title_choose_category.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'first_title_search_in_data_second_container_in_first_screen_car_model_settings.dart';

class DataSecondContainerInFirstScreenCarModelSettings extends StatelessWidget {
  const DataSecondContainerInFirstScreenCarModelSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocProvider(
        create: (_) => SelectCarModelSettingCubit()..fetchBrands(),
        child: const Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FirstTitleSearchInDataSecondContainerInFirstScreenCarModelSettings(),
            ListOfChooseBrandCarInSecondContainerFirstScreenCarBrandSettings(),
            TitleChooseCategory(),
           // ListOfChooseModelCarInSecondContainerFirstScreenCarModelSettings(),
            // TitleSelectYearModel(),
            // SelectYearModel(),
          ],
        ),
      ),
    );
  }
}
