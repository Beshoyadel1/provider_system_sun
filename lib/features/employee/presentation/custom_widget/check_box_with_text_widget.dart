import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/service_permission_cubit/service_permission_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/check_box_with_text_cubit/check_box_with_text_cubit.dart';


class CheckBoxWithText extends StatelessWidget {
  final int serviceId;
  final String text;
  final String? imageSelect;
  final Uint8List? imageBytes;
  final bool readOnly;

  const CheckBoxWithText({
    super.key,
    required this.serviceId,
    required this.text,
    this.imageSelect,
    this.imageBytes,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicePermissionCubit, List<int>>(
      builder: (context, selectedIds) {
        final isChecked = selectedIds.contains(serviceId);

        return InkWell(
          onTap: readOnly
              ? null
              : () {
            context.read<ServicePermissionCubit>().toggle(serviceId);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                activeColor: AppColors.orangeColor,
                value: isChecked,
                onChanged: readOnly
                    ? null
                    : (_) {
                  context
                      .read<ServicePermissionCubit>()
                      .toggle(serviceId);
                },
              ),
              Opacity(
                opacity: isChecked ? 1 : .5,
                child: Column(
                  children: [
                    imageBytes != null
                        ? Image.memory(
                      imageBytes!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    )
                        : Image.asset(
                      imageSelect ??
                          AppImageKeys.service33,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 5),
                    TextInAppWidget(
                      text: text,
                      textSize: 11,
                      fontWeightIndex:
                      FontSelectionData.regularFontFamily,
                      textColor: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}