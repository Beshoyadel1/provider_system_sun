import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/memory_image_with_fallback.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

class ProductFormStyle {
  static const gap = 12.0;
  static ThemeData theme(BuildContext context) {
    final inherited = Theme.of(context);
    return inherited.copyWith(
      colorScheme: inherited.colorScheme.copyWith(
        primary: AppColors.orangeColor,
        secondary: AppColors.blueColor,
        error: AppColors.redColor,
        surface: AppColors.whiteColor,
        onSurface: AppColors.darkColor,
      ),
      textTheme: inherited.textTheme.apply(
        fontFamily: AppFonts.readexProFontFamily,
        bodyColor: AppColors.darkColor,
        displayColor: AppColors.darkColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.orangeColor,
        selectionHandleColor: AppColors.orangeColor,
        selectionColor: AppColors.orangeColor.withValues(alpha: 0.2),
      ),
    );
  }

  static double labelHeight(BuildContext context) =>
      math.max(18, MediaQuery.textScalerOf(context).scale(12) * 1.5);
  static double fieldHeight(BuildContext context) =>
      math.max(44, MediaQuery.textScalerOf(context).scale(14) * 1.6 + 20);
  static double pairHeight(BuildContext context) =>
      2 * (labelHeight(context) + 6 + fieldHeight(context)) + gap;

  static InputDecoration decoration(BuildContext context) => InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.whiteColor,
        constraints: BoxConstraints(minHeight: fieldHeight(context)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: _border(AppColors.darkColor.withValues(alpha: 0.2)),
        enabledBorder: _border(AppColors.darkColor.withValues(alpha: 0.2)),
        disabledBorder: _border(AppColors.lightGreyColor),
        focusedBorder: _border(AppColors.orangeColor, width: 1.5),
        errorBorder: _border(AppColors.redColor),
        focusedErrorBorder: _border(AppColors.redColor, width: 1.5),
        errorStyle: const TextStyle(
          fontFamily: AppFonts.readexProFontFamily,
          fontSize: 11,
          color: AppColors.redColor,
        ),
      );

  static OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  static const textStyle = TextStyle(
    fontFamily: AppFonts.readexProFontFamily,
    fontSize: 14,
    height: 1.4,
    color: AppColors.darkColor,
  );
}

class ProductFieldLabel extends StatelessWidget {
  const ProductFieldLabel(
      {super.key, required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: ProductFormStyle.labelHeight(context),
            child: TextInAppWidget(
              text: label,
              textSize: 12,
              textColor: AppColors.darkColor,
              maxLines: 1,
              isEllipsisTextOverflow: true,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      );
}

class ProductTextField extends StatelessWidget {
  const ProductTextField({
    super.key,
    required this.label,
    required this.controller,
    this.lines = 1,
    this.latin = false,
    this.validator,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final int lines;
  final bool latin;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => ProductFieldLabel(
        label: label,
        child: TextFormField(
          controller: controller,
          minLines: lines,
          maxLines: lines,
          keyboardType: keyboardType ??
              (lines > 1 ? TextInputType.multiline : TextInputType.text),
          textDirection: latin ? TextDirection.ltr : null,
          style: ProductFormStyle.textStyle,
          cursorColor: AppColors.orangeColor,
          decoration: ProductFormStyle.decoration(context),
          validator: validator ??
              (value) => value == null || value.trim().isEmpty
                  ? AppLocalizations.of(context)
                      .translate(AppLanguageKeys.enterYourData)
                  : null,
        ),
      );
}

class ProductDropdownField<T> extends StatelessWidget {
  const ProductDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) => ProductFieldLabel(
        label: label,
        child: DropdownButtonFormField<T>(
          key: ValueKey(value),
          initialValue: value,
          isDense: true,
          isExpanded: true,
          dropdownColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          style: ProductFormStyle.textStyle,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 20, color: AppColors.orangeColor),
          decoration: ProductFormStyle.decoration(context),
          items: items,
          onChanged: onChanged,
          validator: validator,
        ),
      );
}

class ProductToggleField extends StatelessWidget {
  const ProductToggleField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.trueText,
    required this.falseText,
  });
  final String label, trueText, falseText;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => ProductFieldLabel(
        label: label,
        child: Container(
          height: ProductFormStyle.fieldHeight(context),
          padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.darkColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(children: [
            Expanded(
              child: TextInAppWidget(
                text: value ? trueText : falseText,
                textSize: 13,
                textColor: AppColors.darkColor,
                maxLines: 1,
                isEllipsisTextOverflow: true,
              ),
            ),
            Switch(
              value: value,
              activeThumbColor: AppColors.orangeColor,
              activeTrackColor: AppColors.orangeColor.withValues(alpha: 0.25),
              inactiveThumbColor: AppColors.darkGreyColor,
              inactiveTrackColor: AppColors.veryLightGreyColor,
              trackOutlineColor:
                  const WidgetStatePropertyAll(AppColors.transparent),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
          ]),
        ),
      );
}

class ProductFormSection extends StatelessWidget {
  const ProductFormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardStroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Icon(icon, size: 20, color: AppColors.orangeColor),
              const SizedBox(width: 8),
              Expanded(
                child: TextInAppWidget(
                  text: title,
                  textSize: 15,
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                ),
              ),
            ]),
            const SizedBox(height: 14),
            child,
          ],
        ),
      );
}

/// Keeps repeated cards compact and wraps them as their available width changes.
class ProductCardsWrap extends StatelessWidget {
  const ProductCardsWrap({
    super.key,
    required this.children,
    this.minCardWidth = 280,
    this.maxCardWidth = 380,
  });
  final List<Widget> children;
  final double minCardWidth, maxCardWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final maxColumns = math.max(
              1,
              ((width + ProductFormStyle.gap) /
                      (minCardWidth + ProductFormStyle.gap))
                  .floor());
          final columns = math.min(
              maxColumns,
              math.max(
                  1,
                  ((width + ProductFormStyle.gap) /
                          (maxCardWidth + ProductFormStyle.gap))
                      .ceil()));
          final cardWidth = math.min(maxCardWidth,
              (width - (columns - 1) * ProductFormStyle.gap) / columns);
          return Wrap(
            spacing: ProductFormStyle.gap,
            runSpacing: ProductFormStyle.gap,
            children: [
              for (final child in children)
                SizedBox(
                  key: child.key == null ? null : ValueKey(child.key),
                  width: cardWidth,
                  child: child,
                ),
            ],
          );
        },
      );
}

class ProductBasicsLayout extends StatelessWidget {
  const ProductBasicsLayout({
    super.key,
    required this.image,
    required this.primaryColumn,
    required this.secondaryColumn,
  });
  final Widget image, primaryColumn, secondaryColumn;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final imageSide = ProductFormStyle.pairHeight(context);
          if (constraints.maxWidth >= imageSide + 424) {
            final fieldWidth =
                math.min(320.0, (constraints.maxWidth - imageSide - 24) / 2);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(dimension: imageSide, child: image),
                const SizedBox(width: 12),
                SizedBox(width: fieldWidth, child: primaryColumn),
                const SizedBox(width: 12),
                SizedBox(width: fieldWidth, child: secondaryColumn),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                  dimension: math.min(imageSide, constraints.maxWidth),
                  child: image),
              const SizedBox(height: 12),
              if (constraints.maxWidth >= 440)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: primaryColumn),
                    const SizedBox(width: 12),
                    Expanded(child: secondaryColumn),
                  ],
                )
              else ...[
                SizedBox(width: constraints.maxWidth, child: primaryColumn),
                const SizedBox(height: 12),
                SizedBox(width: constraints.maxWidth, child: secondaryColumn),
              ],
            ],
          );
        },
      );
}

class ProductImagePicker extends StatelessWidget {
  const ProductImagePicker(
      {super.key, required this.bytes, required this.onTap});
  final Uint8List? bytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    final placeholder = Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.add_photo_alternate_outlined,
            color: AppColors.orangeColor, size: 30),
        const SizedBox(height: 8),
        TextInAppWidget(
          text: ar ? 'صورة المنتج' : 'Product image',
          textSize: 12,
          textColor: AppColors.darkGreyColor,
          isTextCenter: true,
        ),
      ]),
    );
    return Tooltip(
      message: ar ? 'اختيار صورة المنتج' : 'Choose product image',
      child: Material(
        color: AppColors.scaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.cardStroke),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: MemoryImageWithFallback(
                  bytes: bytes,
                  fit: BoxFit.contain,
                  fallback: placeholder,
                ),
              ),
            ),
            if (bytes?.isNotEmpty == true)
              const PositionedDirectional(
                bottom: 6,
                end: 6,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.orangeColor,
                  child: Icon(Icons.edit_outlined,
                      size: 16, color: AppColors.whiteColor),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
