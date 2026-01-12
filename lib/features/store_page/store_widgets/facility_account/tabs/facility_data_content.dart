import 'package:flutter/material.dart';
import '../../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../general_widgets_in_store/attach_file.dart';

class FacilityDataContent extends StatefulWidget {
  const FacilityDataContent({super.key});

  @override
  State<FacilityDataContent> createState() => _FacilityDataContentState();
}

class _FacilityDataContentState extends State<FacilityDataContent> {
  @override
  Widget build(BuildContext context) {
    bool isMobile =
        MediaQuery.of(context).size.width < ValuesOfAllApp.mobileWidth;
    return Column(
      spacing: 30,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: fields.map((fieldName) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: isMobile ? double.infinity : 280,
                  child: TextFormFieldWidget(
                    textFormController: TextEditingController(),
                    text: fieldName,
                    textSize: 16,
                    isColumn: true,
                    textColor: AppColors.darkColor,
                    borderColor: AppColors.darkGreyColor,
                    //borderRadius: 20,
                    fillColor: AppColors.whiteColor,
                    textFormHeight: 35,
                  ),
                );
              },
            );
          }).toList(),
        ),
        const Wrap(
          spacing: 60,
          runSpacing: 10,
          children: [
            AttachFile(
              fileName: AppLanguageKeys.commercialRecordKey,
              fileType: 'commercial',
            ),
            AttachFile(
              fileName: AppLanguageKeys.ownerIdKey,
              fileType: 'owner',
            ),
          ],
        )
      ],
    );
  }
}

final List<String> fields = [
  AppLanguageKeys.facilityNameKey,
  AppLanguageKeys.facilityNameENKey,
  AppLanguageKeys.activityTypeKey,
  AppLanguageKeys.emailKey,
  AppLanguageKeys.passwordKey,
  AppLanguageKeys.phoneNumberKey,
  AppLanguageKeys.commercialRecordKey,
  AppLanguageKeys.taxNumberKey,
  AppLanguageKeys.shortAddressKey,
  AppLanguageKeys.buildingNumberKey,
  AppLanguageKeys.cityKey,
  AppLanguageKeys.buildingNumberKey,
];
