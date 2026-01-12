import 'package:flutter/cupertino.dart';
import 'second_container_first_screen_car_model_settings/second_container_first_screen_car_model_settings.dart';
import 'first_title_in_first_container_in_data_container_in_list_data_first_screen_car_model_settings.dart';

class DataContainerInListDataFirstScreenCarModelSettings
    extends StatelessWidget {
  const DataContainerInListDataFirstScreenCarModelSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirstTitleInFirstContainerInDataContainerInListDataFirstScreenCarModelSettings(),
          SecondContainerFirstScreenCarModelSettings(),
        ],
      ),
    );
  }
}
