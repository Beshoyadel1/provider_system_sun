import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:sun_web_system/features/auth_page/auth_cubit/auth_state.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../core/language/language.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../features/auth_page/auth_cubit/auth_cubit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/countries.dart';


enum UserFieldType {
  normal,
  email,
  phone,
  name,
  password,
  gender,
}

class UserTextFieldWidget extends StatelessWidget {
  const UserTextFieldWidget({
    super.key,
    required this.controller,
    this.text,
    this.type = UserFieldType.normal,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String? text;
  final UserFieldType type;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    Widget child;

    if (type == UserFieldType.phone) {
      if (readOnly) {
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: true,
          textSize: 16,
          borderColor: AppColors.darkGreyColor,
          fillColor: AppColors.whiteColor,
          textFormHeight: 35,

        );
      } else {
        child = PhoneTextField(
          controller: controller,
          aboveText: text,
        );
      }
    }

    else if (type == UserFieldType.gender) {
      child = GenderField(
        controller: controller,
        text: text,
        readOnly: readOnly,
      );
    }

    else {
      child = TextFormFieldWidget(
        textFormController: controller,
        text: text ?? "",
        isColumn: true,
        readOnly: readOnly,
        textSize: 16,
        borderColor: AppColors.darkGreyColor,
        fillColor: AppColors.whiteColor,
        textFormHeight: 35,
      );
    }

    return SizedBox(
      width: isMobile ? double.infinity : 500,
      child: child,
    );
  }
}

class GenderField extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final bool readOnly;

  const GenderField({
    super.key,
    required this.controller,
    this.text,
    required this.readOnly,
  });

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  int? selectedValue;

  @override
  void initState() {
    super.initState();
    _setValue();
  }

  @override
  void didUpdateWidget(covariant GenderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setValue();
  }

  void _setValue() {
    if (widget.controller.text == "0") {
      selectedValue = 0;
    } else if (widget.controller.text == "1") {
      selectedValue = 1;
    } else {
      selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.text != null)
          TextInAppWidget(
            text: widget.text!,
            textSize: 14,
          ),

        Row(
          children: [
            Expanded(
              child: RadioListTile<int>(
                value: 0,
                groupValue: selectedValue,
                title: const TextInAppWidget(
                  text: AppLanguageKeys.male,
                  textSize: 15,
                ),
                onChanged: widget.readOnly
                    ? null
                    : (v) {
                  setState(() {
                    selectedValue = v;
                    widget.controller.text = "0";
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                value: 1,
                groupValue: selectedValue,
                title: const TextInAppWidget(
                  text: AppLanguageKeys.female,
                  textSize: 15,
                ),
                onChanged: widget.readOnly
                    ? null
                    : (v) {
                  setState(() {
                    selectedValue = v;
                    widget.controller.text = "1";
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    this.aboveText,
    this.isReadOnly = false,
  });

  final TextEditingController controller;
  final String? aboveText;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (aboveText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: aboveText!,
              textSize: 14,
            ),
          ),

        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkGreyColor),
          ),

          child: Center(
            child: IntlPhoneField(
              initialCountryCode: 'EG',
              disableLengthCheck: true,
              readOnly: isReadOnly,

              textAlignVertical: TextAlignVertical.center,

              style: const TextStyle(
                fontSize: 14,
                height: 1.2,
              ),

              dropdownTextStyle: const TextStyle(
                fontSize: 14,
                height: 1.2,
              ),

              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true, // 🔥 ده الحل السحري
                contentPadding: EdgeInsets.zero,
              ),

              /// 🔹 المسافات
              flagsButtonPadding: const EdgeInsets.only(right: 6),
              dropdownIconPosition: IconPosition.trailing,

              onChanged: isReadOnly
                  ? null
                  : (phone) {
                controller.text =
                    phone.completeNumber.replaceFirst("+", "");
              },
            ),
          ),
        ),
      ],
    );
  }
}



