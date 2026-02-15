import 'package:flutter/cupertino.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/first_screen_service_settings.dart';
import '../../custom_widget/container_list_car_data_service_setting_widget.dart';
import '../../../../../../core/theming/assets.dart';

class ContainerListCarDataServiceSetting extends StatelessWidget {
  const ContainerListCarDataServiceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        ContainerListCarDataServiceSettingWidget(
          imagePath: AppImageKeys.logo10,
          nameModel: 'نيسان (جميع الفئات)',
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              NavigateToPageWidget(
                FirstScreenServiceSettings(),
              ),
            );
          },
        ),
        ContainerListCarDataServiceSettingWidget(
            imagePath: AppImageKeys.logo12, nameModel: '(4 Model) BMW '),
      ],
    );
  }
}
