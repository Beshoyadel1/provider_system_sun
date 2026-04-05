import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class CarImageTextInSettingWidget extends StatefulWidget {
  final String text;
  final int brandIndex;
  final int modelId;
  final Uint8List? imageMemory;

  const CarImageTextInSettingWidget({
    super.key,
    required this.text,
    required this.brandIndex,
    required this.modelId,
    this.imageMemory,
  });

  @override
  State<CarImageTextInSettingWidget> createState() =>
      _CarImageTextInSettingWidgetState();
}

class _CarImageTextInSettingWidgetState
    extends State<CarImageTextInSettingWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImage(),

              const SizedBox(height: 2),

              TextInAppWidget(
                text: widget.text,
                textSize: 9,
                fontWeightIndex:
                FontSelectionData.regularFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),

          const SizedBox(width: 8),

          Expanded(
            child: SizedBox(
              height: 50,
              child: TextFormFieldWidget(
                textFormController: controller,
                fillColor: AppColors.transparent,
                borderColor: AppColors.darkColor.withOpacity(0.2),
                hintText: AppLanguageKeys.sar,
                hintTextSize: 12,
                hintTextColor: AppColors.orangeColor,
                textSize: 15,
                textFormWidth: 400,
                isDigit: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                onChanged: (value) {

                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 Image أو Icon فقط
  Widget _buildImage() {
    if (widget.imageMemory != null &&
        widget.imageMemory!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          widget.imageMemory!,
          width: 50,
          height: 30,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _icon(),
        ),
      );
    }

    return _icon();
  }

  Widget _icon() {
    return const Icon(
      Icons.directions_car,
      size: 28,
      color: Colors.grey,
    );
  }
}
