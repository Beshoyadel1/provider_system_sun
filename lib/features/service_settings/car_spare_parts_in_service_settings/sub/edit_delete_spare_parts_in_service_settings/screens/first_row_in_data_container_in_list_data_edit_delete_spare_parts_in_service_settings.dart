import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../../features/service_settings/custom_widget/button_edit_delete_setting_widget.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../core/theming/colors.dart';
import 'package:flutter/material.dart';


class FirstRowInDataContainerInListDataEditDeleteSparePartsInServiceSettings
    extends StatelessWidget {
  final String? nameProduct;
  final String nameCategory;
  final Uint8List? imageProduct;
  final void Function()? onTapDelete,onTapEdit;
  const FirstRowInDataContainerInListDataEditDeleteSparePartsInServiceSettings({
    super.key,
    required this.nameProduct,
    required this.nameCategory,
    this.imageProduct,
    this.onTapDelete,
    this.onTapEdit
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTab = size.width > ValuesOfAllApp.mobileWidth + 70;

    Widget image = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: imageProduct != null
          ? Image.memory(
        imageProduct!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      )
          : const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );

    Widget text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        TextInAppWidget(
          text: nameProduct??'أسم قطع غيار',
          textSize: 16,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.blackColor,
        ),
         TextInAppWidget(
          text: nameCategory,
          textSize: 14,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.orangeColor,
        ),
      ],
    );

    Widget buttonsRow = Row(
      children: [
        ButtonEditDeleteSettingWidget(
          onTap: onTapEdit,
        ),
        const SizedBox(width: 5),
        ButtonEditDeleteSettingWidget(
          isDelete: true,
          onTap: onTapDelete,
        ),
      ],
    );

    Widget buttonsColumn = Row(
      spacing: 5,
      children: [
        Expanded(child: ButtonEditDeleteSettingWidget(
          onTap: onTapEdit,
        )),
        Expanded(child: ButtonEditDeleteSettingWidget(isDelete: true,onTap: onTapDelete,)),
      ],
    );

    if (isTab) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              image,
              const SizedBox(width: 10),
              text,
            ],
          ),
          buttonsRow,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            image,
            const SizedBox(width: 10),
            Expanded(child: text),
          ],
        ),
        const SizedBox(height: 10),
        buttonsColumn,
      ],
    );
  }
}
