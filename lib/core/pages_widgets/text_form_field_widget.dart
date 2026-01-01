import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../language/language.dart';
import '../language/language_cubit/language_cubit.dart';
import '../setup_git_it.dart';
import '../theming/colors.dart';
import '../theming/fonts.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({super.key, required this.textFormController,this.textFormWidth,  this.text,  this.isValidator, this.enabled,
    this.suffixOnPressed, this.suffixIcon, this.textWidth, this.textSize, this.onChanged, this.isDatePicker, this.onPressedDate, this.readOnly, this.isDigit, this.isDigitDot, this.onEditingComplete, this.textHeight, this.textFormHeight, this.fontWeightIndex, this.hintText, this.textAlign, this.contentPadding, this.prefixIcon, this.suffixIconSize, this.prefixIconSize, this.prefixOnPressed, this.fillColor, this.borderColor, this.textColor, this.contentTextColor, this.focusBorderColor, this.maxLength, this.selectionColor, this.focusNode, this.nextFocusNode, this.maxLines, this.inputFormatters, this.isColumn, this.hintTextColor, this.isSpaceAfterText, this.obscureText, this.enabledBorderRadius, this.focusedBorderRadius, this.hintTextSize, this.prefixIconWidth, this.prefixIconHeight});

  final TextEditingController textFormController ;
  final String? text ;
  final bool? isValidator ;
  final bool? enabled ;
  final bool? isDigit ;
  final bool? isDigitDot ;
  final bool? readOnly ;
  final void Function()? suffixOnPressed ;
  final void Function()? prefixOnPressed ;
  final void Function()? onPressedDate ;
  final IconData? suffixIcon ;
  final double? suffixIconSize ;
  final String? prefixIcon ;
  final double? prefixIconSize ;
  final bool? isDatePicker;
  final double? textWidth ;
  final double? textHeight ;
  final double? textFormHeight ;
  final double? textFormWidth ;
  final double? textSize ;
  final void Function(String)? onChanged ;
  final void Function()? onEditingComplete ;
  final int? fontWeightIndex ;
  final String? hintText;
  final Color? hintTextColor;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? textColor;
  final Color? contentTextColor;
  final int? maxLength;
  final Color? selectionColor;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isColumn;
  final bool? isSpaceAfterText;
  final bool? obscureText;
  final  BorderRadius?enabledBorderRadius;
  final BorderRadius? focusedBorderRadius;
  final double? hintTextSize;
  final double? prefixIconWidth;
  final double? prefixIconHeight;


  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {

  final FocusNode focusNode = FocusNode();


  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  final LanguageCubit _languageCubit = getIt<LanguageCubit>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.greenColor,
          selectionColor: widget.selectionColor ?? AppColors.defaultColor.withValues(alpha: 0.4),
        ),
      ),
      child: widget.isColumn == true ?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widgetText(),
          widgetTextFormField(),

        ],
      ) :
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: widget.isSpaceAfterText == true ? 10 : 0,
        children: [
          widgetText(),
          Flexible(child: widgetTextFormField()),

        ],
      ),
    );
  }

  widgetText(){
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: widget.textWidth ,
        height:  widget.textHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( AppLocalizations.of(context).translate(widget.text ?? '')  ,
                style: TextStyle(
                    fontSize: (widget.textSize ?? (_languageCubit.isAllAppLanguageArabic ?  size.width*0.06 : size.width*0.05)) ,
                    fontWeight: fontWeightSelection(fontWeightIndex : widget.fontWeightIndex ) ,
                    fontFamily: fontSelection(),
                    color: widget.textColor ?? AppColors.darkColor
                )
            ),
            if(_languageCubit.isAllAppLanguageArabic)
              const SizedBox(height: 8,),
          ],
        )
    );
  }

  widgetTextFormField(){
    return SizedBox(
      width: widget.textFormWidth,
      height: widget.textFormHeight,
      child: TextFormField(
        maxLength: widget.maxLength ,
        focusNode: widget.focusNode ?? focusNode,
        textAlign: widget.textAlign ?? TextAlign.start,
        controller:  widget.textFormController,
        readOnly: widget.readOnly ?? false,
        maxLines: widget.maxLines ?? 1,
        obscureText: widget.obscureText ?? false,
        style:   TextStyle(
            fontSize: (widget.textSize ?? 20) ,
            fontWeight: fontWeightSelection(fontWeightIndex : widget.fontWeightIndex ) ,
            fontFamily: fontSelection(),
            color: widget.contentTextColor ?? AppColors.darkColor
        ),
        enabled: widget.enabled ?? true ,
        inputFormatters: widget.inputFormatters ?? <TextInputFormatter>[
          if (widget.isDigit == true)
            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          else if (widget.isDigitDot == true)
            FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+\.?\d{0,4}'))
        ],
        validator: (value) {
          if(widget.isValidator == true){
            if (!validateTextField(value!)) {
              return "";
            }
          }
          return null;
        },
        onTapOutside: (onTapOutside){
          focusNode.unfocus();
        },
        onEditingComplete: (){
          if(widget.maxLength != null){
            if(widget.textFormController.text.length == widget.maxLength!){
              FocusScope.of(context).nextFocus();
              widget.textFormController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget.textFormController.text.length,
              );
            }
          }
          else{
            if(widget.nextFocusNode != null){
              widget.nextFocusNode!.requestFocus();
            }
            else{
              (widget.focusNode ?? focusNode).unfocus();
            }
          }
        },
        onChanged: widget.onChanged ?? (value){
          if(widget.maxLength != null){
            if(value.length == widget.maxLength!){
              FocusScope.of(context).nextFocus();
              widget.textFormController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget.textFormController.text.length,
              );
            }
          }
        },
        onTap: (){
          (widget.focusNode ?? focusNode).addListener(() {
            if((widget.focusNode ?? focusNode).hasFocus) {
              widget.textFormController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget.textFormController.text.length,
              );
            }
          });
        },
        decoration: InputDecoration(
          counterText: widget.maxLength != null ? '' : null,
          errorStyle: const TextStyle(height: 0 , fontSize: 0),
          filled: true,
          fillColor: widget.fillColor ??  Colors.grey[300],
          contentPadding: widget.contentPadding ?? EdgeInsets.zero,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:  const BorderSide(color:  Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:widget.focusedBorderRadius?? BorderRadius.circular(25),
            borderSide: widget.focusBorderColor != null ? BorderSide(color: widget.focusBorderColor!) : widget.borderColor != null ? BorderSide(color: widget.borderColor!) : BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: widget.borderColor != null ? BorderSide(color: widget.borderColor!) : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.enabledBorderRadius??BorderRadius.circular(25),
            borderSide: widget.borderColor != null ? BorderSide(color: widget.borderColor!) : BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: widget.borderColor != null ? BorderSide(color: widget.borderColor!) : BorderSide.none,
          ),
          suffixIcon: widget.isDatePicker == true ?
          IconButton(
            padding: EdgeInsets.zero,
            alignment: AlignmentDirectional.centerEnd ,
            icon: Icon(Icons.date_range, size: widget.suffixIconSize ?? 29 ),
            onPressed: widget.onPressedDate,
          ) : widget.suffixIcon != null ?
          IconButton(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: EdgeInsets.zero,
            alignment:  AlignmentDirectional.center ,
            icon: Icon(widget.suffixIcon, size: widget.suffixIconSize ?? 29),
            onPressed: widget.suffixOnPressed,
          ) : null ,
          suffixIconColor: widget.suffixOnPressed != null ?  AppColors.darkGreyColor : Colors.grey,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.only(right: 15,top: 5,left: 5),
            child: Image.asset(
              widget.prefixIcon!,
              width: widget.prefixIconWidth ?? 19,
              height: widget.prefixIconHeight ?? 19,
            ),
          )
              : null,
          prefixIconConstraints: BoxConstraints(
            minWidth: 24,
            minHeight: 24,
          ),

          prefixIconColor: widget.prefixOnPressed != null ? AppColors.darkGreyColor : Colors.grey,
          hintMaxLines: 1,
          hintText:AppLocalizations.of(context).translate(widget.hintText ?? '') ,
          hintStyle: TextStyle(
            color: widget.hintTextColor ?? AppColors.darkColor.withValues(alpha: 0.7) ,
            fontSize: widget.hintTextSize ?? 15 ,
            fontFamily: fontSelection(),
            fontWeight: fontWeightSelection(fontWeightIndex : FontSelectionData.semiBoldFontFamily ) ,
          ),
        ),
      ),
    );
  }
}


bool validateTextField (String value) {
  if (value.isEmpty) {
    return false;
  }else {
    return true;
  }
}


