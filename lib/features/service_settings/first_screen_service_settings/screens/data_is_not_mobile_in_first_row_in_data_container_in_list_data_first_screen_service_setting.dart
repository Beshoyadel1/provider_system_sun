import 'package:flutter/cupertino.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/first_screen_service_settings.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/container_return_to_page_setting.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/column_two_text_in_first_row_in_data_container_in_list_data_first_screen_service_setting.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/Container_image_in_first_row_in_data_container_in_list_data_first_screen_service_setting.dart';

class DataIsNotMobileInFirstRowInDataContainerInListDataFirstScreenServiceSetting
    extends StatelessWidget {
  final String? text1, text2, textContainer;
  final Function()? onTap;

  const DataIsNotMobileInFirstRowInDataContainerInListDataFirstScreenServiceSetting({
    super.key,
    this.text1,
    this.text2,
    this.textContainer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            spacing: 10,
            children: [
              const ContainerImageInFirstRowInDataContainerInListDataFirstScreenServiceSetting(),
              ColumnTwoTextInFirstRowInDataContainerInListDataFirstScreenServiceSetting(
                text1: text1,
                text2: text2,
              )
            ],
          ),
        ),
        ContainerReturnToPageSetting(
          text: textContainer,
          onTap: onTap ??
              () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    NavigateToPageWidget(const FirstScreenServiceSettings()));
              },
        )
      ],
    );
  }
}
