import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/cars_haraj_page/logic/delete_harage_cubit/delete_harage_cubit.dart';
import 'package:sun_web_system/features/cars_haraj_page/logic/delete_harage_cubit/delete_harage_state.dart';

class DeleteDialog extends StatelessWidget {
  final int carId;

  const DeleteDialog({required this.carId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteHarageCubit, DeleteHarageState>(
      listener: (context, state) {
        if (state is DeleteHarageSuccess) {
          Navigator.pop(context);
          Navigator.pop(context, true);
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const TextInAppWidget(
          text: AppLanguageKeys.delete,
          textSize: 18,
          textColor: AppColors.redColor,
        ),
        content: const TextInAppWidget(
          text: AppLanguageKeys.confirmDelete,
          textSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 14,
            ),
          ),

          BlocBuilder<DeleteHarageCubit, DeleteHarageState>(
            builder: (context, state) {
              final isLoading = state is DeleteHarageLoading;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redColor,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                  context
                      .read<DeleteHarageCubit>()
                      .deleteHarage(harageId: carId);
                },
                child: isLoading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const TextInAppWidget(
                  textSize: 14,
                  text: AppLanguageKeys.delete,
                  textColor: AppColors.whiteColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}