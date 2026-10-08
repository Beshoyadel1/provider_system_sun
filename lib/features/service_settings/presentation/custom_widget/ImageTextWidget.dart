import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/memory_image_with_fallback.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

class ImageTextWidget extends StatelessWidget {
  final Uint8List? image;
  final String? text;

  const ImageTextWidget({
    super.key,
     this.text,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔥 Image or Icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MemoryImageWithFallback(
              bytes: image,
              fit: BoxFit.cover,
              fallback: _buildIcon(),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: TextInAppWidget(
            text: text?? AppLanguageKeys.carModel,
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return const Icon(
      Icons.directions_car,
      color:  Colors.grey,
      size: 20,
    );
  }
}
