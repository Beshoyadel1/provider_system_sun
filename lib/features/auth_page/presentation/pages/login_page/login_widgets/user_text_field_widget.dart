import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/language/language.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/theming/colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

enum UserFieldType {
  normal,
  email,
  phone,
  name,
  password,
  gender,
  number,
}

class UserTextFieldWidget extends StatelessWidget {
  const UserTextFieldWidget({
    super.key,
    required this.controller,
    this.text,
    this.type = UserFieldType.normal,
    this.readOnly = false,
    this.width,
    this.height = 40,
    this.maxLines,
    this.borderColor,
    this.fillColor,
    this.focusedBorderColor,
    this.onChanged,
    // ⭐ New
    this.digitOnly = false,
    this.validator,
    this.showValidationMessage = false,
  });
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final String? text;
  final UserFieldType type;
  final bool readOnly;

  final double? width;
  final double? height;
  final int? maxLines;

  final Color? borderColor;
  final Color? fillColor;
  final Color? focusedBorderColor;

  final bool digitOnly;
  final String? Function(String?)? validator;
  final bool showValidationMessage;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    final fieldHeight = height ?? 40;

    Widget child;

    switch (type) {
      case UserFieldType.phone:
        if (readOnly) {
          child = TextFormFieldWidget(
            textFormController: controller,
            text: text ?? "",
            isColumn: true,
            readOnly: true,
            textSize: 16,
            borderColor: borderColor ?? AppColors.darkGreyColor,
            fillColor: fillColor ?? AppColors.whiteColor,
            textFormHeight: fieldHeight,
            maxLines: 1,
            isDigit: true,
            validator: validator,
            showValidationMessage: showValidationMessage,
            onChanged: onChanged,
          );
        } else {
          child = PhoneTextField(
            controller: controller,
            aboveText: text,
            height: fieldHeight,
            validator: validator,
            showValidationMessage: showValidationMessage,
            borderColor: borderColor ?? AppColors.darkGreyColor,
            fillColor: fillColor ?? AppColors.whiteColor,
            onChanged: onChanged,
            focusedBorderColor:
                focusedBorderColor ?? borderColor ?? AppColors.darkGreyColor,
          );
        }
        break;

      // =========================================================
      // GENDER
      // =========================================================
      case UserFieldType.gender:
        child = GenderField(
          controller: controller,
          text: text,
          readOnly: readOnly,
          validator: validator,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
        );
        break;

      // =========================================================
      // PASSWORD
      // =========================================================
      case UserFieldType.password:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
          obscureText: true,
          validator: validator,
          showValidationMessage: showValidationMessage,
          onChanged: onChanged,
        );
        break;

      // =========================================================
      // NUMBER
      // =========================================================
      case UserFieldType.number:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          isDigit: true,
          validator: validator,
          showValidationMessage: showValidationMessage,
          onChanged: onChanged,
        );
        break;

      // =========================================================
      // EMAIL
      // =========================================================
      case UserFieldType.email:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
          validator: validator,
          showValidationMessage: showValidationMessage,
          onChanged: onChanged,
        );
        break;

      // =========================================================
      // NAME
      // =========================================================
      case UserFieldType.name:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
          validator: validator,
          showValidationMessage: showValidationMessage,
          onChanged: onChanged,
        );
        break;

      // =========================================================
      // NORMAL
      // =========================================================
      case UserFieldType.normal:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: maxLines ?? 1,
          onChanged: onChanged,
          inputFormatters: digitOnly
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : null,
          isDigit: digitOnly,
          validator: validator,
          showValidationMessage: showValidationMessage,
        );
        break;
    }

    return SizedBox(
      width: isMobile ? double.infinity : (width ?? 500),
      child: child,
    );
  }
}

class GenderField extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final bool readOnly;
  final String? Function(String?)? validator;

  final Color borderColor;
  final Color fillColor;

  const GenderField({
    super.key,
    required this.controller,
    this.text,
    required this.readOnly,
    this.validator,
    this.borderColor = AppColors.darkGreyColor,
    this.fillColor = AppColors.whiteColor,
  });

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  String? selectedValue;

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
      selectedValue = "0";
    } else if (widget.controller.text == "1") {
      selectedValue = "1";
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
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: widget.text!,
              textSize: 14,
            ),
          ),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.borderColor,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: selectedValue,
              isExpanded: true,
              decoration: const InputDecoration.collapsed(
                hintText: '',
              ),
              validator: (value) {
                final result = widget.validator?.call(value);
                if (result == null) return null;

                return AppLocalizations.of(context).translate(result);
              },
              hint: const TextInAppWidget(
                text: AppLanguageKeys.selectGender,
                textSize: 14,
              ),
              items: const [
                DropdownMenuItem(
                  value: "0",
                  child: TextInAppWidget(
                    text: AppLanguageKeys.male,
                    textSize: 14,
                  ),
                ),
                DropdownMenuItem(
                  value: "1",
                  child: TextInAppWidget(
                    text: AppLanguageKeys.female,
                    textSize: 14,
                  ),
                ),
              ],
              onChanged: widget.readOnly
                  ? null
                  : (value) {
                      setState(() {
                        selectedValue = value;
                        widget.controller.text = value ?? "";
                      });
                    },
            ),
          ),
        )
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
    this.height,
    this.onChanged,
    this.validator,
    this.borderColor = AppColors.darkGreyColor,
    this.fillColor = AppColors.whiteColor,
    this.focusedBorderColor = AppColors.darkGreyColor,
    this.showValidationMessage = false,
  });
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  final TextEditingController controller;
  final String? aboveText;
  final bool isReadOnly;
  final double? height;
  final Color borderColor;
  final Color fillColor;
  final Color focusedBorderColor;
  final bool showValidationMessage;

  @override
  Widget build(BuildContext context) {
    // الرقم الموجود بالفعل في controller
    final String phoneValue = controller.text.trim();

    // IntlPhoneField يحتاج + في initialValue
    final String? initialPhone = phoneValue.isEmpty
        ? null
        : phoneValue.startsWith('+')
            ? phoneValue
            : '+$phoneValue';
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
        SizedBox(
          height: showValidationMessage ? null : (height! + 20),
          child: IntlPhoneField(
            initialValue: initialPhone,
            initialCountryCode: 'SA',
            languageCode: Localizations.localeOf(context).languageCode,
            invalidNumberMessage: AppLocalizations.of(context).translate(
              AppLanguageKeys.authEnterCorrectPhoneNumber,
            ),
            validator: (phone) {
              final number = phone?.number.trim() ?? '';
              final result = validator?.call(number);
              if (result != null) {
                return AppLocalizations.of(context).translate(result);
              }

              if (number.isNotEmpty && number.length < 6) {
                return AppLocalizations.of(context).translate(
                  AppLanguageKeys.phoneNumberAtLeastSixDigits,
                );
              }

              return null;
            },
            disableLengthCheck: true,
            readOnly: isReadOnly,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: const TextStyle(fontSize: 14, height: 1.2),
            dropdownTextStyle: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: focusedBorderColor,
                  width: 1.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
            ),
            flagsButtonPadding: const EdgeInsets.only(left: 6, right: 4),
            dropdownIconPosition: IconPosition.trailing,
            dropdownIcon: const Icon(Icons.arrow_drop_down, size: 18),
            onChanged: isReadOnly
                ? null
                : (phone) {
                    final localNumber = phone.number.trim();
                    final value = localNumber.isEmpty
                        ? ''
                        : phone.completeNumber.replaceFirst("+", "");

                    controller.text = value;

                    onChanged?.call(value);
                  },
          ),
        ),
      ],
    );
  }
}
