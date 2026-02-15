import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/service_settings/custom_widget/row_data_correct_text.dart';
import '../../../../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/screens/part_two_package_in_data_container_in_list_data_add_shared_packages_in_service_settings.dart';
import '../../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/screens/Container_add_widget.dart';
import '../../../../../../../../features/service_settings/custom_widget/text_with_text_form_field_as_column2_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';

class PartOnePackageInDataContainerInListDataAddSharedPackagesInServiceSettings
    extends StatelessWidget {
  const PartOnePackageInDataContainerInListDataAddSharedPackagesInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTab = size.width > ValuesOfAllApp.customTabWidth - 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        TextWithTextFormFieldAsColumn2Widget(
          text: AppLanguageKeys.packageName,
          hint: AppLanguageKeys.specialPackage,
          textFormWidth: 350,
        ),
        Container(
          padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 10),
          width: 350,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 5,
                children: [
                  Flexible(
                    child: TextWithTextFormFieldAsColumn2Widget(
                      text: AppLanguageKeys.packageDescription,
                      hint: '',
                      textFormWidth: 300,
                    ),
                  ),
                  Flexible(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ContainerAddWidget(text: AppLanguageKeys.add),
                    ],
                  ))
                ],
              ),
              Column(
                spacing: 5,
                children: [
                  RowDataCorrectText(text: 'شامل جميع النظافة'),
                  RowDataCorrectText(text: 'تغيير زيوت '),
                  RowDataCorrectText(text: 'تظبيط زواية الاطار')
                ],
              )
            ],
          ),
        ),
        if (!isTab)
          PartTwoPackageInDataContainerInListDataAddSharedPackagesInServiceSettings(),
        ContainerAddWidget(
          text: AppLanguageKeys.save,
          colorBackGround: AppColors.orangeColor,
        ),
      ],
    );
  }
}
