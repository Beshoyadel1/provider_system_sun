import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/text_with_text_form_field_as_column2_widget.dart';
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
    final width = MediaQuery.of(context).size.width;

    int itemsPerRow;
    if (width > 1000) {
      itemsPerRow = 4;
    } else if (width > 600) {
      itemsPerRow = 2;
    } else {
      itemsPerRow = 1;
    }

    final itemWidth = (width - ((itemsPerRow - 1) * 10)) / itemsPerRow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 20,
          children: [
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.name,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.latinName,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.taxes,
                   )),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.description, maxLines: 5)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.latinDesc, maxLines: 5)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                  text: AppLanguageKeys.productCategoryId,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.price,isDigit: true,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.cost,isDigit: true,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.inStock,isDigit: true,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.instructions,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.isNew,)),
            _item(
                itemWidth,
                TextWithTextFormFieldAsColumn2Widget(
                    text: AppLanguageKeys.sizes,)),
            _item(
                itemWidth,
                const TextWithContainerAsColumnWidget(
                  title: AppLanguageKeys.sparePartImage,
                  textContainer: AppLanguageKeys.attachImages,
                )),
          ],
        ),
        LastButtonInListDataFirstScreenAdvertisements(
          text: AppLanguageKeys.save,
          onTap: () {},
        ),
      ],
    );
  }
}

Widget _item(double width, Widget child) {
  return SizedBox(width: width, child: child);
}
