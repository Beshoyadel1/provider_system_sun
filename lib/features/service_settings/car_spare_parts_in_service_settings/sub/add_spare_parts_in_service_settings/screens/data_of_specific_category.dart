import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../features/permissions/custom_widget/check_box_with_text_widget.dart';

class DataOfSpecificCategory extends StatelessWidget {
  const DataOfSpecificCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> texts = ['Ariya', 'CR-V', 'Koni', 'Ariya', 'CR-V'];
    final List<String> images = [
      AppImageKeys.car1,
      AppImageKeys.car2,
      AppImageKeys.car4,
      AppImageKeys.car3,
      AppImageKeys.car2,
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: texts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return CheckBoxWithText(
            text: texts[index],
            imageSelect: images[index],
          );
        },
      ),
    );
  }
}
