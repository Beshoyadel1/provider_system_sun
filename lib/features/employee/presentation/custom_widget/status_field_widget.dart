import 'package:flutter/material.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class StatusFieldWidget extends StatelessWidget {
  const StatusFieldWidget({
    super.key,
    required this.isActive,
    required this.isEditMode,
    this.width,
    this.height = 42,
    this.text,
    this.onChanged,
  });

  final bool isActive;
  final bool isEditMode;

  final double? width;
  final double height;

  final String? text;

  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final bool active = isActive;

    return SizedBox(
      width: width,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInAppWidget(
            text: text ?? AppLanguageKeys.status,
            textSize: 15,
            textColor: AppColors.blackColor,
            fontWeightIndex:
            FontSelectionData.regularFontFamily,
          ),

          Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.darkGreyColor.withOpacity(0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status indicator
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                const SizedBox(width: 8),

                // Status
                TextInAppWidget(
                  text: active
                      ? AppLanguageKeys.active
                      : AppLanguageKeys.inactive,
                  textSize: 14,
                  fontWeightIndex:
                  FontSelectionData.mediumFontFamily,
                  textColor: active
                      ? Colors.green
                      : Colors.red,
                ),

                // Switch only when editing
                if (isEditMode) ...[
                  const SizedBox(width: 8),

                  Switch(
                    value: active,
                    materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                    onChanged: onChanged,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}