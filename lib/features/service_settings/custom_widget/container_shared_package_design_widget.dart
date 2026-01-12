import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/service_settings/custom_widget/container_package_widget.dart';
import '../../../../../../../../features/internal_orders/custom_widget/row_number_coin_widget.dart';
import '../../../../../features/service_settings/custom_widget/row_text_correct.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/assets.dart';
import '../../car_model_settings/custom_widget/container_edit_delete_widget.dart';
import '../../../../../core/theming/colors.dart';

class ContainerSharedPackageDesignWidget extends StatelessWidget {
  final String textPackage, price;
  final void Function()? onPressedDelete, onPressedEdit;

  const ContainerSharedPackageDesignWidget(
      {super.key,
      required this.textPackage,
      required this.price,
      this.onPressedDelete,
      this.onPressedEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(10),
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
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 5,
            children: [
              ContainerEditDeleteWidget(
                size: 15,
                onPressed: onPressedEdit,
              ),
              ContainerEditDeleteWidget(
                isDelete: true,
                size: 15,
                onPressed: onPressedDelete,
              )
            ],
          ),
          ContainerPackageWidget(
            text: textPackage,
          ),
          RowNumberCoinWidget(
              numberText: price, sizeText: 15, imageSrc: AppImageKeys.coin),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              RowTextCorrect(text: AppLanguageKeys.fullCleaning),
              RowTextCorrect(text: AppLanguageKeys.interiorPolishing),
              RowTextCorrect(text: AppLanguageKeys.oilChange),
            ],
          )
        ],
      ),
    );
  }
}
