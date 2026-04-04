import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/car_image_text_in_setting_widget.dart';


class DataViewOfPricePerCategory extends StatelessWidget {
  const DataViewOfPricePerCategory({super.key});

  @override
  Widget build(BuildContext context) {
     int itemCount = 4; // 🔥 your data length

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: (itemCount / 2).ceil(),
        itemBuilder: (context, index) {
          final firstIndex = index * 2;
          final secondIndex = firstIndex + 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: CarImageTextInSettingWidget(
                    imagePath: AppImageKeys.car500,
                    text: 'Car $firstIndex',
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: secondIndex < itemCount
                      ? CarImageTextInSettingWidget(
                    imagePath: AppImageKeys.car501,
                    text: 'Car $secondIndex',
                  )
                      : const SizedBox(), // if odd count
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}