import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/container_return_to_page_setting.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';

class DataViewOfUnifiedPriceForAll extends StatefulWidget {
  const DataViewOfUnifiedPriceForAll({super.key});

  @override
  State<DataViewOfUnifiedPriceForAll> createState() =>
      _DataViewOfUnifiedPriceForAllState();
}

class _DataViewOfUnifiedPriceForAllState
    extends State<DataViewOfUnifiedPriceForAll> {
  late TextEditingController textFormController2;

  @override
  void initState() {
    super.initState();
    textFormController2 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        spacing: 10,
        children: [
          TextFormFieldWidget(
            textFormController: textFormController2,
            fillColor: AppColors.transparent,
            borderColor: AppColors.darkColor.withOpacity(0.2),
            hintText: AppLanguageKeys.sar,
            hintTextSize: 12,
            hintTextColor: AppColors.orangeColor,
            textSize: 15,
            textFormWidth: 400,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          Row(
            children: [
              SizedBox(
                width: 150,
                child: ContainerReturnToPageSetting(
                  color: AppColors.orangeColor,
                  text: AppLanguageKeys.add,
                  icon: CupertinoIcons.add,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
