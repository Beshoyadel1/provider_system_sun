import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'size_controllers.dart';
import 'product_form_widgets.dart';
import 'product_money_field.dart';
import 'product_stocks_editor.dart';

class SizeItemWidget extends StatelessWidget {
  const SizeItemWidget({
    super.key,
    required this.title,
    required this.controllers,
    required this.itemWidth,
    this.onDelete,
    this.onAdd,
    this.showDelete = true,
  });
  final SizeControllers controllers;
  final double itemWidth;
  final VoidCallback? onDelete, onAdd;
  final bool showDelete;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.cardStroke),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
                child: TextInAppWidget(
                    text: title,
                    textSize: 13,
                    textColor: AppColors.darkColor,
                    fontWeightIndex: FontSelectionData.mediumFontFamily)),
            IconButton(
                tooltip: ar ? 'إضافة مقاس' : 'Add size',
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline,
                    size: 22, color: AppColors.orangeColor)),
            if (showDelete)
              IconButton(
                  tooltip: ar ? 'حذف المقاس' : 'Remove size',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline,
                      size: 22, color: AppColors.redColor)),
          ]),
          const SizedBox(height: 8),
          ProductCardsWrap(
            minCardWidth: 140,
            maxCardWidth: 190,
            children: [
              ProductTextField(
                  label: AppLanguageKeys.name,
                  controller: controllers.nameController),
              ProductTextField(
                  label: AppLanguageKeys.latinName,
                  controller: controllers.latinNameController,
                  latin: true),
              ProductMoneyField(controller: controllers.priceController),
              ProductMoneyField(
                  controller: controllers.costController, cost: true),
            ],
          ),
          const SizedBox(height: 12),
          ProductStocksEditor(stocks: controllers.stocks),
        ],
      ),
    );
  }
}
