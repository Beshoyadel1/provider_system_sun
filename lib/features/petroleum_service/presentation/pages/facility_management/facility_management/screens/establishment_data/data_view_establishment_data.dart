import 'package:flutter/cupertino.dart';
import '../../../../custom_widget/column_text_with_container_establishment_data_widget.dart';
import '../../../../custom_widget/row_data_of_establishment_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';

class DataViewEstablishmentData extends StatelessWidget {
  const DataViewEstablishmentData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowDataOfEstablishmentWidget(
          text1: AppLanguageKeys.establishmentName,
          text2: AppLanguageKeys.establishmentNameEn,
          text3: AppLanguageKeys.activityType,
          text4: AppLanguageKeys.email,
        ),
        RowDataOfEstablishmentWidget(
          text1: AppLanguageKeys.password,
          text2: AppLanguageKeys.phoneNumber,
          secondFieldIsPhone: true,
          text3: AppLanguageKeys.commercialRegistration,
          text4: AppLanguageKeys.taxNumber,
        ),
        RowDataOfEstablishmentWidget(
          text1: AppLanguageKeys.shortAddress4Letters,
          text2: AppLanguageKeys.buildingNumber,
          text3: AppLanguageKeys.city,
          text4: AppLanguageKeys.buildingNumber,
        ),
        Row(
          spacing: 20,
          children: [
            Flexible(
              child: ColumnTextWithContainerEstablishmentDataWidget(
                  text: AppLanguageKeys.commercialRecordCertificate,
                  textContainer: AppLanguageKeys.attachFile),
            ),
            Flexible(
              child: ColumnTextWithContainerEstablishmentDataWidget(
                  text: AppLanguageKeys.ownerIdOrResidenceCard,
                  textContainer: AppLanguageKeys.attachFile),
            ),
          ],
        ),
      ],
    );
  }
}
