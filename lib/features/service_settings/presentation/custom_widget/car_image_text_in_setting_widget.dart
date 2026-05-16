import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/brand_model_create_prov_service_request.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class CarImageTextInSettingWidget extends StatelessWidget {
  final String text;
  final int modelId;
  final int brandId;
  final Uint8List? imageMemory;
  final TextEditingController priceController;
  final TextEditingController costController;

  const CarImageTextInSettingWidget({
    super.key,
    required this.text,
    required this.modelId,
    required this.brandId,
    required this.priceController,
    required this.costController,
    this.imageMemory,
  });

  void _updateCubit(BuildContext context) {
    final cubit = context.read<CreateProvServiceCubit>();

    final priceText = priceController.text.trim();
    final costText = costController.text.trim();

    final price = priceText.isEmpty ? null : double.tryParse(priceText);
    final cost = costText.isEmpty ? null : double.tryParse(costText);

    if (price == null && cost == null) {
      cubit.removeCarData(
        brandId: brandId,
        modelId: modelId,
      );
      return;
    }

    cubit.setCarData(
      brandId: brandId,
      modelId: modelId,
      price: price,
      cost: cost,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            _buildImage(),
            const SizedBox(height: 2),
            TextInAppWidget(
              text: text,
              textSize: 9,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
          ],
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Row(
            spacing: 10,
            children: [

              Expanded(
                child: TextFormFieldWidget(
                  hintText: AppLanguageKeys.price,
                  textFormController: priceController,
                  fillColor: AppColors.transparent,
                  borderColor:
                  AppColors.darkColor.withOpacity(0.2),
                  hintTextSize: 12,
                  hintTextColor: AppColors.orangeColor,
                  textSize: 15,
                  isDigit: true,
                  onChanged: (_) => _updateCubit(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLanguageKeys.enterYourData;
                    }
                    return null;
                  },
                ),
              ),

              /// 🔵 COST
              Expanded(
                child: TextFormFieldWidget(
                  hintText: AppLanguageKeys.cost,
                  textFormController: costController,
                  fillColor: AppColors.transparent,
                  borderColor:
                  AppColors.darkColor.withOpacity(0.2),
                  hintTextSize: 12,
                  hintTextColor: AppColors.orangeColor,
                  textSize: 15,
                  isDigit: true,
                  onChanged: (_) => _updateCubit(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLanguageKeys.enterYourData;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (imageMemory != null && imageMemory!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          imageMemory!,
          width: 50,
          height: 30,
          fit: BoxFit.cover,
        ),
      );
    }

    return const Icon(Icons.directions_car,
        size: 28, color: Colors.grey);
  }
}