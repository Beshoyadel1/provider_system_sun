import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/advertisements/first_screen_advertisements/screens/last_button_in_list_data_first_screen_advertisements.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/edit_delete_spare_parts_in_service_settings.dart';
import '../../../../../../../../features/permissions/custom_widget/text_with_container_as_column_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../features/permissions/custom_widget/text_with_text_form_field_as_column_widget.dart';

class OtherDataDataContainerInListDataAddSparePartsInServiceSettings
    extends StatelessWidget {
  const OtherDataDataContainerInListDataAddSparePartsInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTab = size.width > 590;
    return isTab
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Row(
                spacing: 5,
                children: [
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.partName,
                    hint: '',
                  ),
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.spareCategory,
                    hint: '',
                    options: ['فئة الغيار2', 'فئة الغيار1', 'فئة الغيار3'],
                  ),
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.price,
                    hint: '',
                  ),
                  TextWithContainerAsColumnWidget(
                    title: AppLanguageKeys.sparePartImage,
                    textContainer: AppLanguageKeys.writeText,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.productDetails,
                    hint: '',
                    maxLines: 5,
                  ),
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.totalPartsInStock,
                    hint: '',
                    options: [
                      'totalPartsInStock5',
                      'totalPartsInStock1',
                      'totalPartsInStock2'
                    ],
                  ),
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.numberOfSizesIfAvailable,
                    hint: '',
                  ),
                ],
              ),
              LastButtonInListDataFirstScreenAdvertisements(
                text: AppLanguageKeys.save,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(NavigateToPageWidget(
                      const EditDeleteSparePartsInServiceSettings()));
                },
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Row(
                spacing: 5,
                children: [
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.partName,
                    hint: '',
                  ),
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.spareCategory,
                    hint: '',
                    options: ['فئة الغيار2', 'فئة الغيار1', 'فئة الغيار3'],
                  ),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.price,
                    hint: '',
                  ),
                  TextWithContainerAsColumnWidget(
                    title: AppLanguageKeys.sparePartImage,
                    textContainer: AppLanguageKeys.writeText,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.productDetails,
                    hint: '',
                    maxLines: 5,
                  ),
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.totalPartsInStock,
                    hint: '',
                    options: [
                      'totalPartsInStock5',
                      'totalPartsInStock1',
                      'totalPartsInStock2'
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  TextWithTextFormFieldAsColumnWidget(
                    text: AppLanguageKeys.numberOfSizesIfAvailable,
                    hint: '',
                  ),
                ],
              ),
              LastButtonInListDataFirstScreenAdvertisements(
                text: AppLanguageKeys.save,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(NavigateToPageWidget(
                      const EditDeleteSparePartsInServiceSettings()));
                },
              )
            ],
          );
  }
}
