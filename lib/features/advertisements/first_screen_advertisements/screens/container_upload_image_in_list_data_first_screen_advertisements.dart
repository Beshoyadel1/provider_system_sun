import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/advertisements/first_screen_advertisements/logic/upload_image_advertisements_cubit.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../core/language/language_constant.dart';
import '../logic/upload_image_advertisements_state.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';

class ContainerUploadImageInListDataFirstScreenAdvertisements
    extends StatelessWidget {
  const ContainerUploadImageInListDataFirstScreenAdvertisements({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadImageAdvertisementsCubit(),
      child: BlocBuilder<UploadImageAdvertisementsCubit,
          UploadImageAdvertisementsState>(
        buildWhen: (previous, current) =>
            current is UploadImageSelected || current is UploadImageInitial,
        builder: (context, state) {
          File? imageFile;
          if (state is UploadImageSelected) {
            imageFile = state.imageFile;
          }

          return InkWell(
            onTap: () {
              context.read<UploadImageAdvertisementsCubit>().pickImage();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.blackColor25,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageFile != null)
                    Image.file(imageFile, height: 100, fit: BoxFit.cover)
                  else
                    Image.asset(AppImageKeys.upload),
                  TextInAppWidget(
                    text: AppLanguageKeys.uploadImage,
                    textSize: 14,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.darkGreyColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
