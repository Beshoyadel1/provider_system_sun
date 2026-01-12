import 'package:flutter/cupertino.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../features/permissions/custom_widget/text_with_text_form_field_as_column_widget.dart';

class RowDataOfEstablishmentWidget extends StatelessWidget {
  final String? text1, text2, text3, text4, hint1, hint2, hint3, hint4;

  const RowDataOfEstablishmentWidget(
      {super.key,
      this.text1,
      this.hint1,
      this.text2,
      this.hint2,
      this.text3,
      this.hint3,
      this.text4,
      this.hint4});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        TextWithTextFormFieldAsColumnWidget(
          text: text1 ?? AppLanguageKeys.establishmentName,
          hint: hint1 ?? '',
          textFormHeight: 30,
        ),
        TextWithTextFormFieldAsColumnWidget(
          text: text2 ?? AppLanguageKeys.establishmentNameEn,
          hint: hint2 ?? '',
          textFormHeight: 30,
        ),
        TextWithTextFormFieldAsColumnWidget(
          text: text3 ?? AppLanguageKeys.activityType,
          hint: hint3 ?? '',
          textFormHeight: 30,
        ),
        TextWithTextFormFieldAsColumnWidget(
          text: text4 ?? AppLanguageKeys.email,
          hint: hint4 ?? '',
          textFormHeight: 30,
        ),
      ],
    );
  }
}
